/// 필름 타입 enum
enum FilmType {
  kodakGold,
  fujiColor,
  kodakPortra,
  fujiSuperia,
  blackWhite,
  vintage,
}

extension FilmTypeExtension on FilmType {
  String get name {
    switch (this) {
      case FilmType.kodakGold:
        return '코닥 골드';
      case FilmType.fujiColor:
        return '후지필름 컬러';
      case FilmType.kodakPortra:
        return '코닥 포트라';
      case FilmType.fujiSuperia:
        return '후지필름 수페리아';
      case FilmType.blackWhite:
        return '흑백 필름';
      case FilmType.vintage:
        return '빈티지 필름';
    }
  }

  String get description {
    switch (this) {
      case FilmType.kodakGold:
        return '따뜻하고 부드러운 색감';
      case FilmType.fujiColor:
        return '밝고 선명한 색감';
      case FilmType.kodakPortra:
        return '자연스러운 피부톤';
      case FilmType.fujiSuperia:
        return '생생한 색감';
      case FilmType.blackWhite:
        return '클래식한 흑백';
      case FilmType.vintage:
        return '레트로 느낌';
    }
  }
}
