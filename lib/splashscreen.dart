import 'package:carpool/loginpage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(primarySwatch: Colors.red),
      debugShowCheckedModeBanner: false,
      routes: {
        '/loginPage': (_) => LoginPage(),
      },
      home: Scaffold(
        backgroundColor: Colors.blue[600],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/kRide.png',
                width: 230,
                height: 230,
              ),
              SizedBox(
                height: 20,
              ),
              new ProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
class ProgressIndicator extends StatefulWidget {
  @override
  _ProgressIndicatorState createState() => new _ProgressIndicatorState();
}
class _ProgressIndicatorState extends State<ProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          //updating states
          if (animation.value > 0.99) {
            Navigator.of(context).pushNamed('/loginPage');
          }
        });
      });
    controller.repeat();
  }
  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
      width: 200,
      color: Colors.redAccent,
      child: LinearProgressIndicator(
        value: animation.value,
        backgroundColor: Colors.black,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
      ),
    ));
  }}