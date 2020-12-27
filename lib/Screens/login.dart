import 'package:digitalveins/Entities/api_manger.dart';
import 'package:digitalveins/Entities/global.dart';
import 'package:digitalveins/Entities/user.dart';
import 'package:digitalveins/Entities/validation.dart';
import 'package:digitalveins/Screens/homepage.dart';
import 'package:digitalveins/Screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class Login extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Login>  with Validation {


  String mobileNumber='';
  String password='';
  Position position;
  final formKey = GlobalKey <FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[

                Container(margin: EdgeInsets.only(top:10.0),),
                Container(
                  margin: EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        mobileField(),
                        passwordField(),
                        Container(margin: EdgeInsets.only(top:25.0),),
                        submitButton()

                      ],
                    ),
                  ),
                ),
                Container(
                    child: Row(
                      children: <Widget>[

                        Text("Don't have account" ,style: TextStyle(
                          ),),
                        FlatButton(
                          child: Text(
                            "Create Account",
                            style: TextStyle(fontSize: 15,

                              fontWeight: FontWeight.w500,),
                          ),
                          onPressed: () {


                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>SignUp()
                            ));
                          },
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    )),



              ],
            )));
  }


  Widget mobileField(){

    return TextFormField(

      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText:"Mobile Field",

      ),
      validator:validateMobileNumber ,
      onSaved: (String value){
        mobileNumber=value;
      },
    );
  }
  Widget passwordField() {
    return  TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Password Field",
      ),
      validator: validatePassword ,
      onSaved: (String value){
        password=value;
      },
    );
  }


  //Map_Appear:  0 customer, 1 shop, 2  pharmacy, 3 restaurant , 4 atara , 9 delivery , 10 free delivery man
  Widget submitButton() {
    if(Global.visible_progress){
      return CircularProgressIndicator();
    }
    else
      return Container(
        height: 40,
        width: 120,
        child:RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          child: Text("Login" ,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15
            ),),
          onPressed: () {

            if(formKey.currentState.validate()){

              setState(() {
                Global.visible_progress=true;
              });
              formKey.currentState.save();
              loginUser("https://www.goomlah.com/public/api/users/login",mobileNumber, password).then((value) {
                if(value['message']=="Login Success."){



                  // set user data here to save when log in again
                  Global.prefs.setInt('id',value['user']['id']);
                  Global.prefs.setString('phone',value['user']['phone']);
                  Global.prefs.setString('name',value['user']['name']);
                  Global.prefs.setDouble('latitude',value['user']['latitude']);
                  Global.prefs.setDouble('longitude',value['user']['longitude']);
                  Global.prefs.setString('address',value['user']['address']);
                  Global.prefs.setString('password',value['user']['password']);

                  User user =new User(value['user']['id'], value['user']['phone'],
                      value['user']['name'], value['user']['latitude'],value['user']['longitude'],
                      value['user']['address'], value['user']['password']);
                  Global.loginUser=user;


                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context)=>HomePage()));


                }else{
                  Global.toastMessage(value['message']);
                  setState(() {
                    Global.visible_progress=false;
                  });
                }

              });
            }

          },
        ) ,
      );

  }



}