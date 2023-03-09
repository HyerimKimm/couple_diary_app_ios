import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_diary_app/user_info/Category.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AnswerList extends StatefulWidget {
  final String coupleId;

  AnswerList({Key? key, required this.coupleId}) : super(key: key);

  @override
  State<AnswerList> createState() => _AnswerListState();
}

class _AnswerListState extends State<AnswerList> {
  @override
  Widget build(BuildContext context) {
    String category = Provider.of<Category>(context).category;

    return Column(
      children: [

        Padding(
          padding: const EdgeInsets.only(top:8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 45,
                child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: category==''?Colors.white:Color.fromRGBO(255, 255, 255, 0),
                      shape: StadiumBorder(),
                      side: BorderSide(
                        color: category==''?Colors.blue:Color.fromRGBO(90, 90, 90, 0)
                      )
                    ),
                    onPressed: (){
                      Provider.of<Category>(context,listen: false).changeCategory('');
                    },
                    child: Text('전체',
                      style: category==''?TextStyle(color: Color.fromRGBO(90, 90, 90, 1))
                              :TextStyle(color: Colors.white),
                    )
                ),
              ),
              Container(
                height: 45,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: category=='가치관'?Colors.white:Color.fromRGBO(255, 255, 255, 0),
                    shape: StadiumBorder(),
                    side: BorderSide(
                          color: category=='가치관'?Colors.blue:Color.fromRGBO(90, 90, 90, 0)
                    )
                  ),
                    onPressed: (){
                      Provider.of<Category>(context,listen: false).changeCategory('가치관');
                    },
                    child: Text('가치관',
                        style: category=='가치관'?TextStyle(color: Color.fromRGBO(90, 90, 90, 1))
                                :TextStyle(color: Colors.white)
                    )
                ),
              ),
              Container(
                height: 45,
                child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: category=='추억'?Colors.white:Color.fromRGBO(255, 255, 255, 0),
                      shape: StadiumBorder(),
                      side: BorderSide(
                            color: category=='추억'?Colors.blue:Color.fromRGBO(90, 90, 90, 0)
                      )
                    ),
                    onPressed: (){
                      Provider.of<Category>(context,listen: false).changeCategory('추억');
                    },
                    child: Text('추억',
                        style: category=='추억'?TextStyle(color: Color.fromRGBO(90, 90, 90, 1))
                            :TextStyle(color: Colors.white))
                ),
              ),
              Container(
                height: 45,
                child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: category=='성생활'?Colors.white:Color.fromRGBO(255, 255, 255, 0),
                      shape: StadiumBorder(),
                      side: BorderSide(
                            color: category=='성생활'?Colors.blue:Color.fromRGBO(90, 90, 90, 0)
                      )
                    ),
                    onPressed: (){
                      Provider.of<Category>(context,listen: false).changeCategory('성생활');
                    },
                    child: Text('성생활',
                        style: category=='성생활'?TextStyle(color: Color.fromRGBO(90, 90, 90, 1))
                            :TextStyle(color: Colors.white))
                ),
              ),
              Container(
                height: 50,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: category=='애인의 모든것'?Colors.white:Color.fromRGBO(255, 255, 255, 0),
                    shape: StadiumBorder(),
                    side: BorderSide(
                          color: category=='애인의 모든것'?Colors.blue:Color.fromRGBO(90, 90, 90, 0)
                    )
                  ),
                    onPressed: (){
                      Provider.of<Category>(context,listen: false).changeCategory('애인의 모든것');
                    },
                    child: Text('애인의\n모든것',
                        style: category=='애인의 모든것'?TextStyle(color: Color.fromRGBO(90, 90, 90, 1),fontSize: 12)
                            :TextStyle(color: Colors.white, fontSize: 12))
                ),
              ),
            ],
          ),
        ),
        StreamBuilder(
          stream:
            category!=''?
              FirebaseFirestore.instance.collection('couple').doc(widget.coupleId)
                .collection('QnAanswer').where('category',isEqualTo: category).snapshots() 
              :FirebaseFirestore.instance.collection('couple').doc(widget.coupleId)
                .collection('QnAanswer').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.connectionState==ConnectionState.waiting){
              return const CircularProgressIndicator(color: Colors.white,);
            }

            final answerDocs = snapshot!.data.docs;
            if(answerDocs.length==0){
              return const Padding(
                padding:  EdgeInsets.all(16.0),
                child: Text('등록된 문답이 없습니다!',
                  style: TextStyle(
                    color: Color.fromRGBO(80, 80, 80, 1),
                    fontSize: 20,
                    fontFamily: 'GangwonEduBold',
                  ),
                ),
              );
            }
            return Expanded(
              child: ListView.builder(
                itemCount: answerDocs.length,
                itemBuilder: (BuildContext context, int index) {
                  return AnswerListCard(
                    question: answerDocs[index]['question'],
                    userName: answerDocs[index]['userName'],
                    answer: answerDocs[index]['answer'],
                    addDateTime: answerDocs[index]['add_datetime'].toDate(),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class AnswerListCard extends StatelessWidget {
  final String question;
  final String answer;
  final String userName;
  final DateTime? addDateTime;
  const AnswerListCard({Key? key, required this.question, required this.userName, required this.answer, required this.addDateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        color: Color.fromRGBO(255, 255, 255, 0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0)
        ),
        elevation: 3.0,
        child: SizedBox(
          width: MediaQuery.of(context).size.width*0.9,
          height: 180,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top:8.0,left: 8.0, right: 8.0),
                child: Text(
                  'Q. ${question}',
                  style: TextStyle(
                    color: Color.fromRGBO(80, 80, 80, 1),
                    fontFamily: 'GangwonEduBold',
                    fontSize: 18
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 80,
                      child: Text(userName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Color.fromRGBO(123, 191, 239, 1),
                            fontFamily: 'NotoSansKR-Regular',
                            fontSize: 13
                        ),
                      ),
                    ),
                  ),
                  Icon(Icons.calendar_month, color: Colors.grey,),
                  Text(DateFormat('yyyy-MM-dd HH시 mm분').format(addDateTime!),
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontFamily: 'NotoSansKR-Regular'
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(answer,
                    style: const TextStyle(
                      color: Color.fromRGBO(80, 80, 80, 1),
                      fontFamily: 'GangwonEduBold',
                      fontSize: 15
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
