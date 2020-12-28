import 'package:digitalveins/Entities/api_manger.dart';
import 'package:digitalveins/Entities/global.dart';
import 'package:digitalveins/Entities/user.dart';
import 'package:digitalveins/Entities/validation.dart';
import 'package:digitalveins/Screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'login.dart';


class SignUp extends StatefulWidget  {
  @override
  _State createState() => _State();
}

class _State extends State<SignUp> with Validation {

  String userName='';
  String phone='';
  String password='';
  String confirmPassword='';
  Position position=null;
  List<Address> address;
  String latitude="";
  String longitude="";


  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  final formKey = GlobalKey <FormState>();
  final TextEditingController _confirmPass = TextEditingController();
  final TextEditingController _pass = TextEditingController();



  void _getCurrentLocation() async {
    try{
      geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position _position) {
        setState(() {
          position = _position;
          latitude = position.latitude.toString();
          longitude =position.longitude.toString();
          print(position.latitude);
          print(position.longitude);
        }); } );
    }on Exception{
      print(Exception);
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[

                Container(margin: EdgeInsets.only(top:10.0),),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [

                        nameField(),
                        mobileField(),
                        passwordField(),
                        passwordFieldConfirmation(),
                        Container(margin: EdgeInsets.only(top:10.0),),
                        Text(
                          'position',
                          style: TextStyle(fontSize: 15,
                            fontWeight: FontWeight.w500,),
                        ),
                        Text(
                          'Latitude: '+latitude+' Longitude: '+longitude,
                          style: TextStyle(fontSize: 15,
                            fontWeight: FontWeight.w500,),
                        ),
                        getLocation(),
                        Container(margin: EdgeInsets.only(top:30.0),),
                        submitButton(),
                        Container(margin: EdgeInsets.only(top:5.0),),

                      ],
                    ),
                  ),
                ),
                sendToLogin(),

              ],
            )));

  }
  Widget nameField(){
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText:'Name Field',

      ),
      validator: validateUserName,
      onSaved: (String value){
        userName=value;
      },
    );
  }

  Widget mobileField()
  {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Mobile Field",
      ),
      validator: validateMobileNumber,
      onSaved: (String value){
        phone=value;
      },
    );
  }

  Widget passwordField() {
    return  TextFormField(
      controller: _pass,
      obscureText: true,

      decoration: InputDecoration(
        labelText:  "Password Field",
        hintText: '',
      ),
      validator: validatePassword ,
      onSaved: (String value){
        password=value;
      },
    );
  }

  Widget passwordFieldConfirmation() {
    return  TextFormField(
      controller:_confirmPass,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Confirm Password" ,

      ),
      validator: (val){
        if(val.isEmpty)
          return 'Empty';
        if(val != _pass.text)
          return 'Not Match';
        return null;
      },
      onSaved: (String value){
        confirmPassword=value;
      },
    );
  }

  Widget submitButton()  {
    if(Global.visible_progress ){
      return CircularProgressIndicator();
    }
    else
      return Container(
        height: 40,
        width: 120,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),

          ),
          child: Text("Sign Up",style:TextStyle(
              color: Colors.white,

              fontWeight: FontWeight.w700,
              fontSize: 15
          ),),
          onPressed: () async {

            if(formKey.currentState.validate()){
              formKey.currentState.save();


              setState(() {
                Global.visible_progress=true;
              });
              if (position == null) {
                setState(() {
                  Global.visible_progress=false;
                });
                _getCurrentLocation();
              }
              else {
                final coordinates= new Coordinates( position.latitude,position.longitude);
                convertCoordinatesToAddress(coordinates).then((value){
                  address=value;
                  String country = address[2].countryName;
                  String governorate = address[2].adminArea;
                  String city = address[2].subAdminArea;
                  // country Example Egypt,USA    governorate=Giza,LA    city=dokki,bolaq  etc....//

                  String totalAddress=country+" "+governorate+" "+city;

                  User user=new User(0,phone,userName,position.latitude,position.longitude,totalAddress,_pass.text);
                  signUp("https://www.goomlah.com/public/api/users",user).then((value) async {
                    setState(() {
                      Global.visible_progress=false;
                    });
                    print (value);
                    if(value != null && value['message'] == "Data Inserted.")
                    {
                        user.id=value['user']['id'];
                        Global.loginUser=user;

                        // set user data here to save when log in again
                         Global.prefs.setInt('id',value['user']['id']);
                         Global.prefs.setString('phone',user.phone);
                         Global.prefs.setString('name',user.name);
                         Global.prefs.setDouble('latitude',user.latitude);
                         Global.prefs.setDouble('longitude',user.longitude);
                         Global.prefs.setString('address',user.address);
                         Global.prefs.setString('password',user.password);



                        Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context)=>HomePage()));

                    }
                    else{
                        Global.toastMessage(value['message']['phone'][0]);
                      setState(() {
                        Global.visible_progress=false;
                      });
                    }}
                  );
                });
              }


            }

          },
        ),
      );
  }

  Widget getLocation (){
    return Ink(
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: CircleBorder(),
      ),
      child: IconButton(
        icon: Icon(Icons.location_on),
        onPressed: () {
          _getCurrentLocation();
        },
      ),
    );
  }


  Widget sendToLogin(){
    return   Container(
        child: Row(
          children: <Widget>[
            Text('Have Account'),
            FlatButton(

              child: Text(
                "login user",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {

                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>Login()
                ));
              },
            ),

          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ));
  }

  Future<List<Address>> convertCoordinatesToAddress(Coordinates coordinates) async{
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return addresses;
  }

}