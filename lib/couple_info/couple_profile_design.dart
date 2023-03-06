import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CoupleProfileDesign extends StatefulWidget {
  final String userId;
  final String coupleUserId;
  CoupleProfileDesign({Key? key, required this.userId, required this.coupleUserId}) : super(key: key);

  @override
  State<CoupleProfileDesign> createState() => _CoupleProfileDesignState();
}

class _CoupleProfileDesignState extends State<CoupleProfileDesign> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FutureBuilder(
          future: FirebaseFirestore.instance.collection('user').doc(widget.userId).get(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.connectionState==ConnectionState.waiting) return Container(height: 130,);
            final profileUrl = snapshot.data!['profileUrl'];
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Color.fromRGBO(123, 191, 239, 0),
                  backgroundImage: NetworkImage(profileUrl),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(snapshot.data!['name'], style: TextStyle(color: Colors.white),),
                )
              ],
            );
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('❤',style: TextStyle(fontSize: 30),),
        ),
        FutureBuilder(
          future: FirebaseFirestore.instance.collection('user').doc(widget.coupleUserId).get(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.connectionState==ConnectionState.waiting) return Container(height: 130,);
            final profileUrl = snapshot.data!['profileUrl'];
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color.fromRGBO(123, 191, 239, 0),
                  backgroundImage: NetworkImage(profileUrl),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(snapshot.data!['name'], style: TextStyle(color: Colors.white),),
                )
              ],
            );
          },
        ),
      ],
    );
  }
}
