import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:provider/provider.dart';
import 'package:thejointapp/common_screens/loading.dart';
import 'package:thejointapp/models/user.dart';
import 'package:thejointapp/services/databse.dart';
import 'package:thejointapp/social/post/post_card.dart';
import 'package:uuid/uuid.dart';

class Pass extends StatefulWidget {
  final DocumentSnapshot thisPost;

  const Pass({Key key, @required this.thisPost}) : super(key: key);
  @override
  _PassState createState() => _PassState();
}

class _PassState extends State<Pass> {
  bool passed = false;
  int numLines = 0;
  String content = '';
  TextEditingController postController = new TextEditingController();
  bool loading = false;

  @override
  void initState() {
    setState(() {
      passed = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              title: Text(
                "Pass",
                style: TextStyle(color: Colors.black),
              ),
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            body: StreamBuilder<UserData>(
              stream: DatabaseService(uid: user.uid).userData,
              builder: (context, snapshot) {
                UserData userData = snapshot.data;
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      PostCard(
                        post: widget.thisPost,
                        user: user,
                        passed: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          controller: postController,
                          maxLines: 10,
                          validator: (value) =>
                              value.isEmpty ? 'Please write your post' : null,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Write your passing comment here'),
                          onChanged: (val) {
                            setState(() {
                              content = val;
                              print(val);
                              numLines = ' '.allMatches(val).length + 1;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      NiceButton(
                        width: 150,
                        elevation: 0,
                        radius: 20,
                        fontSize: 15,
                        background: Colors.grey[900],
                        text: 'Share',
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          await Firestore.instance
                              .collection('pass')
                              .document()
                              .setData({
                            'content': content,
                            'uid': user.uid,
                            'postId':
                                '${DateTime.now().millisecondsSinceEpoch.toString()}${Uuid().v1()}',
                            'username':userData.username,
                            'profilePicUrl': userData.profilePicUrl, 
                            'oContent': widget.thisPost['content'],
                            'ouid': widget.thisPost['uid'],
                            'imageUrl': widget.thisPost['imageUrl'],
                            'oPostId': widget.thisPost['postId'],
                            'oUsername':widget.thisPost['username'],
                            'oProfilePicUrl': widget.thisPost['profilePicUrl']
                          });
                          setState(() {
                            loading = false;
                          });                          
                        },
                      ),
                    ],
                  ),
                );
              }
            ));
  }
}
