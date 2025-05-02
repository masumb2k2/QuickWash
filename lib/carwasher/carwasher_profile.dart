import 'package:flutter/material.dart';

class CarwasherProfile extends StatefulWidget {
  const CarwasherProfile({super.key});

  @override
  State<CarwasherProfile> createState() => _CarwasherProfileState();
}

class _CarwasherProfileState extends State<CarwasherProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doc Profile'),
      ),
    );
  }
}
