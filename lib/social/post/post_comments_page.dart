import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thejointapp/models/user.dart';
import 'package:thejointapp/services/databse.dart';

class Comments extends StatefulWidget {
  final DocumentSnapshot post;

  const Comments({Key key, this.post}) : super(key: key);
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController commentController = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Comments",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<UserData>(
          stream: DatabaseService(uid: user.uid).userData,
          builder: (context, snapshot) {
            UserData userData = snapshot.data;
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('social')
                        .document('posts')
                        .collection('postReactions')
                        .document('comments')
                        .collection(widget.post['postId'])
                        .orderBy('timeStamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot commentSnapshot =
                                snapshot.data.documents[index];
                            return Card(
                              elevation: 2,
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        commentSnapshot['username'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(commentSnapshot['comment']
                                          .toString()),
                                    ],
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        commentSnapshot['profilePicUrl']),
                                    backgroundColor: Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Container(
                            child: Center(
                          child: Text('Be the first one to comment'),
                        ));
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: Form(
                           key: _formKey,
                          child: TextFormField(
                            controller: commentController,
                            maxLines: 2,
                            validator: (value) => value.isEmpty
                                ? 'Please write your comment'
                                : null,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Write your comment here'),
                            onChanged: (val) {
                              setState(() {
                                // _comment = val;
                                print(val);
                              });
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        icon: CircleAvatar(
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {
                          if(_formKey.currentState.validate()){
                            updateComment(user, userData);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }


  // method to update comment
  updateComment(user, userData) async {
    await Firestore.instance
        .collection('social')
        .document('posts')
        .collection('postReactions')
        .document('comments')
        .collection(widget.post['postId'])
        .document()
        .setData({
      'comment': commentController.text,
      'uid': user.uid,
      'postId': widget.post['postId'],
      'timeStamp': DateTime.now().millisecondsSinceEpoch,
      'username': userData.username,
      'profilePicUrl': userData.profilePicUrl,
    });
    commentController.clear();
  }
}
