import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radishmarket/main.dart';
import 'package:radishmarket/post_page.dart';

class MyPostPage extends StatefulWidget {
  const MyPostPage({Key? key}) : super(key: key);


  @override
  State<MyPostPage> createState() => _MyPostPageState();
}

class _MyPostPageState extends State<MyPostPage> {
  final User? user = FirebaseAuth.instance.currentUser;

  String _name = '이름';
  String _email = '이메일';
  String _profileImageURL = "";

  final List<String> entries = <String>['Red','Green','Blue','Yellow','Pink','Magenta'];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("판매 목록"),
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
            Container(
              height: 530,
              child: ListView.separated(
                  //padding: const EdgeInsets.all(6),
                  itemCount: entries.length,
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                        padding: const EdgeInsets.all(16),
                        child: Text('Color is ${entries[index]}')
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => const Divider()
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          label: const Text('글 쓰기'),
          icon:const Icon(Icons.add),
          backgroundColor: Colors.deepOrange,
          onPressed: () => Get.to(()=> const PostPage()),
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

  //파이어베이스 스토리지 프로필 정보 가져오기
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