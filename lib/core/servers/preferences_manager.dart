import 'package:shared_preferences/shared_preferences.dart';

// //(Singleton Pattern):

class PreferencesManager {
  static final PreferencesManager _instance = PreferencesManager._internal();
  //  احنا مش عايزين نستخدمه  من خارج الكلاس  -->   _instance
  //static هيتكريت مرة وحدة علي مدار الابلكيشن كله

  factory PreferencesManager() {
    return _instance; // Singleton يستطيع أن يقرر هل يُنشئ كائناً جديداً، أم يُرجع كائناً موجوداً مسبقاً factory
  }

  PreferencesManager._internal(); //private constructor [مش هنعرف ناخد اوبجكت من الكلاس دا ]

  late final SharedPreferences _preferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // ================= Setters =================
  Future<bool> setString(String key, String value) async =>
      await _preferences.setString(key, value);

  Future<bool> setBool(String key, bool value) async =>
      await _preferences.setBool(key, value);

  Future<bool> setInt(String key, int value) async =>
      await _preferences.setInt(key, value);

  Future<bool> setDouble(String key, double value) async =>
      await _preferences.setDouble(key, value);

  Future<bool> setStringList(String key, List<String> value) async =>
      await _preferences.setStringList(key, value);

  // ================= Getters =================
  String? getString(String key) => _preferences.getString(key);

  bool? getBool(String key) => _preferences.getBool(key);

  int? getInt(String key) => _preferences.getInt(key);

  double? getDouble(String key) => _preferences.getDouble(key);

  List<String>? getStringList(String key) => _preferences.getStringList(key);

  // Dynamic getter لجلب أي نوع داتا
  Object? getData(String key) => _preferences.get(key);

  // ================= Helpers & Delete =================
  // التحقق من وجود المفتاح
  bool containsKey(String key) => _preferences.containsKey(key);

  // جلب كل المفاتيح المخزنة
  Set<String> getKeys() => _preferences.getKeys();

  // مسح عنصر معين
  Future<bool> remove(String key) async => await _preferences.remove(key);

  // مسح كل البيانات المخزنة بالكامل
  Future<bool> clearAll() async => await _preferences.clear();
}
