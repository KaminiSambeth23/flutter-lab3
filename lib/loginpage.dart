import 'package:flutter/material.dart';
import 'package:carpool/registrationpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import 'package:carpool/homepage.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

String urlLogin="http://theksultra.com/carpool/php/login_user.php";
 
 void main() =>runApp(MyApp());
   
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFFB414B),
      ),
      home: new LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
  
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emcontroller = TextEditingController();
  String _email = "";
  final TextEditingController _passcontroller = TextEditingController();
  String _password = "";
  bool _isChecked = false;

  @override
  void initState() {
    loadpref();
    print('Init: $_email');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
          onWillPop: _onBackPressAppBar,
                    child: Scaffold(
                  resizeToAvoidBottomPadding: false,
                  body: Container(
                    padding:
                        EdgeInsets.only(top: 55.0, right: 20.0, left: 20.0, bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/kRide.png',
                          scale: 1.1,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32.0,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        TextField(
                          controller: _emcontroller,
                          keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                labelText: 'Email', icon: Icon(Icons.email))),
                        TextField(
                          controller: _passcontroller,
                          decoration: InputDecoration(
                              labelText: 'Password', icon: Icon(Icons.lock)),
                              obscureText: true,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                               GestureDetector(
                              onTap: _onForgot,
                              child:
                              Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor, fontSize: 18),
                              ),
                               ),],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Checkbox(
                                value: _isChecked,
                                onChanged: (bool value) {
                                  _onChange(value);
                                },
                              ),
                              Text('Remember Me', style: TextStyle(fontSize: 18)),
                            ],
                          ),
                        ),
                        
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                        MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            minWidth: 200,
                            height: 50,
                            child: Text('Login'),
                            color: Theme.of(context).primaryColor,
                            elevation: 10,
                            onPressed: _onLogin,
                          ),
                           SizedBox(
                          height: 40,
                        ),
                                Text("Don't have an account?",
                                    style: TextStyle(fontSize: 17)),
                                SizedBox(
                                  width: 10.0,
                                ),
                                GestureDetector(
                              onTap: _onRegister,
                              child:
                                Text("SIGN UP",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 17,
                                    )),
                                ),],
                            ),
                          ),
                        )
                      ],
                    ),
                  )));
            }
          
           
          
            void _onLogin(){
             _email = _emcontroller.text;
            _password = _passcontroller.text;
    if (_isEmailValid(_email) && (_password.length > 4)) {
      ProgressDialog pr =new ProgressDialog(context,
      type:ProgressDialogType.Normal, isDismissible:false);
      pr.style(message: "Login in");
      pr.show();
      http.post(urlLogin, body: {
        "email": _email,
        "password": _password,
      }).then((res) {
        print(res.statusCode);
        Toast.show(res.body, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (res.body == "success") {
          pr.dismiss();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage(email: _email)));
        }else{
          pr.dismiss();
        }
        
      }).catchError((err) {
        pr.dismiss();
        print(err);
      });
    } else {}
            }
          
            void _onRegister(){
              print('onRegister');
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => RegistrationPage()));
            }
          
            void _onForgot(){
              print('Forgot');
            }
          
            void _onChange(bool value) {
              setState(() {
                _isChecked = value;
                savepref(value);
              });
            }
          
            void loadpref() async {
              print('Inside loadpref()');
              SharedPreferences prefs = await SharedPreferences.getInstance();
              _email = (prefs.getString('email'));
              _password = (prefs.getString('pass'));
              print(_email);
              print(_password);
              if (_email.length >1) {
                _emcontroller.text = _email;
                _passcontroller.text = _password;
                setState(() {
                  _isChecked = true;
                });
              } else {
                print('No pref');
                setState(() {
                  _isChecked = false;
                });
              }
            }
          
            void savepref(bool value) async {
               print('Inside savepref');
              _email = _emcontroller.text;
              _password = _passcontroller.text;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (value) {
                //true save pref
                if (_isEmailValid(_email) || _password.length < 6) {
                        await prefs.setString('email', _email);
                        await prefs.setString('pass', _password);
                        print('Save pref $_email');
                        print('Save pref $_password');
                        Toast.show("Preferences saved succesfully", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      } else {
                        print('No email');
                        setState(() {
                          _isChecked = false;
                        });
                        Toast.show("Invalid Preferences", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      }
                    } else {
                      await prefs.setString('email', '');
                      await prefs.setString('pass', '');
                      setState(() {
                        _emcontroller.text = '';
                        _passcontroller.text = '';
                        _isChecked = false;
                      });
                      print('Remove pref');
                      Toast.show("Preferences removed", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    }
                  }
          
                  bool _isEmailValid(String email) {
                   return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
                  }
          
            Future<bool> _onBackPressAppBar() async {
            SystemNavigator.pop();
            print('Backpress');
            return Future.value(false);
              }
}
