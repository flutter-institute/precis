// ignore_for_file: constant_identifier_names

/// Shortcut to convert a character code to a string
const _2c = String.fromCharCode;

class UnicodeKeyMap {
  /// Map characters that need to be width mapped
  /// key - original character
  /// value - replacement character
  static late final Map<String, String>? _widthMap;

  /// Get the character mappings orig -> replacement
  static Map<String, String> getWidthMap() {
    _widthMap ??= _initializeMap();
    return _widthMap!;
  }

  static Map<String, String> _initializeMap() {
    /// Map characters that need to be width mapped
    /// key - original character
    /// value - replacement character
    final map = <String, String>{
      // Brackets
      '\uFF5F': '\u2985', // left white paraenthesis
      '\uFF60': '\u2986', // right white paraenthesis
      // CJK Punctuation
      '\uFF61': '\u3002', // ideographic full stop
      '\uFF62': '\u300C', // left corner brakcet
      '\uFF63': '\u300D', // right corner bracket
      '\uFF64': '\u3001', // ideographic comma
      // Katakana Variants
      '\uFF65': '\u30FB', // middle dot
      '\uFF66': '\u30F2', // letter WO
      '\uFF67': '\u30A1', // letter small A
      '\uFF68': '\u30A3', // letter small I
      '\uFF69': '\u30A5', // letter small U
      '\uFF6A': '\u30A7', // letter small E
      '\uFF6B': '\u30A9', // letter small O
      '\uFF6C': '\u30E3', // letter small YA
      '\uFF6D': '\u30E5', // letter small YU
      '\uFF6E': '\u30E7', // letter small YO
      '\uFF6F': '\u30C3', // letter small TU
      '\uFF70': '\u30FC', // prolonged sound mark
      '\uFF71': '\u30A2', // letter A
      '\uFF72': '\u30A4', // letter I
      '\uFF73': '\u30A6', // letter U
      '\uFF74': '\u30A8', // letter E
      '\uFF75': '\u30AA', // letter O
      '\uFF76': '\u30AB', // letter KA
      '\uFF77': '\u30AD', // letter KI
      '\uFF78': '\u30AF', // letter KU
      '\uFF79': '\u30B1', // letter KE
      '\uFF7A': '\u30B3', // letter KO
      '\uFF7B': '\u30B5', // letter SA
      '\uFF7C': '\u30B7', // letter SI
      '\uFF7D': '\u30B9', // letter SU
      '\uFF7E': '\u30BB', // letter SE
      '\uFF7F': '\u30BD', // letter SO
      '\uFF80': '\u30BF', // letter TA
      '\uFF81': '\u30C1', // letter TI
      '\uFF82': '\u30C4', // letter TU
      '\uFF83': '\u30C6', // letter TE
      '\uFF84': '\u30C8', // letter TO
      '\uFF85': '\u30CA', // letter NA
      '\uFF86': '\u30CB', // letter NI
      '\uFF87': '\u30CC', // letter NU
      '\uFF88': '\u30CD', // letter NE
      '\uFF89': '\u30CE', // letter NO
      '\uFF8A': '\u30CF', // letter HA
      '\uFF8B': '\u30D2', // letter HI
      '\uFF8C': '\u30D5', // letter HU
      '\uFF8D': '\u30D8', // letter HE
      '\uFF8E': '\u30DB', // letter HO
      '\uFF8F': '\u30DE', // letter MA
      '\uFF90': '\u30DF', // letter MI
      '\uFF91': '\u30E0', // letter MU
      '\uFF92': '\u30E1', // letter ME
      '\uFF93': '\u30E2', // letter MO
      '\uFF94': '\u30E4', // letter YA
      '\uFF95': '\u30E6', // letter YU
      '\uFF96': '\u30E8', // letter YO
      '\uFF97': '\u30E9', // letter RA
      '\uFF98': '\u30EA', // letter RI
      '\uFF99': '\u30EB', // letter RU
      '\uFF9A': '\u30EC', // letter RE
      '\uFF9B': '\u30ED', // letter RO
      '\uFF9C': '\u30EF', // letter WA
      '\uFF9D': '\u30F3', // letter N
      '\uFF9E': '\u3099', // voice sound mark
      '\uFF9F': '\u309A', // semi-voiced sound mark
      // Hangul static
      '\uFFA0': '\u3164', // hangul filler
      '\uFFDA': '\u3161', // letter EU
      '\uFFDB': '\u3162', // letter YI
      '\uFFDC': '\u3163', // letter I
      // Fullwidth symbol variants
      '\uFFE0': '\u00A2', // cent sign
      '\uFFE1': '\u00A3', // pound sign
      '\uFFE2': '\u00AC', // not sign
      '\uFFE3': '\u00AF', // macron
      '\uFFE4': '\u00A6', // broken bar
      '\uFFE5': '\u00A5', // yen sign
      '\uFFE6': '\u00A9', // won sign
      // Halfwidth symbol variants
      '\uFFE8': '\u2502', // forms light vertical
      '\uFFE9': '\u2190', // lefwards arrow
      '\uFFEA': '\u2191', // upwards arrow
      '\uFFEB': '\u2192', // rightwards arrow
      '\uFFEC': '\u2193', // downwards arrow
      '\uFFED': '\u25A0', // black square
      '\uFFEE': '\u25CB', // white circle
    };

    // Fullwidth ASCII variants (Latin Symbols, Punctuation, Numbers, Alphabet)
    for (var c = 0xFF01; c <= 0xFF53; c++) {
      map[_2c(c)] = _2c(c - 0xFEE0);
    }

    // Hangul variables
    // KIYEOK - HIEUH
    for (var c = 0xFFA1; c <= 0xFFBE; c++) {
      map[_2c(c)] = _2c(c - 0xCE70);
    }
    // A - E
    for (var c = 0xFFC2; c <= 0xFFC7; c++) {
      map[_2c(c)] = _2c(c - 0xCE73);
    }
    // YEO - OE
    for (var c = 0xFFCA; c <= 0xFFCF; c++) {
      map[_2c(c)] = _2c(c - 0xCE75);
    }
    // YO - YU
    for (var c = 0xFFD2; c <= 0xFFD7; c++) {
      map[_2c(c)] = _2c(c - 0xCE77);
    }

    return map;
  }
}
