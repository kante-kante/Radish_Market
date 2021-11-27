import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPostPage extends StatefulWidget {
  const MyPostPage({Key? key}) : super(key: key);


  @override
  State<MyPostPage> createState() => _MyPostPageState();
}

class _MyPostPageState extends State<MyPostPage> {
  final User? user = FirebaseAuth.instance.currentUser;

  String _name = '이름';
  String _email = '이메일';


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
              children: [
                ClipOval(
                  child: Image(
                    width: 100,
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
                Spacer(),
              ],
            ),
            Column(

            ),
          ],
        ),
      )
    );
  }

  @override
  void initState() {
    //해당 클래스가 호출되었을떄
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

}