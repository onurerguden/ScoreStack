import 'package:shared_preferences/shared_preferences.dart';

//SARP DEMİRTAŞ - 20220601016
//ONUR ERGÜDEN - 20220601030

class UpdateCheckerService {
  static const String _lastUpdateKey = 'lastUpdateTime';
  static const eightHours = 8 * 60 * 60 * 1000;
  static const int _updateThresholdMillis = eightHours;

  static Future<void> saveLastUpdateTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<bool> shouldUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdateTime = prefs.getInt(_lastUpdateKey) ?? 0;
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    final diffInHours = (currentTime - lastUpdateTime) / (1000 * 60 * 60);

    print("[UpdateCheckerService] Last update was $diffInHours hours ago.");

    bool needsUpdate = (currentTime - lastUpdateTime) > _updateThresholdMillis;
    if (needsUpdate) {
      print(
        "[UpdateCheckerService] !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 8 saat geçti, veri güncellenecek.!!!!!!!!!!!!!!!!!!!!!!!!!!!!",
      );
    } else {
      print(
        "[UpdateCheckerService] OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO 8 saat geçmedi, veri güncellenmeyecek.00000000000000000000000000000000000000",
      );
    }
    return needsUpdate;
  }
}
