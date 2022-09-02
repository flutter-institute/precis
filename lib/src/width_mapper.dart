/// Class to abstract out functionality for mapping unicode varacters to their full width parts
class WidthMapper {
  static WidthMapper? _instance;
  factory WidthMapper.instance() {
    _instance ??= WidthMapper._();
    return _instance!;
  }

  WidthMapper._() : _widthMap = {} {
    _initMap();
  }

  final Map<String, String> _widthMap;

  Map<String, String> get widthMap {
    return _widthMap;
  }

  void _initMap() {
    // FullWidth ASCII variants (Latin Symbols, Punctuation, Numbers, Alphabet)
    for (var c = 0xFF01; c <= 0xFF5E; c++) {
      final mapping = c - 0xFEE0;
      _widthMap[String.fromCharCode(c)] = String.fromCharCode(mapping);
    }

    // Fullwidth brackets
    _widthMap['\uFF5F'] = '\u2985'; // FULLWIDTH LEFT WHITE PARENTHESIS
    _widthMap['\uFF60'] = '\u2986'; // FULLWIDTH RIGHT WHITE PARENTHESIS

    // Halfwidth CJK punctuation
    _widthMap['\uFF61'] = '\u3002'; // HALFWIDTH IDEOGRAPHIC FULL STOP
    _widthMap['\uFF62'] = '\u300C'; // HALFWIDTH LEFT CORNER BRACKET
    _widthMap['\uFF63'] = '\u300D'; // HALFWIDTH RIGHT CORNER BRACKET
    _widthMap['\uFF64'] = '\u3001'; // HALFWIDTH IDEOGRAPHIC COMMA

    // Halfwidth Katakana variants
    _widthMap['\uFF65'] = '\u30FB'; // HALFWIDTH KATAKANA MIDDLE DOT
    _widthMap['\uFF66'] = '\u30F2'; // HALFWIDTH KATAKANA LETTER WO
    _widthMap['\uFF67'] = '\u30A1'; // HALFWIDTH KATAKANA LETTER SMALL A
    _widthMap['\uFF68'] = '\u30A3'; // HALFWIDTH KATAKANA LETTER SMALL I
    _widthMap['\uFF69'] = '\u30A5'; // HALFWIDTH KATAKANA LETTER SMALL U
    _widthMap['\uFF6A'] = '\u30A7'; // HALFWIDTH KATAKANA LETTER SMALL E
    _widthMap['\uFF6B'] = '\u30A9'; // HALFWIDTH KATAKANA LETTER SMALL O
    _widthMap['\uFF6C'] = '\u30E3'; // HALFWIDTH KATAKANA LETTER SMALL YA
    _widthMap['\uFF6D'] = '\u30E5'; // HALFWIDTH KATAKANA LETTER SMALL YU
    _widthMap['\uFF6E'] = '\u30E7'; // HALFWIDTH KATAKANA LETTER SMALL YO
    _widthMap['\uFF6F'] = '\u30C3'; // HALFWIDTH KATAKANA LETTER SMALL TU
    _widthMap['\uFF70'] =
        '\u30FC'; // HALFWIDTH KATAKANA-HIRAGANA PROLONGED SOUND MARK
    _widthMap['\uFF71'] = '\u30A2'; // HALFWIDTH KATAKANA LETTER A
    _widthMap['\uFF72'] = '\u30A4'; // HALFWIDTH KATAKANA LETTER I
    _widthMap['\uFF73'] = '\u30A6'; // HALFWIDTH KATAKANA LETTER U
    _widthMap['\uFF74'] = '\u30A8'; // HALFWIDTH KATAKANA LETTER E
    _widthMap['\uFF75'] = '\u30AA'; // HALFWIDTH KATAKANA LETTER O
    _widthMap['\uFF76'] = '\u30AB'; // HALFWIDTH KATAKANA LETTER KA
    _widthMap['\uFF77'] = '\u30AD'; // HALFWIDTH KATAKANA LETTER KI
    _widthMap['\uFF78'] = '\u30AF'; // HALFWIDTH KATAKANA LETTER KU
    _widthMap['\uFF79'] = '\u30B1'; // HALFWIDTH KATAKANA LETTER KE
    _widthMap['\uFF7A'] = '\u30B3'; // HALFWIDTH KATAKANA LETTER KO
    _widthMap['\uFF7B'] = '\u30B5'; // HALFWIDTH KATAKANA LETTER SA
    _widthMap['\uFF7C'] = '\u30B7'; // HALFWIDTH KATAKANA LETTER SI
    _widthMap['\uFF7D'] = '\u30B9'; // HALFWIDTH KATAKANA LETTER SU
    _widthMap['\uFF7E'] = '\u30BB'; // HALFWIDTH KATAKANA LETTER SE
    _widthMap['\uFF7F'] = '\u30BD'; // HALFWIDTH KATAKANA LETTER SO
    _widthMap['\uFF80'] = '\u30BF'; // HALFWIDTH KATAKANA LETTER TA
    _widthMap['\uFF81'] = '\u30C1'; // HALFWIDTH KATAKANA LETTER TI
    _widthMap['\uFF82'] = '\u30C4'; // HALFWIDTH KATAKANA LETTER TU
    _widthMap['\uFF83'] = '\u30C6'; // HALFWIDTH KATAKANA LETTER TE
    _widthMap['\uFF84'] = '\u30C8'; // HALFWIDTH KATAKANA LETTER TO
    _widthMap['\uFF85'] = '\u30CA'; // HALFWIDTH KATAKANA LETTER NA
    _widthMap['\uFF86'] = '\u30CB'; // HALFWIDTH KATAKANA LETTER NI
    _widthMap['\uFF87'] = '\u30CC'; // HALFWIDTH KATAKANA LETTER NU
    _widthMap['\uFF88'] = '\u30CD'; // HALFWIDTH KATAKANA LETTER NE
    _widthMap['\uFF89'] = '\u30CE'; // HALFWIDTH KATAKANA LETTER NO
    _widthMap['\uFF8A'] = '\u30CF'; // HALFWIDTH KATAKANA LETTER HA
    _widthMap['\uFF8B'] = '\u30D2'; // HALFWIDTH KATAKANA LETTER HI
    _widthMap['\uFF8C'] = '\u30D5'; // HALFWIDTH KATAKANA LETTER HU
    _widthMap['\uFF8D'] = '\u30D8'; // HALFWIDTH KATAKANA LETTER HE
    _widthMap['\uFF8E'] = '\u30DB'; // HALFWIDTH KATAKANA LETTER HO
    _widthMap['\uFF8F'] = '\u30DE'; // HALFWIDTH KATAKANA LETTER MA
    _widthMap['\uFF90'] = '\u30DF'; // HALFWIDTH KATAKANA LETTER MI
    _widthMap['\uFF91'] = '\u30E0'; // HALFWIDTH KATAKANA LETTER MU
    _widthMap['\uFF92'] = '\u30E1'; // HALFWIDTH KATAKANA LETTER ME
    _widthMap['\uFF93'] = '\u30E2'; // HALFWIDTH KATAKANA LETTER MO
    _widthMap['\uFF94'] = '\u30E4'; // HALFWIDTH KATAKANA LETTER YA
    _widthMap['\uFF95'] = '\u30E6'; // HALFWIDTH KATAKANA LETTER YU
    _widthMap['\uFF96'] = '\u30E8'; // HALFWIDTH KATAKANA LETTER YO
    _widthMap['\uFF97'] = '\u30E9'; // HALFWIDTH KATAKANA LETTER RA
    _widthMap['\uFF98'] = '\u30EA'; // HALFWIDTH KATAKANA LETTER RI
    _widthMap['\uFF99'] = '\u30EB'; // HALFWIDTH KATAKANA LETTER RU
    _widthMap['\uFF9A'] = '\u30EC'; // HALFWIDTH KATAKANA LETTER RE
    _widthMap['\uFF9B'] = '\u30ED'; // HALFWIDTH KATAKANA LETTER RO
    _widthMap['\uFF9C'] = '\u30EF'; // HALFWIDTH KATAKANA LETTER WA
    _widthMap['\uFF9D'] = '\u30F3'; // HALFWIDTH KATAKANA LETTER N
    _widthMap['\uFF9E'] = '\u3099'; // HALFWIDTH KATAKANA VOICED SOUND MARK
    _widthMap['\uFF9F'] = '\u309A'; // HALFWIDTH KATAKANA SEMI-VOICED SOUND MARK

    // Halfwidth Hangul variants
    _widthMap['\uFFA0'] = '\u3164'; // HALFWIDTH HANGUL FILLER
    // KIYEOK - HIEUH
    for (var c = 0xFFA1; c <= 0xFFBE; c++) {
      final mapping = c - 0xCE70;
      _widthMap[String.fromCharCode(c)] = String.fromCharCode(mapping);
    }
    // A - E
    for (var c = 0xFFC2; c <= 0xFFC7; c++) {
      final mapping = c - 0xCE73;
      _widthMap[String.fromCharCode(c)] = String.fromCharCode(mapping);
    }
    // YEO - OE
    for (var c = 0xFFCA; c <= 0xFFCF; c++) {
      final mapping = c - 0xCE75;
      _widthMap[String.fromCharCode(c)] = String.fromCharCode(mapping);
    }
    // YO - YU
    for (var c = 0xFFD2; c <= 0xFFD7; c++) {
      final mapping = c - 0xCE77;
      _widthMap[String.fromCharCode(c)] = String.fromCharCode(mapping);
    }

    _widthMap['\uFFDA'] = '\u3161'; // HALFWIDTH HANGUL LETTER EU
    _widthMap['\uFFDB'] = '\u3162'; // HALFWIDTH HANGUL LETTER YI
    _widthMap['\uFFDC'] = '\u3163'; // HALFWIDTH HANGUL LETTER I

    // Fullwidth symbol variants
    _widthMap['\uFFE0'] = '\u00A2'; // FULLWIDTH CENT SIGN
    _widthMap['\uFFE1'] = '\u00A3'; // FULLWIDTH POUND SIGN
    _widthMap['\uFFE2'] = '\u00AC'; // FULLWIDTH NOT SIGN
    _widthMap['\uFFE3'] = '\u00AF'; // FULLWIDTH MACRON
    _widthMap['\uFFE4'] = '\u00A6'; // FULLWIDTH BROKEN BAR
    _widthMap['\uFFE5'] = '\u00A5'; // FULLWIDTH YEN SIGN
    _widthMap['\uFFE6'] = '\u20A9'; // FULLWIDTH WON SIGN

    // Halfwidth symbol variants
    _widthMap['\uFFE8'] = '\u2502'; // HALFWIDTH FORMS LIGHT VERTICAL
    _widthMap['\uFFE9'] = '\u2190'; // HALFWIDTH LEFTWARDS ARROW
    _widthMap['\uFFEA'] = '\u2191'; // HALFWIDTH UPWARDS ARROW
    _widthMap['\uFFEB'] = '\u2192'; // HALFWIDTH RIGHTWARDS ARROW
    _widthMap['\uFFEC'] = '\u2193'; // HALFWIDTH DOWNWARDS ARROW
    _widthMap['\uFFED'] = '\u25A0'; // HALFWIDTH BLACK SQUARE
    _widthMap['\uFFEE'] = '\u25CB'; // HALFWIDTH WHITE CIRCLE
  }
}
