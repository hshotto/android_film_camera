import 'dart:io';
import 'package:camera/camera.dart';
import 'package:film_camera/models/film_type.dart';
import 'package:film_camera/utils/film_color_filter.dart';
import 'package:film_camera/view_models/camera_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  String _selectedMode = '사진';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CameraViewModel>().initializeCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Consumer<CameraViewModel>(
          builder: (context, viewModel, child) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                viewModel.selectedFilm.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
        centerTitle: true,
        actions: [
          // 설정
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
          // 즐겨찾기
          IconButton(
            icon: const Icon(Icons.star_border, color: Colors.white),
            onPressed: () {},
          ),
          // 플래시
          IconButton(
            icon: const Icon(Icons.flash_off, color: Colors.white),
            onPressed: () {},
          ),
          // 필터
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.white),
            onPressed: () {},
          ),
          // 밝기 (태양 아이콘)
          IconButton(
            icon: const Icon(Icons.wb_sunny, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<CameraViewModel>(
        builder: (context, viewModel, child) {
          // 로딩 중
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          // 에러 발생
          if (viewModel.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.errorMessage!,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('돌아가기'),
                  ),
                ],
              ),
            );
          }

          // 카메라 미리보기
          if (viewModel.isInitialized && viewModel.controller != null) {
            return Stack(
              children: [
                // 카메라 미리보기 (전체 화면) - 필름 효과 적용
                Positioned.fill(
                  child: ColorFiltered(
                    colorFilter: FilmColorFilter.getColorFilter(viewModel.selectedFilm) ?? const ColorFilter.matrix([
                      1.0, 0.0, 0.0, 0.0, 0.0,
                      0.0, 1.0, 0.0, 0.0, 0.0,
                      0.0, 0.0, 1.0, 0.0, 0.0,
                      0.0, 0.0, 0.0, 1.0, 0.0,
                    ]),
                    child: CameraPreview(viewModel.controller!),
                  ),
                ),

                // 하단 UI 바
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black.withOpacity(0.7),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 모드 선택 (공시, 사진, 동영상, 더보기)
                        Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildModeButton('공시', '공시'),
                              _buildModeButton('사진', '사진'),
                              _buildModeButton('동영상', '동영상'),
                              _buildModeButton('더보기', '더보기'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        // 하단 컨트롤 (썸네일, 셔터, 카메라 전환)
                        Container(
                          height: 100,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // 왼쪽: 썸네일 (마지막 촬영 사진)
                              GestureDetector(
                                onTap: () {
                                  // 썸네일 클릭 시 갤러리 열기 등
                                },
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: viewModel.lastImagePath != null &&
                                          File(viewModel.lastImagePath!).existsSync()
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(6),
                                          child: Image.file(
                                            File(viewModel.lastImagePath!),
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : const Icon(Icons.image, color: Colors.white70),
                                ),
                              ),
                              // 중앙: 셔터 버튼
                              GestureDetector(
                                onTap: () async {
                                  final imagePath = await viewModel.takePicture(context);
                                  if (imagePath != null && mounted) {
                                    // 홈뷰로 가지 않고 카메라 화면에 그대로 남음
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('사진이 갤러리에 저장되었습니다.'),
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  } else if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('사진 촬영에 실패했습니다.'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey[300]!, width: 4),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              // 오른쪽: 카메라 전환 버튼
                              IconButton(
                                icon: const Icon(
                                  Icons.cameraswitch,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).padding.bottom),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        },
      ),
    );
  }

  Widget _buildModeButton(String text, String mode) {
    final isSelected = _selectedMode == mode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMode = mode;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    context.read<CameraViewModel>().dispose();
    super.dispose();
  }
}
