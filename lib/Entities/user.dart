class User {

  int id;
  String phone;
  String name;
  String password;
  num latitude;
  num longitude;
  int active;
  String code;
  String created_at;
  String updated_at;
  String address;

  User.empty();
  User(this.id,this.phone,this.name,this.latitude,this.longitude,this.address,this.password);

}