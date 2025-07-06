import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _preferences;

  // Keys for storing data
  static const String _affectionLevelKey = 'affection_level';
  static const String _totalInteractionsKey = 'total_interactions';
  static const String _lastLoginKey = 'last_login';
  static const String _dailyQuoteShownKey = 'daily_quote_shown';
  static const String _userNameKey = 'user_name';
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _themeKey = 'theme_mode';

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Affection Level
  static int getAffectionLevel() {
    return _preferences.getInt(_affectionLevelKey) ?? 0;
  }

  static Future<void> setAffectionLevel(int level) async {
    await _preferences.setInt(_affectionLevelKey, level);
  }

  static Future<void> incrementAffection([int points = 1]) async {
    final currentLevel = getAffectionLevel();
    await setAffectionLevel(currentLevel + points);
  }

  // Total Interactions
  static int getTotalInteractions() {
    return _preferences.getInt(_totalInteractionsKey) ?? 0;
  }

  static Future<void> incrementInteractions() async {
    final current = getTotalInteractions();
    await _preferences.setInt(_totalInteractionsKey, current + 1);
  }

  // Last Login
  static DateTime? getLastLogin() {
    final timestamp = _preferences.getString(_lastLoginKey);
    if (timestamp == null) return null;
    return DateTime.parse(timestamp);
  }

  static Future<void> setLastLogin(DateTime date) async {
    await _preferences.setString(_lastLoginKey, date.toIso8601String());
  }

  // Daily Quote
  static String getDailyQuoteShown() {
    return _preferences.getString(_dailyQuoteShownKey) ?? '';
  }

  static Future<void> setDailyQuoteShown(String date) async {
    await _preferences.setString(_dailyQuoteShownKey, date);
  }

  // User Name
  static String getUserName() {
    return _preferences.getString(_userNameKey) ?? 'User';
  }

  static Future<void> setUserName(String name) async {
    await _preferences.setString(_userNameKey, name);
  }

  // Notifications
  static bool getNotificationsEnabled() {
    return _preferences.getBool(_notificationsEnabledKey) ?? true;
  }

  static Future<void> setNotificationsEnabled(bool enabled) async {
    await _preferences.setBool(_notificationsEnabledKey, enabled);
  }

  // Theme
  static String getThemeMode() {
    return _preferences.getString(_themeKey) ?? 'system';
  }

  static Future<void> setThemeMode(String mode) async {
    await _preferences.setString(_themeKey, mode);
  }

  // Check if it's a new day
  static bool isNewDay() {
    final lastLogin = getLastLogin();
    if (lastLogin == null) return true;
    
    final now = DateTime.now();
    return now.day != lastLogin.day || 
           now.month != lastLogin.month || 
           now.year != lastLogin.year;
  }

  // Daily login reward
  static Future<int> processDailyLogin() async {
    if (isNewDay()) {
      await setLastLogin(DateTime.now());
      await incrementAffection(5); // Daily login bonus
      return 5;
    }
    return 0;
  }
}