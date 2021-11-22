import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);


  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
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
        title: const Text("메인"),
        centerTitle: true,
      ),
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