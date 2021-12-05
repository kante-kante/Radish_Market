import 'package:radishmarket/login_page.dart';
import 'package:radishmarket/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({Key? key}) : super(key: key);

  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(); //입력되는 값을 제어
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();

  String _imageFile = 'assets/images/main.png';

  Widget _nameWidget(){
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: '이름',
      ),
      validator: (String? value){
        if (value!.isEmpty) {// == null or isEmpty
          return '이름을 입력해주세요.';
        }
        return null;
      },
    );
  }

  Widget _emailWidget(){
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: '이메일',
      ),
      validator: (String? value){
        if (value!.isEmpty) {// == null or isEmpty
          return '이메일을 입력해주세요.';
        }
        return null;
      },
    );
  }

  Widget _passwordWidget(){
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: '비밀번호',
      ),
      validator: (String? value){
        if (value!.isEmpty) {// == null or isEmpty
          return '비밀번호를 입력해주세요.';
        }
        return null;
      },
    );
  }

  Widget _password2Widget(){
    return TextFormField(
      controller: _password2Controller,
      obscureText: true,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: '비밀번호 확인',
      ),
      validator: (String? value){
        if (value!.isEmpty) {// == null or isEmpty
          return '비밀번호를 확인해주세요.';
        } else if (value != _passwordController.text) {
          return '비밀번호가 다릅니다.';
        }
        return null;
      },
    );
  }

  Widget _joinButtonWidget() {
    return Container(
      height: 70,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 8.0), // 8단위 배수가 보기 좋음
      child: ElevatedButton(
          onPressed: () => _join(),
          child: const Text("회원 가입")
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원 가입'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  Image(width: 400.0, height: 250.0, image: AssetImage(_imageFile)),
                  const SizedBox(height: 20.0),
                  _nameWidget(),
                  const SizedBox(height: 20.0),
                  _emailWidget(),
                  const SizedBox(height: 20.0),
                  _passwordWidget(),
                  const SizedBox(height: 20.0),
                  _password2Widget(),
                  const SizedBox(height: 20.0),
                  _joinButtonWidget(),
                ],
              )
            ),
          ),
        ),
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
    // 해당 클래스가 사라질때
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _password2Controller.dispose();
    super.dispose();
  }

  _join() async{
    if(_formKey.currentState!.validate()) {
      FocusScope.of(context).requestFocus(FocusNode());

      try {
        final User? user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text
        )).user;

        CollectionReference userCollection = FirebaseFirestore.instance.collection('user');
        userCollection.doc(user!.uid).set({
          'name': _nameController.text,
          'profileUrl': "",
        }).then((value) async {
          await FirebaseAuth.instance.signOut();
          Get.offAll(()=>const LoginPage());
        }).catchError((e) async {
          logger.e(e);

          await FirebaseAuth.instance.currentUser!.delete();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e),
              backgroundColor: Colors.deepOrange,
            ),
          );
        });
      } on FirebaseAuthException catch (e) {
        logger.e(e);
        String message = '';

        if (e.code == 'weak-password') {
          message = '비밀번호는 6자리 이상으로 설정해주세요.';
        } else if (e.code == 'email-already-in-use') {
          message = '이미 사용중인 이메일입니다.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.deepOrange,
          ),
        );
      }
    }
  }
}