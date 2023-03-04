import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_diary_app/user_info/logged_user_info.dart';
import 'package:couple_diary_app/utils/snackBar.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class DDay extends StatefulWidget {
  String coupleId;
  DateTime? startDate;
  double width;
  double height;

  DDay({Key? key,
    required this.coupleId, required this.width,
    required this.height, required this.startDate
  }) : super(key: key);

  @override
  State<DDay> createState() => _DDayState();
}

class _DDayState extends State<DDay> {
  var logger = Logger(printer:PrettyPrinter());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(11),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(123, 191, 239, 0),
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(255, 255, 255, 0.1),
              blurRadius: 1,
              spreadRadius: 1.5,
            ),
          ],
        ),
        child: widget.startDate==null?NoCoupleDday(coupleId: widget.coupleId,) :CoupleDday(startDate: widget.startDate,),
      ),
    );
  }
}

//D-day를 입력받는 위젯
class NoCoupleDday extends StatefulWidget {
  String coupleId;
  NoCoupleDday({Key? key, required this.coupleId}) : super(key: key);

  @override
  State<NoCoupleDday> createState() => _NoCoupleDdayState();
}
class _NoCoupleDdayState extends State<NoCoupleDday> {
  final _formKey = GlobalKey<FormState>();
  void _tryValidation(){
    bool isValid = _formKey.currentState!.validate();
    if(isValid){
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime? selectedDate;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Form(
          key: _formKey,
          child: SizedBox(
            width: 200,
            child: DateTimeFormField(
              dateTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
              ),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.event_note, color: Colors.white,),
                labelStyle: TextStyle(color: Colors.white),
                labelText: '사랑을 시작한 날짜는?'
              ),
              mode: DateTimeFieldPickerMode.date,
              validator: (value){
                if(value==null){
                  return '날짜를 입력하세요.';
                }
                selectedDate = value;
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onSaved: (value){
                selectedDate = value;
              },
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width*0.15,
          child: CircleAvatar(
            backgroundColor: Color.fromRGBO(255, 255, 255, 0.3),
            child: IconButton(
                color: Colors.white,
                onPressed: (){
                  var logger = Logger(printer: PrettyPrinter());
                  _tryValidation();
                  if(selectedDate==null){
                    showSnackBar(context, '날짜를 선택하세요.');
                    return;
                  }
                  FirebaseFirestore.instance.collection('couple').doc(widget.coupleId)
                      .set({'startDate':selectedDate,},SetOptions(merge: true))
                      .then((value){
                        Provider.of<LoggedUserInfo>(context, listen: false).getUserInfo();
                  });
                },
                icon: Icon(Icons.check),
            ),
          ),
        ),
      ],
    );
  }
}

//Dday값이 있을 경우 출력하는 위젯
class CoupleDday extends StatefulWidget {
  CoupleDday({Key? key, required this.startDate}) : super(key: key);
  DateTime? startDate;

  @override
  State<CoupleDday> createState() => _CoupleDdayState();
}
class _CoupleDdayState extends State<CoupleDday> {
  DateTime nowDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(width: MediaQuery.of(context).size.width*0.15,),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('D+${nowDate.difference(widget.startDate!).inDays}',
                style: TextStyle(color:Colors.white, fontSize: 25),
              ),
              Text('처음 만난 날 : ${DateFormat('yyyy-MM-dd').format(widget.startDate!)}',
                style: TextStyle(fontSize: 15, color: Colors.white),)
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width*0.15,
          child: IconButton(
              color: Colors.white,
              onPressed: (){},
              icon: Icon(Icons.edit)
          ),
        ),
      ],
    );
  }
}
