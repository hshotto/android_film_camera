import 'dart:io';
import 'package:film_camera/models/film_type.dart';
import 'package:film_camera/view_models/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('필름 카메라'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 촬영한 이미지가 있는지 확인
              SizedBox(
                width: 300,
                height: 400,
                child: context.watch<HomeViewModel>().imgPath != null
                    ? Image.file(
                        File(context.read<HomeViewModel>().imgPath!),
                        fit: BoxFit.cover,
                      )
                    : Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                        ),
                        child: const Icon(Icons.camera_alt,
                            size: 48, color: Colors.grey),
                      ),
              ),
              const SizedBox(height: 30),

              // 필름 선택 섹션
              const Text(
                '필름 선택',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // 필름 목록
              Consumer<HomeViewModel>(
                builder: (context, viewModel, child) {
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: FilmType.values.map((film) {
                      final isSelected = viewModel.selectedFilm == film;
                      return GestureDetector(
                        onTap: () {
                          viewModel.selectFilm(film);
                        },
                        child: Container(
                          width: 140,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue[100]
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.grey[300]!,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                film.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.blue[900]
                                      : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                film.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSelected
                                      ? Colors.blue[700]
                                      : Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 30),

              // 사진 촬영 버튼
              SizedBox(
                width: 300,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<HomeViewModel>().openCamera(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    '사진 촬영',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
