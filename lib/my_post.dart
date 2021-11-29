import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radishmarket/main.dart';

class MyPostPage extends StatefulWidget {
  const MyPostPage({Key? key}) : super(key: key);


  @override
  State<MyPostPage> createState() => _MyPostPageState();
}

class _MyPostPageState extends State<MyPostPage> {
  final User? user = FirebaseAuth.instance.currentUser;

  String _name = '이름';
  String _email = '이메일';

  final List<String> entries = <String>['Red','Green','Blue','Yellow','Pink','Magenta'];



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
                ClipOval(
                  child: Image(
                    width: 80,
                    height: 80,
                    image: AssetImage('assets/images/main.png'),
                  ),
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
          onPressed: () {}
      ),
    );
  }

  @override
  void initState() {
    //해당 클래스가 호출되었을떄
    super.initState();

    _getUser();

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

}