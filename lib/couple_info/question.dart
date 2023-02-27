import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  double width;
  double height;
  Question({Key? key, required this.width, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/demian.jpeg'),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder(
            stream: null,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return Center(
                child: Text('test', style: TextStyle(color: Colors.white),),
              );
            },
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width*0.8,
            child: TextFormField(
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                  icon: Icon(Icons.edit, color: Colors.white,)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
