import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'main.dart';

class MySellPostPage extends StatefulWidget {
  const MySellPostPage({Key? key}) : super(key: key);


  @override
  State<MySellPostPage> createState() => _MySellPostPageState();
}

class _ArticleDescription extends StatelessWidget {
  const _ArticleDescription({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.publishDate,
    required this.readDuration,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String author;
  final String publishDate;
  final String readDuration;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                author,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black87,
                ),
              ),
              Text(
                '$publishDate - $readDuration',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomListItemTwo extends StatelessWidget {
  const CustomListItemTwo({
    Key? key,
    required this.thumbnail,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.publishDate,
    required this.readDuration,
  }) : super(key: key);

  final Widget thumbnail;
  final String title;
  final String subtitle;
  final String author;
  final String publishDate;
  final String readDuration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.0,
              child: thumbnail,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                child: _ArticleDescription(
                  title: title,
                  subtitle: subtitle,
                  author: author,
                  publishDate: publishDate,
                  readDuration: readDuration,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ?????? ?????? ??????
class _MySellPostPageState extends State<MySellPostPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  String _name = '??????';
  String _email = '?????????';
  String _profileImageURL = "";

  TextEditingController _undNameCon = TextEditingController();
  TextEditingController _undDescCon = TextEditingController();


  // ?????? ?????? (Update)
  void updateDoc(String docID, String name, String description) {
    db.collection('post').doc(docID).update({
      'title': name,
      'content': description,
    });
  }

  // ?????? ?????? (Delete)
  void deleteDoc(String docID) {
    db.collection('post').doc(docID).delete();
  }

  void showUpdateOrDeleteDocDialog(DocumentSnapshot doc) {
    _undNameCon.text = doc['title'];
    _undDescCon.text = doc['content'];
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("?????? / ????????????"),
          content: Container(
            height: 200,
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: "??????"),
                  controller: _undNameCon,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "??????"),
                  controller: _undDescCon,
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("??????"),
              onPressed: () {
                _undNameCon.clear();
                _undDescCon.clear();
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("????????????"),
              onPressed: () {
                if (_undNameCon.text.isNotEmpty &&
                    _undDescCon.text.isNotEmpty) {
                  updateDoc(doc.id, _undNameCon.text, _undDescCon.text);
                }
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("????????????"),
              onPressed: () {
                deleteDoc(doc.id);
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("?????? ?????????"),
        centerTitle: true,
      ),
      body:
      /*Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage:NetworkImage(_profileImageURL),
                  radius: 30,
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
            Container( // hasSize ????????? ?????? Container height ??????
              height: 530,
              child: ListView.separated(
                //padding: const EdgeInsets.all(6),
                  itemCount: entries.length,
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                        padding: const EdgeInsets.all(16),
                        child: Text('????????? ${entries[index]}')
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => const Divider()
              ),
            ),
          ],
        ),
      ),*/
      Padding(
        padding: const EdgeInsets.all(8.0),
        child:StreamBuilder<QuerySnapshot>(
          stream: db.collection('post').where('uid', isEqualTo:user!.uid).orderBy('datetime', descending: true).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots){
            if(!snapshots.hasData){
              return Center(
                child:CircularProgressIndicator()
              );
            }else{
              return Container(
                height: 700,
                child: ListView(
                  children: snapshots.data!.docs.map((DocumentSnapshot doc){
                    DateTime datetime = DateTime.fromMicrosecondsSinceEpoch(doc['datetime']);
                    return ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          GestureDetector(
                          child:CustomListItemTwo(
                              thumbnail: Image(
                                image: NetworkImage(doc['image']),
                              ),
                              title: '${doc['title']}',
                              subtitle: '${doc['content']}',
                              author: _name,
                              publishDate: DateFormat('yyyy-MM-dd HH:mm').format(datetime),
                              readDuration: '?????????'
                          ),
                            onLongPress: () {
                              showUpdateOrDeleteDocDialog(doc);
                            },
                          ),
                          Divider(color: Colors.black54, thickness: 0.5,)
                        ]
                      );
                  }).toList(),
                ),

              );
            }
          }
        )
      )
    );
  }

  @override
  void initState() {
    //?????? ???????????? ??????????????????
    super.initState();

    _getUser();
    _getProfile();

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
            content: Text('??????????????? ????????? ??? ????????????.'),
            backgroundColor: Colors.deepOrange,
          ));
        }
      }
    });
  }

  // ????????? ????????? ????????????
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
            content: Text('????????? ???????????? ????????? ??? ????????????.'),
            backgroundColor: Colors.deepOrange,
          ));
        }
      }
    });
  }

}