import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:radishmarket/change_profile_image.dart';
import 'package:radishmarket/login_page.dart';
import 'package:radishmarket/password_edit_page.dart';
import 'package:radishmarket/profile_edit_page.dart';

import 'main.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);


  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final User? user = FirebaseAuth.instance.currentUser;

  String _name = '이름';
  String _email = '이메일';

  File? _image;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String _profileImageURL = "";

  final picker = ImagePicker();
  Uri? selectedImage;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('사용자 정보'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage:NetworkImage(_profileImageURL),
                  radius: 30,
                ),
                SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () {
                      _uploadImage(ImageSource.gallery);
                    },
                  //=> Get.to(()=> const ChangeProfileImage()),
                  //{_uploadFile(context);},
                    child: const Text('프로필 변경'),
                ),
              ],
            ),
            /*ClipOval(
              child: Image(
                width: 100,
                image: AssetImage('assets/images/main.png'),
              ),
            ),*/
            SizedBox(height: 20.0),
            Container(
              height: 120.0, // borderheight 원값은 130
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black,
                    style: BorderStyle.solid,
                    width: 1
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(_name),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: Text(_email),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      // 11_1 수정
                      onPressed: () => Get.to(()=> const ProfileEditPage()),
                      child: const Text('정보 수정'),
                    ),
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Get.to(()=> const PasswordEditPage()),
                      child: const Text('비밀번호 수정'),
                    ),
                  ),
                ),
              ],
            ),

            /*Container(
                height: 100,
                width: double.infinity,
                padding: const EdgeInsets.only(top: 50.0), // 8단위 배수가 보기 좋음
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Get.offAll(()=>const LoginPage());
                  },
                  child: const Text("로그아웃"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepOrange,
                  ),
                ),
              ),*/
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        width: double.infinity,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0), // 8단위 배수가 보기 좋음
        child: ElevatedButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Get.offAll(()=>const LoginPage());
          },
          child: const Text("로그아웃"),
          style: ElevatedButton.styleFrom(
            primary: Colors.deepOrange,
          ),
        ),
      ),
    );
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

  // 프로필 이미지 가져오기
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

  /*Future _getImage() async {

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery, maxWidth: 200
    );

    setState(() {
      _image = File(pickedFile!.path);
      logger.d('path:$_image');
    });

  }

  Future _uploadFile(BuildContext context) async {

    _getImage();

    final Reference storageRef =
        _firebaseStorage.ref()
            .child('profile')
            .child('${DateTime.now().millisecondsSinceEpoch}.png');
    final UploadTask uploadTask = storageRef.putFile(_image!);
    await uploadTask.whenComplete(() => null);

    //final Future<String> url = (await uploadTask).ref.getDownloadURL();
    final downloadUrl = (await uploadTask).ref.getDownloadURL();
    print('url is $downloadUrl');

    await FirebaseFirestore.instance.collection('profile').add({
      'profileUrl': downloadUrl,
      'uid': user!.uid
    });

    _profileImageURL = downloadUrl.toString();

    setState(() {
      _profileImageURL = downloadUrl.toString();
    });
  }*/

  // Storage에 프로필 이미지 업로드
  Future _uploadImage(ImageSource source) async {
    try{
      XFile? image = await picker.pickImage(source: source);
      _image = File(image!.path);

      final Reference ref = _firebaseStorage.ref()
          .child('profile')
          .child('${DateTime.now().millisecondsSinceEpoch}.png');

      final UploadTask uploadTask = ref.putFile(
          _image!,
          SettableMetadata(contentType: 'image/png')
      );

      //완료까지 대기
      await uploadTask.whenComplete(() => null);

      final downloadUrl = await ref.getDownloadURL();

      //profileUrl firestore에 업로드
      await FirebaseFirestore.instance.collection('user').doc(user!.uid).update({
        'profileUrl': downloadUrl,
        //'uid': user!.uid
      });

    } on FirebaseException catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    //해당 클래스가 호출되었을떄
    super.initState();

    // 1차시 edit
    _getUser();
    _getProfile();

  }
  @override
  void dispose() {
    // 해당 클래스가 사라질떄

    super.dispose();
  }


}