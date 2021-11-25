import 'package:radishmarket/login_page.dart';
import 'package:radishmarket/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {

  final User? user = FirebaseAuth.instance.currentUser;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController(); //입력되는 값을 제어

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('사용자 정보'),
       ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
                children: [
                _nameWidget(),
                const SizedBox(height: 20.0),
                _emailWidget(),
                const SizedBox(height: 20.0),
                _profileEditButtonWidget(),
            ],
          ),
        ),
      ),
    );
  }

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

  Widget _profileEditButtonWidget() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              FocusScope.of(context).requestFocus(FocusNode());

              // 이메일 수정
              user!.updateEmail(_emailController.text);

              //이름 수정
              FirebaseFirestore.instance.collection('user').doc(user!.uid)
                  .update({
                    'name': _nameController.text
                }).then((value) async {
                await FirebaseAuth.instance.signOut();
                Get.offAll(() => const LoginPage());
              }).catchError((e){
                logger.e(e);
                // $ 표시 부분은 유동적인 값이므로 const 사용 불가능.
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('$e'),
                  backgroundColor: Colors.deepOrange,
                ));
              });
            }
          },
          child: const Text("정보 수정")
      ),
    );
  }


  @override
  void initState() {
    //해당 클래스가 호출되었을떄
    super.initState();

    // 1차시 edit
    _getUser();
  }
  @override
  void dispose() {
    // 해당 클래스가 사라질떄

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
            // 이미 정의되어있기 때문에 email, name을 다시 정의해줄 필요 없음
            _nameController = TextEditingController(text:name);
            _emailController = TextEditingController(text:email);
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