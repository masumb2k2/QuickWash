import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../chat_screen.dart';
import 'model/carowner.dart';


class CarwasherChatlistPage extends StatefulWidget {
  const CarwasherChatlistPage({super.key});

  @override
  State<CarwasherChatlistPage> createState() => _CarwasherChatlistPageState();
}

class _CarwasherChatlistPageState extends State<CarwasherChatlistPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _chatListDatabase = FirebaseDatabase.instance.ref().child('ChatList');
  final DatabaseReference _carownersDatabase = FirebaseDatabase.instance.ref().child('Carowners');
  List<Carowner> _chatList = [];
  bool _isLoading =  true;
  late String carwasherId;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    carwasherId = _auth.currentUser?.uid ?? '';
    _fetchChatList();
  }


  Future<void> _fetchChatList() async {
    if(carwasherId.isNotEmpty){
      try{
        final DatabaseEvent event = await _chatListDatabase.child(carwasherId).once();
        DataSnapshot snapshot = event.snapshot;
        List<Carowner> tempChatList = [];

        if(snapshot.value != null){
          Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;

          for( var userId in values.keys){
            final DatabaseEvent carownerEvent = await _carownersDatabase.child(userId).once();
            DataSnapshot carownerSnapshot = carownerEvent.snapshot;
            if(carownerSnapshot.value != null){
              Map<dynamic, dynamic> carownerMap = carownerSnapshot.value as Map<dynamic, dynamic>;
              tempChatList.add(Carowner.fromMap(Map<String, dynamic>.from(carownerMap)));
            }
          }
        }
        setState(() {
          _chatList = tempChatList;
          _isLoading = false;
        });

      }catch (error) {
        // error message
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with'),),
      body: _isLoading ? Center(child: CircularProgressIndicator())
          : _chatList.isEmpty
          ? Center(child: Text('No chats available'))
          : ListView.builder(
          itemCount: _chatList.length,
          itemBuilder: (context, index){
            final carowner = _chatList[index];
            return Card(
              elevation: 2.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                title: Text('Chat with ${carowner.firstName} ${carowner.lastName}'),
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        carwasherId:  carwasherId,
                        carownerId: carowner.uid,
                        carownerName: '${carowner.firstName} ${carowner.lastName}',
                      )
                    )
                  );
                },
              ),
            );
          }),
    );
  }
}
