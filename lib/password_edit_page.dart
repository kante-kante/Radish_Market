import 'package:radishmarket/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordEditPage extends StatefulWidget {
  const PasswordEditPage({Key? key}) : super(key: key);


  @override
  State<PasswordEditPage> createState() => _PasswordEditPageState();
}

class _PasswordEditPageState extends State<PasswordEditPage> {

  final User? user = FirebaseAuth.instance.currentUser;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('비밀번호 수정'),
      ),
      body:Padding(
        padding: const EdgeInsets.all(16.0),
        child:Column(
          children: [
            _passwordWidget(),
            const SizedBox(height: 20.0),
            _password2Widget(),
            const SizedBox(height: 20.0),
            _passwordEditButtonWidget(),
          ],
        ),
      ),
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

  Widget _passwordEditButtonWidget() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              FocusScope.of(context).requestFocus(FocusNode());

              // 비밀번호 수정
              user!.updatePassword(_passwordController.text);
              await FirebaseAuth.instance.signOut();
              Get.offAll(() => const LoginPage());
            }
          },
          child: const Text("비밀번호 수정")
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
    _passwordController.dispose();
    _password2Controller.dispose();
    super.dispose();
  }
}