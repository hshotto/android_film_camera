import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';
import 'package:film_camera/models/film_type.dart';
import 'package:film_camera/utils/film_effect.dart';

class CameraViewModel with ChangeNotifier {
  final FilmType selectedFilm;
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isLoading = true;
  String? _errorMessage;
  String? _lastImagePath; // 마지막 촬영 사진 경로

  CameraViewModel({this.selectedFilm = FilmType.kodakGold});

  CameraController? get controller => _controller;
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get lastImagePath => _lastImagePath;

  Future<void> initializeCamera() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // 사용 가능한 카메라 목록 가져오기
      _cameras = await availableCameras();

      if (_cameras == null || _cameras!.isEmpty) {
        _errorMessage = '사용 가능한 카메라가 없습니다.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // 후면 카메라 우선 사용, 없으면 첫 번째 카메라 사용
      final camera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras!.first,
      );

      // 카메라 컨트롤러 초기화
      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      _isInitialized = true;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = '카메라 초기화 실패: $e';
      _isLoading = false;
      _isInitialized = false;
      notifyListeners();
    }
  }

  Future<String?> takePicture(BuildContext context) async {
    if (!_isInitialized || _controller == null || !_controller!.value.isInitialized) {
      return null;
    }

    try {
      // 사진 촬영
      final XFile image = await _controller!.takePicture();

      // 앱 디렉토리 가져오기
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String appDocPath = appDocDir.path;
      final String fileName = 'film_camera_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = '$appDocPath/$fileName';

      // 사진을 앱 디렉토리로 복사
      await image.saveTo(filePath);

      // 선택된 필름 효과 적용
      try {
        final processedImage = await FilmEffect.applyFilmEffect(
          filePath,
          filmType: selectedFilm,
        );
        await File(filePath).writeAsBytes(processedImage);
        debugPrint('${selectedFilm.name} 필름 효과 적용 완료');
      } catch (e) {
        debugPrint('필름 효과 적용 실패: $e');
        // 필름 효과 실패해도 원본 이미지는 저장됨
      }

      // 갤러리에 저장
      try {
        await Gal.putImage(filePath);
        debugPrint('갤러리에 저장 완료: $filePath');
      } catch (e) {
        debugPrint('갤러리 저장 중 오류 발생: $e');
        // 갤러리 저장 실패해도 앱 디렉토리에는 저장되어 있음
      }

      // 마지막 촬영 사진 경로 저장
      _lastImagePath = filePath;
      notifyListeners();

      return filePath;
    } catch (e) {
      debugPrint('사진 촬영 실패: $e');
      return null;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    _isInitialized = false;
    super.dispose();
  }
}

