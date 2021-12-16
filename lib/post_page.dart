import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'main.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);


  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController(); //입력되는 값을 제어
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _moneyController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  PickedFile? _image;
  File? _imageUrl;

  String _name = '이름';
  String _email = '이메일';



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("글 등록하기"),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '제목',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w200,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _titleController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '제목'
                  ),
                  validator: (String? value){
                    if (value!.isEmpty) {
                      return '제목을 입력해주세요.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),

                const Text(
                  '내용',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w200,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _contentController,
                  keyboardType: TextInputType.text,
                  maxLines: 7,
                  textAlign: TextAlign.start,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '내용',
                    alignLabelWithHint: true,
                  ),
                  validator: (String? value){
                    if (value!.isEmpty) {
                      return '내용을 입력해주세요.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: const Text(
                        '금액',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w200,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                        width: 272,
                        child: TextFormField(
                          maxLines: 1,
                          controller: _moneyController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '원 단위',
                            alignLabelWithHint: true,
                          ),
                          validator: (String? value){
                            if (value!.isEmpty) {
                              return '금액을 입력해주세요.';
                            }
                            return null;
                          },
                        ),
                    ),
                  ],
                ),

                const SizedBox(height: 20.0),
                Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: const Text(
                        '전화번호',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w200,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 272,
                      child: TextFormField(
                        maxLines: 1,
                        controller: _numberController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          //labelText: '원 단위',
                          alignLabelWithHint: true,
                        ),
                        validator: (String? value){
                          if (value!.isEmpty) {
                            return '번호를 입력해주세요.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                const Text(
                  '이미지',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w200,
                    letterSpacing: 2.0,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  child: Center(
                    child: _image == null
                      ? Icon(Icons.image)
                      : Image.file(File(_image!.path)),
                  )
                ),
                ElevatedButton(
                    onPressed: _getImageFromGallery,
                    child: const Text("이미지 가져오기"),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton:FloatingActionButton.extended(
          label: Text('업로드'),
          backgroundColor: Colors.deepOrange,
          onPressed: _uploadPost,
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

  Future _getImageFromGallery() async {
    var image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image!;
    });
  }

  //파이어베이스 포스트에 업로드
  Future _uploadPost() async{
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).requestFocus(FocusNode());

      String title = _titleController.text;
      String content = _contentController.text;
      String money = _moneyController.text;
      String number = _numberController.text;

      // 이미지 업로드
      _imageUrl = File(_image!.path); // 선택한 이미지의 경로

      final Reference ref = FirebaseStorage.instance.ref()
          .child('posting')
          .child('${DateTime.now().millisecondsSinceEpoch}.png');

      final UploadTask uploadTask = ref.putFile(
          _imageUrl!,
          SettableMetadata(contentType: 'image/png')
      );
      // 태스크 완료 대기
      await uploadTask.whenComplete(() => null);

      final downloadUrl = await ref.getDownloadURL();

      setState(() {
        title = _titleController.text;
        content = _contentController.text;
        money = _moneyController.text;
        number = _numberController.text;
      });

      //Firestore DB 업로드
      await FirebaseFirestore.instance.collection('post').add({
        'uid': user!.uid,
        'title': _titleController.text,
        'content': _contentController.text,
        'price': _moneyController.text,
        'number': _numberController.text,
        'author': _name,
        'image': downloadUrl,
        'datetime': DateTime.now().microsecondsSinceEpoch,
      }).catchError((e){
        logger.e(e);
      });

      Navigator.pop(context);

    }
  }
  
}