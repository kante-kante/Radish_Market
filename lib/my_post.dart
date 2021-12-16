import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:radishmarket/main.dart';
import 'package:radishmarket/post_page.dart';

class MyPostPage extends StatefulWidget {
  const MyPostPage({Key? key}) : super(key: key);


  @override
  State<MyPostPage> createState() => _MyPostPageState();
}

/// 상세페이지로 이동
class DetailPost extends StatelessWidget {
  final DocumentSnapshot doc;

  const DetailPost({Key? key, required this.doc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime datetime = DateTime.fromMicrosecondsSinceEpoch(doc['datetime']);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("상세 페이지"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doc['title'],
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              //padding: EdgeInsets.all(),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child:Image(
                  image: NetworkImage(doc['image']),
                  fit: BoxFit.contain,
                  height: 250,
                  width: 250,
                ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(10),
              child:Text(
                ' ${doc['content']}',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.black87
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child:Text(
                  '연락처: ${doc['number']}',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.black87
                  ),
                ),
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
                child:Text(
                  '가격: ${doc['price']}',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.black87
                  ),
                ),
            ),
            SizedBox(height: 8),
            Text(
                '작성일시: ${DateFormat('yyyy-MM-dd HH:mm').format(datetime)}',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.black54,
                ),
              ),
            SizedBox(height: 8),
            Text(
              '작성자: ${doc['author']}',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 10,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyPostPageState extends State<MyPostPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  String _name = '이름';
  String _email = '이메일';
  String _profileImageURL = "";



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
              child:StreamBuilder<QuerySnapshot>(
                stream: db.collection('post').orderBy('datetime',descending: true).snapshots(),
                builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshots){
                  if(!snapshots.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }else {
                    return ListView(
                      children: snapshots.data!.docs.map((DocumentSnapshot doc){
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(doc['image']),
                              radius: 30,
                            ),
                            title: Text(
                              doc['title'],
                              style: const TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                            subtitle: Text(
                              doc['content'],
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.black45
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) => DetailPost(doc:doc)));
                            },
                          ),

                        );
                      }).toList(),
                    );
                  }
                },
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