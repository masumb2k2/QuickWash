import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practice/chat_screen.dart';

import '../carwasher//model/carwasher.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _chatListDatabase = FirebaseDatabase.instance.ref().child('ChatList');
  final DatabaseReference _carwasherDatabase = FirebaseDatabase.instance.ref().child('Carwashers');
  List<Carwasher> _chatList = [];
  bool _isLoading =  true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchChatList();
  }


  Future<void> _fetchChatList() async {
    String? userId = _auth
        .currentUser?.uid;
    if(userId != null){
      try{
        final DatabaseEvent event = await _chatListDatabase.once();
        DataSnapshot snapshot =event.snapshot;
        List<Carwasher> tempChatList = [];

        if(snapshot.value != null){
          Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
          for( var carwasherId in values.keys){
            Map<dynamic, dynamic> userChats = values[carwasherId];
            if(userChats.containsKey(userId)){
              final DatabaseEvent carwasherEvent = await _carwasherDatabase.child(carwasherId).once();
              DataSnapshot carwasherSnapshot = carwasherEvent.snapshot;
              if(carwasherSnapshot.value != null){
                Carwasher carwasher = Carwasher.fromMap(carwasherSnapshot.value as Map<dynamic, dynamic>, carwasherId);
                tempChatList.add(carwasher);
              }
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
            Carwasher carwasher = _chatList[index];
            return GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChatScreen(
                  carwasherId: carwasher.uid,
                  carwasherName: '${carwasher.firstName} ${carwasher.lastName}',
                  carownerId: _auth.currentUser!.uid,
                )));
              },
              child: Container(
                height: 48,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Color(0xffF0EFFF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Color(0xffC8C4FF),
                  )
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 10.0),
                      child: Text('${carwasher.firstName} ${carwasher.lastName}',
                      style: GoogleFonts.poppins(
                        fontSize: 17, fontWeight: FontWeight.w500
                      ),),
                    ),
                  ],
                )
              ),
            );
          }),
    );
  }
}
