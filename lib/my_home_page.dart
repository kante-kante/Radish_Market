
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:radishmarket/login_page.dart';
import 'package:radishmarket/market_page.dart';

import 'main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _TmpPageState createState() => _TmpPageState();
}

class _TmpPageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context){
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  void initState(){
    super.initState();

    _permission();
    _logout();
    _auth();

  }

  @override
  void dispose(){
    super.dispose();
  }

  _permission() async{
    Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
    ].request();
    //logger.i(statuses[Permission.storage]);
  }

  _auth(){
    // 사용자 인증정보 확인. 딜레이를 두어 확인
    Future.delayed(const Duration(milliseconds: 100),() {
      if(FirebaseAuth.instance.currentUser == null){
        Get.off(() => const LoginPage());
      } else {
        Get.off(() => const MarketPage());
      }
    });
  }

  _logout() async{
    await FirebaseAuth.instance.signOut();
  }

}