import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_project/color/color.dart';
import 'package:sqlite_project/register_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _splash();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: InColors.whiteColor,
      body: Center(
        child: Image(image: AssetImage('assets/images/sqlite.jpg'),),
      ),
    );
  }

  void _splash() async{
    await Future.delayed(const Duration(milliseconds: 3000));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const RegisterScreen()));
  }
}
