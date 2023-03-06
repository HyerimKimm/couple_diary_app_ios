import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_diary_app/user_info/logged_user_info.dart';
import 'package:couple_diary_app/utils/snackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchCouplePage extends StatefulWidget {
  const SearchCouplePage({Key? key}) : super(key: key);

  @override
  State<SearchCouplePage> createState() => _SearchCouplePageState();
}

class _SearchCouplePageState extends State<SearchCouplePage> {
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference searchedUser = FirebaseFirestore.instance.collection('user');
  final _formKey = GlobalKey<FormState>();

  String searchInputData = '';
  String searchedCoupleUserUid = '';

  //검색창 입력값 유효성 검사
  void _tryValidation(){
    bool isValid = _formKey.currentState!.validate();
    if(isValid){
      _formKey.currentState!.save();
    }
  }

  void _addCouple(senderUid,receiverUid) async{
    FocusScope.of(context).unfocus();
    await FirebaseFirestore.instance.collection('couple').add({
      'senderUid':senderUid,
      'receiverUid':receiverUid,
      'state':'wait',
      'time':Timestamp.now(),
      'startDate':null,
      'chatUid':null,
    });
    final coupleInfo = await FirebaseFirestore.instance.collection('couple')
        .where('receiverUid',isEqualTo: receiverUid)
        .where('senderUid',isEqualTo: senderUid).get();

    if(coupleInfo!=null){
      showSnackBar(context, '등록되었습니다!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(title: const Text('내 커플 찾기'),),
        ),
        body: Column(
          children: [
            //검색창
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width*0.7,
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          validator: (value){
                            if(value!.isEmpty){
                              return '검색할 이메일을 입력해 주세요!';
                            }
                            return null;
                          },
                          onSaved: (value){
                            searchInputData = value!;
                          },
                          decoration: const InputDecoration(
                            hintText: '상대방의 이메일로 검색하세요'
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: (){
                        _tryValidation();
                        setState(() {

                        });
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 23,
                      ),
                  ),
                ],
              ),
            ),
            //결과 리스트
            StreamBuilder(
              stream: searchedUser.where("email",isEqualTo: searchInputData).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(snapshot.hasData){
                  return Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width*0.8,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index){
                            final DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width:65,
                                      child: CircleAvatar(
                                        radius: 40,
                                        backgroundColor: Color.fromRGBO(123, 191, 239, 1),
                                        backgroundImage: NetworkImage(documentSnapshot['profileUrl']),
                                      ),
                                    ),
                                    SizedBox(
                                      child: Text(documentSnapshot['name'],textAlign: TextAlign.start,)
                                    ),
                                    SizedBox(
                                      child: IconButton(
                                          onPressed: (){
                                            String senderUid='';
                                            String receiverUid='';
//streambuilder : email로 검색한 유저의 값
                                            senderUid = user!.uid;
                                            receiverUid = documentSnapshot.id.toString();

                                            if(senderUid!='' && receiverUid!='') {
                                              _addCouple(senderUid, receiverUid);
                                              Provider.of<LoggedUserInfo>(context,listen: false).getUserInfo();
                                            }
                                          },
                                        icon: Icon(Icons.add),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                          }
                        ),
                      ),
                    ),
                  );
                }
                return Expanded( //결과가 없으면
                  child: Container(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
