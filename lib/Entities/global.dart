import 'package:digitalveins/Entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global{

  static SharedPreferences prefs;
  static User loginUser = new User.empty();
  static bool visible_progress=false;

}