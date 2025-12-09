import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:image/image.dart' as img;
import 'package:film_camera/models/film_type.dart';

/// 필름 효과를 적용하는 유틸리티 클래스
class FilmEffect {
  /// 필름 효과 적용
  static Future<Uint8List> applyFilmEffect(
    String imagePath, {
    FilmType filmType = FilmType.kodakGold,
  }) async {
    // 이미지 파일 읽기
    final imageBytes = await File(imagePath).readAsBytes();
    img.Image? image = img.decodeImage(imageBytes);

    if (image == null) {
      throw Exception('이미지를 로드할 수 없습니다.');
    }

    // 선택된 필름 타입에 따라 효과 적용
    switch (filmType) {
      case FilmType.kodakGold:
        image = _applyKodakGold(image);
        break;
      case FilmType.fujiColor:
        image = _applyFujiColor(image);
        break;
      case FilmType.kodakPortra:
        image = _applyKodakPortra(image);
        break;
      case FilmType.fujiSuperia:
        image = _applyFujiSuperia(image);
        break;
      case FilmType.blackWhite:
        image = _applyBlackWhite(image);
        break;
      case FilmType.vintage:
        image = _applyVintage(image);
        break;
    }

    // JPEG로 인코딩
    return Uint8List.fromList(img.encodeJpg(image, quality: 90));
  }

  /// 코닥 골드 효과 (따뜻하고 부드러운 색감)
  static img.Image _applyKodakGold(img.Image image) {
    image = _applyVintageTone(image, rFactor: 1.1, gFactor: 1.05, bFactor: 0.95);
    image = _addGrain(image, intensity: 0.2);
    image = _adjustContrast(image, 1.05);
    image = _adjustSaturation(image, 0.95);
    return image;
  }

  /// 후지필름 컬러 효과 (밝고 선명한 색감)
  static img.Image _applyFujiColor(img.Image image) {
    image = _applyVintageTone(image, rFactor: 1.0, gFactor: 1.1, bFactor: 1.05);
    image = _addGrain(image, intensity: 0.15);
    image = _adjustContrast(image, 1.15);
    image = _adjustSaturation(image, 1.1);
    return image;
  }

  /// 코닥 포트라 효과 (자연스러운 피부톤)
  static img.Image _applyKodakPortra(img.Image image) {
    image = _applyVintageTone(image, rFactor: 1.05, gFactor: 1.0, bFactor: 0.98);
    image = _addGrain(image, intensity: 0.1);
    image = _adjustContrast(image, 1.0);
    image = _adjustSaturation(image, 0.9);
    return image;
  }

  /// 후지필름 수페리아 효과 (생생한 색감)
  static img.Image _applyFujiSuperia(img.Image image) {
    image = _applyVintageTone(image, rFactor: 1.05, gFactor: 1.08, bFactor: 1.02);
    image = _addGrain(image, intensity: 0.18);
    image = _adjustContrast(image, 1.1);
    image = _adjustSaturation(image, 1.05);
    return image;
  }

  /// 흑백 필름 효과
  static img.Image _applyBlackWhite(img.Image image) {
    final copy = img.Image(width: image.width, height: image.height);
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final r = pixel.r;
        final g = pixel.g;
        final b = pixel.b;

        // 그레이스케일 변환
        final gray = (r * 0.299 + g * 0.587 + b * 0.114).toInt();
        copy.setPixel(x, y, img.ColorRgb8(gray, gray, gray));
      }
    }
    image = _addGrain(copy, intensity: 0.25);
    image = _adjustContrast(image, 1.2);
    return image;
  }

  /// 빈티지 필름 효과 (레트로 느낌)
  static img.Image _applyVintage(img.Image image) {
    image = _applyVintageTone(image, rFactor: 1.15, gFactor: 1.0, bFactor: 0.9);
    image = _addGrain(image, intensity: 0.3);
    image = _adjustContrast(image, 1.1);
    image = _adjustSaturation(image, 0.85);
    return image;
  }

  /// 빈티지 톤 적용 (색감 조정)
  static img.Image _applyVintageTone(
    img.Image image, {
    double rFactor = 1.1,
    double gFactor = 1.05,
    double bFactor = 0.95,
  }) {
    final copy = img.Image(width: image.width, height: image.height);
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final r = pixel.r;
        final g = pixel.g;
        final b = pixel.b;

        // 색감 조정
        int newR = (r * rFactor).clamp(0, 255).toInt();
        int newG = (g * gFactor).clamp(0, 255).toInt();
        int newB = (b * bFactor).clamp(0, 255).toInt();

        copy.setPixel(x, y, img.ColorRgb8(newR, newG, newB));
      }
    }
    return copy;
  }

  /// 그레인 노이즈 추가 (필름 느낌)
  static img.Image _addGrain(img.Image image, {double intensity = 0.3}) {
    final random = math.Random();
    final copy = img.Image.from(image);

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        if (random.nextDouble() < intensity) {
          final pixel = copy.getPixel(x, y);
          final r = pixel.r;
          final g = pixel.g;
          final b = pixel.b;

          // 랜덤 노이즈 추가
          final noise = (random.nextDouble() - 0.5) * 20;
          int newR = (r + noise).clamp(0, 255).toInt();
          int newG = (g + noise).clamp(0, 255).toInt();
          int newB = (b + noise).clamp(0, 255).toInt();

          copy.setPixel(x, y, img.ColorRgb8(newR, newG, newB));
        }
      }
    }
    return copy;
  }

  /// 대비 조정
  static img.Image _adjustContrast(img.Image image, double factor) {
    final copy = img.Image(width: image.width, height: image.height);
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final r = pixel.r;
        final g = pixel.g;
        final b = pixel.b;

        // 대비 조정
        int newR = ((r - 128) * factor + 128).clamp(0, 255).toInt();
        int newG = ((g - 128) * factor + 128).clamp(0, 255).toInt();
        int newB = ((b - 128) * factor + 128).clamp(0, 255).toInt();

        copy.setPixel(x, y, img.ColorRgb8(newR, newG, newB));
      }
    }
    return copy;
  }

  /// 채도 조정
  static img.Image _adjustSaturation(img.Image image, double factor) {
    final copy = img.Image(width: image.width, height: image.height);
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final r = pixel.r;
        final g = pixel.g;
        final b = pixel.b;

        // 그레이스케일 계산
        final gray = (r * 0.299 + g * 0.587 + b * 0.114).toInt();

        // 채도 조정
        int newR = (gray + (r - gray) * factor).clamp(0, 255).toInt();
        int newG = (gray + (g - gray) * factor).clamp(0, 255).toInt();
        int newB = (gray + (b - gray) * factor).clamp(0, 255).toInt();

        copy.setPixel(x, y, img.ColorRgb8(newR, newG, newB));
      }
    }
    return copy;
  }
}
