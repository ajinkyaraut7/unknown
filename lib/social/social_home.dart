import 'package:flutter/material.dart';
import 'package:thejointapp/services/auth.dart';
import 'package:thejointapp/social/post/post_content.dart';
import 'package:thejointapp/social/social_feed_page.dart';
import 'package:thejointapp/social/social_search_page.dart';
import 'package:thejointapp/social/social_trending_page.dart';
import 'package:thejointapp/social/social_user_profile_page.dart';

import 'structures/bottomTabItem.dart';

class SocialHome extends StatefulWidget {
  @override
  _SocialHomeState createState() => _SocialHomeState();
}

class _SocialHomeState extends State<SocialHome> {
  AuthService _auth = AuthService();
  int selectedPosition = 0;
    Widget currentPage;


  @override
  void initState() {
    currentPage = FeedPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Social Home Screen",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          FlatButton.icon(
            label: Text('Log out'),
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await _auth.signOut();
            },
          )
        ],
      ),

      body: currentPage,

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>PostContent()));
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
          size: 30,
        ),
        backgroundColor: Colors.lightBlue,
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5,
        color: Colors.black,
        shape: CircularNotchedRectangle(),
        child: Container(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              BottomTabItem(
                icon: Icons.home,
                isSelected: selectedPosition == 0,
                onTap: () {
                  setState(() {
                    selectedPosition = 0;
                    currentPage = FeedPage();
                  });
                },
              ),
              SizedBox(
                width: 10,
              ),
              BottomTabItem(
                icon: Icons.trending_up,
                isSelected: selectedPosition == 1,
                onTap: () {
                  setState(() {
                    selectedPosition = 1;
                    currentPage = Trending();
                    print('trending');
                  });
                },
              ),
              SizedBox(
                width: 100,
              ),
              BottomTabItem(
                icon: Icons.search,
                isSelected: selectedPosition == 2,
                onTap: () {
                  setState(() {
                    selectedPosition = 2;
                    currentPage = Search();
                    print('search');
                  });
                },
              ),
              SizedBox(
                width: 10,
              ),
              BottomTabItem(
                icon: Icons.person,
                isSelected: selectedPosition == 3,
                onTap: () {
                  setState(() {
                    selectedPosition = 3;
                    currentPage = UserProfile();
                    print('userProfile');
                  });
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
