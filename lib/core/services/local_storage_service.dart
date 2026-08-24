import 'package:shared_preferences/shared_preferences.dart';

/// Wraps SharedPreferences so the rest of the app never talks to it
/// directly. Add new keys here as more features need local persistence.
class LocalStorageService {
  static const String _keyAgeGroup = 'age_group';
  static const String _keyHasSeenOnboarding = 'has_seen_onboarding';

  /// Saves the selected age group as a string: 'teen1315' or 'teen1618'.
  Future<void> saveAgeGroup(String ageGroup) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAgeGroup, ageGroup);
  }

  /// Returns 'teen1315', 'teen1618', or null if never set.
  Future<String?> getAgeGroup() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAgeGroup);
  }

  Future<void> setHasSeenOnboarding(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasSeenOnboarding, value);
  }

  Future<bool> getHasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasSeenOnboarding) ?? false;
  }
}
