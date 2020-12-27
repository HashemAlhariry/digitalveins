import 'package:digitalveins/Entities/global.dart';
import 'package:digitalveins/Entities/user.dart';
import 'package:digitalveins/Screens/homepage.dart';
import 'package:digitalveins/Screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void>  main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Global.prefs =await SharedPreferences.getInstance();

  // Data saved for logged in user //
  var id=Global.prefs.getInt('id');
  var phone=Global.prefs.getString('phone');
  var name=Global.prefs.getString('name');
  var latitude=Global.prefs.getDouble('latitude');
  var longitude=Global.prefs.getDouble('longitude');
  var address=Global.prefs.getString('address');
  var password =Global.prefs.getString('password');

  if(phone != null) {
    User user = new User(id, phone, name, latitude, longitude, address,password);
    Global.loginUser = user;
  }

  runApp(
   MaterialApp(
        debugShowCheckedModeBanner: false,
        home:  phone ==null ? SignUp() : HomePage()
  ));


}
