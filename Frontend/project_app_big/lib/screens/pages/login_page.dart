// ignore_for_file: missing_required_param, camel_case_types, unused_field, non_constant_identifier_names, missing_return, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project_app_big/constants/api.dart';
import 'package:project_app_big/models/users/user_login.dart';
import 'package:project_app_big/screens/pages/home_page.dart';
import 'package:project_app_big/services/network_servises.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart';

class Login_Page extends StatefulWidget {
  const Login_Page({Key? key}) : super(key: key);

  @override
  _Login_PageState createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  final _formKey = GlobalKey<FormState>();
  var isLogin = false;
  var user_login = User_Login();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return isLogin? Home_Page() : Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade800,
                  Colors.blue.shade600,
                ],
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 36),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "เข้าสู่ระบบ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 46.0,
                                fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "ยินดีต้อนรับ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40),
                              topLeft: Radius.circular(40))),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _Emailinput(),
                            SizedBox(height: 20.0,),
                            _Passwordinput(),
                            SizedBox(height: 20.0,),
                            _GoToRegister(),
                            SizedBox(
                              height: 50,
                            ),
                            _BuildButton()
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

 Widget _Emailinput() {
   return TextFormField(
     initialValue: user_login.email,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        user_login.email = value!;
      },
      validator: (value){
        if(!isEmail(value!)){
           return "กรุณาพิมพ์ให้อยู่ในรูปแบบอีเมล";
        }
        else{
          return null;
        }
      } ,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none),
        // เติมให้เต็ม
        filled: true,
        //และเติมสี
        fillColor: Color(0xFFe7edeb),
        hintText: "อีเมล",
        prefixIcon: Icon(
          Icons.email,
          color: Colors.grey[600],
        ),
      ),
    );
 }

 Widget _Passwordinput() {
   return TextFormField(
     initialValue: user_login.password,
      obscureText: true,
      keyboardType: TextInputType.number,
       onSaved: (value) {
        user_login.password = value!;
      },
      validator: (value){
        if(value!.length < 5){
           return "กรุณาใส่ข้อมูลให้ถูกต้อง";
        }
        else{
          return null;
        }
      } ,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none),
        // เติมให้เต็ม
        filled: true,
        //และเติมสี
        fillColor: Color(0xFFe7edeb),
        hintText: "รหัสผ่าน",
        prefixIcon: Icon(
          Icons.password_sharp,
          color: Colors.grey[600],
        ),
      ),
    );
 }

 Widget _BuildButton(){
   return Container(             width: double.infinity,
      // ignore: deprecated_member_use
      child: RaisedButton(
        onPressed: _OnSubmit,
        color: Colors.blue[800],
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            "เข้าสู่ระบบ",
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
        ),
      ),
    );
 }

  _OnSubmit(){
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(
        () {},
      );
      FocusScope.of(context).requestFocus(FocusNode());
      NetworkService()
          .login(user_login)
          .then(
            (value) => _goToWeb(value),
          )
          .onError(
            (error, stackTrace) => {
              print(
                (error as DioError).message,
              ),
            },
          );

    }
 }

  _goToWeb(List<String> value)  {
  
    if (value[0] == API.OK) {
      int uid = int.parse(value[1]);
      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        title: "ยินดีตอนรับ",
        confirmBtnText: "ตกลง"
      ).then((value) async {
        var prefs = await SharedPreferences.getInstance();
        //จดจำไว้แล้ว
        prefs.setBool(API.ISLOGIN, true);
        prefs.setInt(API.USER_ID, uid);
        // var s = prefs.get(API.USER_ID);
        // var s1 = prefs.get(API.ISLOGIN);
        Navigator.pop(context);
        //  prefs.remove(API.USER_ID).then((value) => print("Ok"));
        //  prefs.remove(API.ISLOGIN).then((value) => print("Ok"));
      });
    } else {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        title:value[0] ,
        confirmBtnText: "ตกลง"
      );
    }
  }

 Widget _GoToRegister() {
   return Row(
     mainAxisAlignment: MainAxisAlignment.end,
     children: [
     
     GestureDetector(
       onTap: (){
         Navigator.pushNamed(context, '/register_page');
       },
       child: Text(
            "สมัครสมาชิก",
            style: TextStyle(
              color: Colors.blue[800],
              decoration: TextDecoration.underline
            ),
          ),
     ),
      ],
    );
 }

  _chkLogin() async {
    var prefs = await SharedPreferences.getInstance();
    var chk = prefs.get(API.ISLOGIN);
    setState(() {
      isLogin = chk as bool;
    },
    );
  }
}
