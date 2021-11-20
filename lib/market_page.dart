import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({Key? key}) : super(key: key);


  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("로그인"),
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