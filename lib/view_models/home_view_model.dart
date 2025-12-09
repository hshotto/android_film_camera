import 'package:film_camera/models/film_type.dart';
import 'package:film_camera/view_models/camera_view_model.dart';
import 'package:film_camera/views/camera_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeViewModel with ChangeNotifier {
  String? imgPath;
  FilmType selectedFilm = FilmType.kodakGold; // 기본 필름

  void selectFilm(FilmType film) {
    selectedFilm = film;
    notifyListeners();
  }

  void openCamera(BuildContext context) async {
    // CameraView가 닫힐 때 반환된 값을 저장
    String? tempImg = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => CameraViewModel(selectedFilm: selectedFilm),
          child: const CameraView(),
        ),
      ),
    );

    if (tempImg != null) {
      imgPath = tempImg;
    } else {
      debugPrint('Image path error');
    }

    notifyListeners();
  }
}
