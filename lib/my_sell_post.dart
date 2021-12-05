import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main.dart';

class MySellPostPage extends StatefulWidget {
  const MySellPostPage({Key? key}) : super(key: key);


  @override
  State<MySellPostPage> createState() => _MySellPostPageState();
}

class _MySellPostPageState extends State<MySellPostPage> {
  final User? user = FirebaseAuth.instance.currentUser;

  String _name = '이름';
  String _email = '이메일';
  String _profileImageURL = "";


  final List<String> entries = <String>['1','2','3','4','5','6'];

  @override
  Widget build(BuildContext context) {
    /*return GetMaterialApp(
      title: '무우 마켓',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('무우마켓'),
          ),
          body: TabBarView(
            children: [
              Text('판매글'),
              Text('홈'),
              Text('마이 페이지'),
            ],
          ),
          bottomNavigationBar: TabBar(tabs: [
            Tab(
              icon: Icon(Icons.text_snippet),
              text: 'home',
            ),
            Tab(
              icon: Icon(Icons.home),
              text: 'chat',
            ),
            Tab(
              icon: Icon(Icons.people),
              text: 'my',
            )
          ]),
        ),
      )
    );*/
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("나의 판매글"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage:NetworkImage(_profileImageURL),
                  radius: 30,
                ),
                SizedBox(width: 30.0),
                Column(
                  children: [
                    Text(_name),
                    SizedBox(height:20),
                    Text(_email),
                  ],
                ),
              ],
            ),
            Divider(color: Colors.black, thickness: 0.5),
            Container( // hasSize 오류로 인한 Container height 설정
              height: 530,
              child: ListView.separated(
                //padding: const EdgeInsets.all(6),
                  itemCount: entries.length,
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                        padding: const EdgeInsets.all(16),
                        child: Text('테스트 ${entries[index]}')
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => const Divider()
              ),
            ),
          ],

        ),
      ),
    );
  }

  @override
  void initState() {
    //해당 클래스가 호출되었을떄
    super.initState();

    _getUser();
    _getProfile();

  }

  @override
  void dispose() {
    super.dispose();
  }

  _getUser() {
    FirebaseFirestore.instance.collection('user')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if(documentSnapshot.exists){
        try{
          dynamic name = documentSnapshot.get(FieldPath(const ['name']));
          String? email = user!.email;
          setState(() {
            _name = name;
            _email = email!;
          });
        } on StateError catch(e){
          logger.e(e);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('사용자명을 가져올 수 없습니다.'),
            backgroundColor: Colors.deepOrange,
          ));
        }
      }
    });
  }

  // 프로필 이미지 가져오기
  _getProfile() {
    FirebaseFirestore.instance
        .collection('user')
        .doc(user?.uid)
        .get().then((DocumentSnapshot documentSnapshot){
      if(documentSnapshot.exists){
        try{
          dynamic profileUrl = documentSnapshot.get(FieldPath(const ['profileUrl']));
          setState(() {
            _profileImageURL = profileUrl;
          });
        } on StateError catch(e){
          logger.e(e);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('사용자 프로필을 가져올 수 없습니다.'),
            backgroundColor: Colors.deepOrange,
          ));
        }
      }
    });
  }

}