import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:thejointapp/models/user.dart';
import 'package:thejointapp/social/post/post_card.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return PaginateFirestore(
        query: Firestore.instance
            .collection('social')
            .document('posts')
            .collection('feedCollection')
            .orderBy('postId', descending: true),
        itemsPerPage: 20,
        initialLoader: Center(
            child: CircularProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        )),
        bottomLoader: Center(
            child: CircularProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        )),
        itemBuilder: (context, snapshot) {
          return PostCard(post: snapshot,user: user, passed: false,);
        },
      );
  }
}