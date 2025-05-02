import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../chat_screen.dart';
import 'model/carwasher.dart';


class CarwasherDetailPage extends StatefulWidget {
  final Carwasher carwasher;
  const CarwasherDetailPage({super.key, required this.carwasher});

  @override
  State<CarwasherDetailPage> createState() => _CarwasherDetailPageState();
}

class _CarwasherDetailPageState extends State<CarwasherDetailPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _requestDatabase = FirebaseDatabase.instance
      .ref('Requests'); //  it will store appointments requests

  TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        title: Text('Carwasher Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section (Same as before)
              Row(
                children: [
                  Container(
                    width: 115,
                    height: 115,
                    decoration: BoxDecoration(
                      color: Color(0xfff0f5ff),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: widget.carwasher.profileImageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset('assets/images/profile.jpg'),
                          )
                        : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset('assets/images/profile.jpg')),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.carwasher.firstName} ${widget.carwasher.lastName}',
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        widget.carwasher.category,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'From: ${widget.carwasher.city}',
                        // Example location; replace with actual data if available
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Color(0xff005FEE),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Image.asset(
                              'assets/images/phone_call.png',
                              width: 30,
                              height: 30,
                              color: Color(0xff006AFA),
                            ),
                            onPressed: () {
                              // Add phone call functionality
                              _makePhoneCall(widget.carwasher.phoneNumber);
                            },
                          ),
                          IconButton(
                            icon: Image.asset(
                              'assets/images/chat_icon.png',
                              width: 30,
                              height: 30,
                              color: Color(0xff006AFA),
                            ),
                            onPressed: () {
                              // Add chat functionality
                              String currentUserId = _auth.currentUser!.uid;
                              String docName =
                                  '${widget.carwasher.firstName.toString()} ${widget.carwasher.lastName.toString()}';

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    carwasherId: widget.carwasher.uid,
                                    carwasherName: docName,
                                    carownerId: currentUserId,
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xfff0f5ff),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // Add map location functionality
                    _openMap();
                  },
                  child: Text(
                    'VIEW LOCATION ON MAP',
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        letterSpacing: 0.5,
                        color: Color(0xff005FEE),
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Text(
                'Select Date & Time',
                style: GoogleFonts.poppins(
                    fontSize: 17, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Color(0xfff0f5ff),
                  border: Border.all(
                    color: Color(0xfff0f5ff),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff006AFA),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => _selectDate(context),
                            child: Text(
                              _selectedDate == null
                                  ? 'Select Date'
                                  : DateFormat('MM/dd/yyyy')
                                      .format(_selectedDate!),
                              style: GoogleFonts.poppins(
                                  fontSize: 15, letterSpacing: 0.6),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff006AFA),
                              foregroundColor: Color(0xfff0f5ff),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => _selectTime(context),
                            child: Text(
                              _selectedTime == null
                                  ? 'Select Time'
                                  : _selectedTime!.format(context),
                              style: GoogleFonts.poppins(
                                  fontSize: 15, letterSpacing: 0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _descriptionController,
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.black),
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Color(0xffF0EFFF),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff006AFA),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                  onPressed: () {
                    // Add appointment booking functionality
                    _bookAppointment();
                  },
                  child: Text(
                    'BOOK SERVICE',
                    style: GoogleFonts.poppins(fontSize: 18, letterSpacing: 2,fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //select Date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  //select time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // open map
  void _openMap() async {
    final String googleMapUrl =
        'https://www.google.com/maps/search/?api=1&query=${widget.carwasher.latitude},${widget.carwasher.longitude}';
    if (await canLaunch(googleMapUrl)) {
      await launch(googleMapUrl);
    } else {
      throw 'Could not open the map';
    }
  }

  // phone call
  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunch(phoneUri.toString())) {
      await launch(phoneUri.toString());
    } else {
      throw 'Could not make a call on $phoneNumber this number';
    }
  }

  // appointment

  void _bookAppointment() {
    if (_selectedDate != null &&
        _selectedTime != null &&
        _descriptionController.text.isNotEmpty) {
      // date, time, des, requestId, receiverId, senderId, status
      String date = DateFormat('MM/dd/yyyy').format(_selectedDate!);
      String time = _selectedTime!.format(context);
      String description = _descriptionController.text;
      String requestId = _requestDatabase.push().key!;
      String currentUserId = _auth.currentUser!.uid;
      String receiverId = widget.carwasher.uid;
      String status = 'pending';

      //save appointment
      _requestDatabase.child(requestId).set({
        'date': date,
        'time': time,
        'description': description,
        'id': requestId,
        'receiver': receiverId,
        'sender': currentUserId,
        'status': status,
      }).then((_) {
        setState(() {
          _selectedDate = null;
          _selectedTime = null;
          _descriptionController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Appointment booked successfully')));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Failed to book your appointment, Try Again later!!')));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Select a date and time also add a description for appointment')));
    }
  }
}
