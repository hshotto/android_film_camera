import 'package:flutter/material.dart';
import 'package:film_camera/models/film_type.dart';

/// 필름 타입에 따른 ColorFilter 생성
class FilmColorFilter {
  /// 필름 타입에 맞는 ColorFilter 반환
  static ColorFilter? getColorFilter(FilmType filmType) {
    switch (filmType) {
      case FilmType.kodakGold:
        // 따뜻하고 부드러운 색감 (빨강/노랑 강조)
        return const ColorFilter.matrix([
          1.1, 0.0, 0.0, 0.0, 0.0, // Red
          0.0, 1.05, 0.0, 0.0, 0.0, // Green
          0.0, 0.0, 0.95, 0.0, 0.0, // Blue
          0.0, 0.0, 0.0, 1.0, 0.0, // Alpha
        ]);

      case FilmType.fujiColor:
        // 밝고 선명한 색감
        return const ColorFilter.matrix([
          1.0, 0.0, 0.0, 0.0, 0.0, // Red
          0.0, 1.1, 0.0, 0.0, 0.0, // Green
          0.0, 0.0, 1.05, 0.0, 0.0, // Blue
          0.0, 0.0, 0.0, 1.0, 0.0, // Alpha
        ]);

      case FilmType.kodakPortra:
        // 자연스러운 피부톤
        return const ColorFilter.matrix([
          1.05, 0.0, 0.0, 0.0, 0.0, // Red
          0.0, 1.0, 0.0, 0.0, 0.0, // Green
          0.0, 0.0, 0.98, 0.0, 0.0, // Blue
          0.0, 0.0, 0.0, 1.0, 0.0, // Alpha
        ]);

      case FilmType.fujiSuperia:
        // 생생한 색감
        return const ColorFilter.matrix([
          1.05, 0.0, 0.0, 0.0, 0.0, // Red
          0.0, 1.08, 0.0, 0.0, 0.0, // Green
          0.0, 0.0, 1.02, 0.0, 0.0, // Blue
          0.0, 0.0, 0.0, 1.0, 0.0, // Alpha
        ]);

      case FilmType.blackWhite:
        // 흑백 필터
        return const ColorFilter.matrix([
          0.299, 0.587, 0.114, 0.0, 0.0, // Red to Gray
          0.299, 0.587, 0.114, 0.0, 0.0, // Green to Gray
          0.299, 0.587, 0.114, 0.0, 0.0, // Blue to Gray
          0.0, 0.0, 0.0, 1.0, 0.0, // Alpha
        ]);

      case FilmType.vintage:
        // 빈티지 느낌 (따뜻하고 노란 톤)
        return const ColorFilter.matrix([
          1.15, 0.0, 0.0, 0.0, 0.0, // Red
          0.0, 1.0, 0.0, 0.0, 0.0, // Green
          0.0, 0.0, 0.9, 0.0, 0.0, // Blue
          0.0, 0.0, 0.0, 1.0, 0.0, // Alpha
        ]);
    }
  }
}

