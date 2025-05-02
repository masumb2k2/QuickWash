import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practice/auth/login_page.dart';
import 'package:practice/carowner/carowner_home_page.dart';


import 'carwasher/carwasher_home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    User? user = _auth.currentUser;

    if (user == null) {
      await Future.delayed(Duration(seconds: 2));
      _navigateToLogin();
    } else {
      DatabaseReference userRef = _database.child('Carwashers').child(user.uid);
      DataSnapshot snapshot = await userRef.get();

      if (snapshot.exists) {
        await Future.delayed(Duration(seconds: 2));
        _navigateToCarwasherHome();
      } else {
        userRef = _database.child('Carowners').child(user.uid);
        snapshot = await userRef.get();
        if (snapshot.exists) {
          await Future.delayed(Duration(seconds: 2));
          _navigateToCarownerHome();
        } else {
          await Future.delayed(Duration(seconds: 2));
          _navigateToLogin();
        }
      }
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  void _navigateToCarwasherHome() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CarwasherHomePage()));
  }

  void _navigateToCarownerHome() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CarownerHomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffffffff),
        body:  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/splash.jpg', width: MediaQuery.of(context).size.width,),
              SizedBox(height: 20,),
              Text('QuickWash', style: GoogleFonts.poppins(fontSize: 35, fontWeight: FontWeight.bold,color: Color(0xff005FEE)),),

            ],
          ),
        )
    );
  }

}
