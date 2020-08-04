import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thejointapp/models/user.dart';
import 'package:thejointapp/social/post/post_comments_page.dart';
import 'package:thejointapp/social/post/post_pass.dart';

class PostCard extends StatefulWidget {
  final bool passed;
  final DocumentSnapshot post;
  final User user;

  const PostCard(
      {Key key,
      @required this.post,
      @required this.user,
      @required this.passed})
      : super(key: key);
  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isMorePressed = false;
  bool liked = false;
  int totalLikes = 0;
  int totalComments = 0;

  @override
  void initState() {
    super.initState();
    checkIfUserLikedPost();
    getTotalLikes();
    getTotalComments();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        borderOnForeground: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Color(0xffB0E2FF),
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 8,
            right: 8,
            left: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 4 / 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 80,
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 20,
                            backgroundImage:
                                NetworkImage(widget.post['profilePicUrl']),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.post['username'] != null
                                ? widget.post['username']
                                : 'theJoint',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onDoubleTap: () {
                        likePost(user);
                      },
                      child: Container(
                        child: widget.post['imageUrl'] != null
                            ? Image.network(widget.post['imageUrl'],
                                fit: BoxFit.cover, loadingBuilder:
                                    (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Container(
                                  height: 100,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress
                                                  .expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes
                                          : null,
                                      strokeWidth: 1,
                                      backgroundColor: Colors.grey,
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.black),
                                    ),
                                  ),
                                );
                              })
                            : Container(),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onDoubleTap: () {
                        likePost(user);
                      },
                      child: Container(
                        height: isMorePressed ? null : 70,
                        width: MediaQuery.of(context).size.width * 4 / 5,
                        child: Text(
                          widget.post['content'].toString(),
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                    Container(
                        color: Color(0xffB0E2FF),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                            ),
                            widget.post['numLines'] >= 20
                                ? FlatButton(
                                    child: Text(
                                      isMorePressed ? 'less' : 'more',
                                      style: TextStyle(color: Colors.cyan),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isMorePressed = !isMorePressed;
                                      });
                                    },
                                  )
                                : Container()
                          ],
                        )),
                    widget.passed
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FlatButton(
                                child: Text("Pass"),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Pass(
                                                thisPost: widget.post,
                                              )));
                                },
                              ),
                            ],
                          ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  InkWell(
                      onTap: () {
                        likePost(user);
                      },
                      child: liked
                          ? Icon(
                              CommunityMaterialIcons.heart,
                              size: 30,
                              color: Colors.red,
                            )
                          : Icon(
                              CommunityMaterialIcons.heart_outline,
                              size: 30,
                            )),
                  Text(totalLikes.toString()),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Comments(
                                    post: widget.post,
                                  )));
                    },
                    child: Icon(
                      CommunityMaterialIcons.comment_outline,
                      size: 30,
                    ),
                  ),
                  Text(totalComments.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //like post
  likePost(user) async {
    await Firestore.instance
        .collection('social')
        .document('posts')
        .collection('postReactions')
        .document('likes')
        .collection('Likes')
        .document('${widget.post['postId']}_${user.uid}')
        .get()
        .then((DocumentSnapshot ds) async {
      if (ds.exists) {
        setState(() {
          liked = false;
        });
        Firestore.instance
            .collection('social')
            .document('posts')
            .collection('postReactions')
            .document('likes')
            .collection('Likes')
            .document('${widget.post['postId']}_${user.uid}')
            .delete()
            .then((value) {});
      } else {
        //like the post
        setState(() {
          liked = true;
        });
        await Firestore.instance
            .collection('social')
            .document('posts')
            .collection('postReactions')
            .document('likes')
            .collection('Likes')
            .document('${widget.post['postId']}_${user.uid}')
            .setData({
          'reactionType': 'like',
          'postId': widget.post['postId'],
          'userId': user.uid,
        }).then((value) {});
      }
    });
  }

  // check if the post is liked by the user already
  checkIfUserLikedPost() async {
    print('docName: ${widget.post['postId']}_${widget.user.uid}');
    try {
      await Firestore.instance
          .collection('social')
          .document('posts')
          .collection('postReactions')
          .document('likes')
          .collection('Likes')
          .document('${widget.post['postId']}_${widget.user.uid}')
          .get()
          .then((DocumentSnapshot ds) {
        if (ds.exists) {
          print('doc exists');
          setState(() {
            liked = true;
          });
        } else {
          setState(() {
            liked = false;
          });
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // method to get the total number of likes on each post
  getTotalLikes() {
    print('get likes called');
    Firestore.instance
        .collection('social')
        .document('posts')
        .collection('postReactions')
        .document('likes')
        .collection('Likes')
        .where("postId", isEqualTo: widget.post['postId'])
        .snapshots()
        .listen((data) {
      setState(() {
        totalLikes = data.documents.length;
      });
    });
  }

  // method to get total number of comments
  getTotalComments() {
    print('get comments called');
    Firestore.instance
        .collection('social')
        .document('posts')
        .collection('postReactions')
        .document('comments')
        .collection(widget.post['postId'])
        .snapshots()
        .listen((data) {
      setState(() {
        totalComments = data.documents.length;
      });
      print('length: ${data.documents.length}');
      print('postId : ${widget.post['postId']}');
      print('data: ${data.documents}');
    });
  }
}
