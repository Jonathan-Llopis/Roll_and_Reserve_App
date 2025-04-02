
final Map<String, List<String>> monthNamesByLanguage = {
  'en': ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
  'es': ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
  'fr': ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'],
  'ca': ['Gen', 'Feb', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Oct', 'Nov', 'Des']

};

/// Returns a list of month names for the given language code.
/// 
/// If the specified [languageCode] is not found, it defaults to English month names.
/// 
/// [languageCode] should be a valid two-letter language code like 'en', 'es', 'fr', etc.
/// 
/// Returns a list of abbreviated month names as strings or null if the language code is invalid.

List<String>? getMonthNames(String languageCode) {
  return monthNamesByLanguage[languageCode] ?? monthNamesByLanguage['en'];
}