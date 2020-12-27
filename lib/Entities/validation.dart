

class Validation {

   String validateUserName(String value) {

     if(value.length<3)
     {
       return 'Please Enter your name';
     }
     return null;
   }

   bool validateInt(String value) {
    try
    {
        int temp= int.parse(value);
        return true;
    }
    catch(Exception)
    {
         return false;
    }
   }

   bool validateDouble(String value) {
     try
     {
       double temp= double.parse(value);
       return true;
     }
     catch(Exception)
     {
       return false;
     }
   }

   String validateMobileNumber (String value) {
    if(value.length<11)
    {
      return 'Please Enter valid mobile number';
    }
    return null;
  }

   String validatePassword(String value){
    if(value.length<6)
    {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

}