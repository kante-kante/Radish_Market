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
  final db = FirebaseFirestore.instance;

  String _name = '이름';
  String _email = '이메일';
  String _profileImageURL = "";

  final List<String> entries = <String>['Red','Green','Blue','Yellow','Pink','Magenta','Orange','Dark'];



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
            /*Container(
              height: 530,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverFixedExtentList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index){
                            return Container(
                              child: Text('Color is $index'),
                            );
                          }
                      ),
                      itemExtent: 50.0
                  )
                ],
              ),
            )*/
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
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
            /*Container(
              height: 530,
              child: ListView.separated(
                  //padding: const EdgeInsets.all(6),
                  itemCount: entries.length,
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                        padding: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: Icon(Icons.image, color: Colors.green,size: 20,),
                          title: Text('Color is ${entries[index]}'),
                          subtitle: Text('${entries[index]} Color'),
                        )
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => const Divider()
              ),
            ),*/

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