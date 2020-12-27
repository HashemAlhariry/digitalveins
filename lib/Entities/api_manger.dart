import 'package:http/http.dart' as http;
import 'package:digitalveins/Entities/user.dart';
import 'dart:convert';

Future<Map<String, dynamic>> signUp (String apiName,User user) async {
  try{

    final response= await  http.post(apiName,
        headers: {"Content-Type": "application/json"},
        body:json.encode({
          "name":user.name,
          "phone": user.phone,
          "longitude":user.longitude,
          "latitude": user.latitude,
          "password": user.password,
          "password_confirmation": user.password
        })
    );
    var convertDatatoJson =  response.body;
    Map<String, dynamic> convert;
    if(!convertDatatoJson.contains("user_exist")) {
      convert =json.decode(response.body);
    }
    else{
      return null;
    }
    return convert;

  }catch(Excepetion)
  {
    print(Excepetion);
    return Excepetion;
  }
}

Future<Map<String, dynamic>> loginUser (String apiName, String mobileNumber , String password) async {
  try {

    final response = await http.post(apiName,
        headers:{"Content-Type": "application/json"},
        body:json.encode({
          "phone":mobileNumber,
          "password": password,

        })
        );
    if(response.body.isNotEmpty) {
      Map<String, dynamic> convertDatatoJson =  json.decode(response.body);

      return  convertDatatoJson;

    }
    return null;
  }
  catch (Excepetion) {
    print(Excepetion);
    return null;
  }
}
Future<Map<String, dynamic>> getData (String apiName) async {
  try {

    final response = await http.get(apiName,
        headers:{"Content-Type": "application/json"},
    );
    if(response.body.isNotEmpty) {
      Map<String, dynamic> convertDatatoJson =  json.decode(response.body);

      return  convertDatatoJson;

    }
    return null;
  }
  catch (Excepetion) {
    print(Excepetion);
    return null;
  }
}
