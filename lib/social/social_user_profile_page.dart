import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:thejointapp/models/user.dart';
import 'package:thejointapp/services/databse.dart';
import 'package:thejointapp/social/post/post_card.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;

            return NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Edit Profile'),
                        onPressed: (){
                          //TODO: implement Edit profile page here
                        },
                      ),
                    ],
                    pinned: true,
                    floating: false,
                    bottom: TabBar(
                      unselectedLabelColor: Colors.grey,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Colors.black,
                      controller: _tabController,
                      tabs: <Widget>[
                        Tab(
                            //text: 'Profile',
                            child: Text(
                              'Profile',
                              style: TextStyle(color: Colors.black),
                            ),
                            icon: Icon(
                              Icons.account_circle,
                              color: Colors.black,
                            )),
                        Tab(
                          //text: "Timeline",
                          icon: Icon(
                            Icons.timeline,
                            color: Colors.black,
                          ),
                          child: Text(
                            'Timeline',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: <Widget>[
                  UserDetails(
                    user: user,
                    userData: userData,
                  ),
                  UserTimeline(
                    user: user,
                    userData: userData,
                  ),
                ],
                controller: _tabController,
              ),
            );
          } else {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}

//user details class
class UserDetails extends StatefulWidget {
  final user;
  final userData;

  const UserDetails({Key key, this.user, this.userData}) : super(key: key);
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<UserData>(
          stream: DatabaseService(uid: widget.user.uid).userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserData userData = snapshot.data;
              return Column(
                children: <Widget>[
                  SizedBox(
                    height: 8,
                  ),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Stack(
                            alignment: Alignment.topRight,
                            children: <Widget>[
                              Container(
                                color: Colors.grey,
                                child: userData.backgroundImageUrl == null
                                    ? Image.network(
                                        'https://images.unsplash.com/photo-1488643637913-82a3820cf051?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1950&q=80',
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        '${userData.backgroundImageUrl}',
                                        fit: BoxFit.cover,
                                      ),
                                height: 250,
                                width: MediaQuery.of(context).size.width,
                              ),
                            ],
                          ),
                          Container(
                            height: 120,
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            child: userData.profilePicUrl == null
                                ? ClipOval(
                                    child: CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        child: Icon(
                                          Icons.account_circle,
                                          size: 50,
                                          color: Colors.white,
                                        )))
                                : ClipOval(
                                    child: Image.network(
                                    '${userData.profilePicUrl}',
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Container(
                                        color: Colors.grey,
                                        height: 100,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes
                                                : null,
                                            strokeWidth: 1,
                                            backgroundColor: Colors.grey,
                                            valueColor: AlwaysStoppedAnimation(
                                                Colors.black),
                                          ),
                                        ),
                                      );
                                    },
                                  )),
                            height: MediaQuery.of(context).size.width / 3,
                            width: MediaQuery.of(context).size.width / 3,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            '${userData.username}',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            '${userData.name}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                       
                        Container(
                          child: Text(
                            'About me',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            '${userData.aboutMe}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          child: Text(
                            'Relationship Status',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            userData.relationshipStatus != null
                                ? '${userData.relationshipStatus}'
                                : 'N/A',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          child: Text(
                            'College',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            userData.college != null
                                ? '${userData.college}'
                                : 'N/A',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          child: Text(
                            'Year',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            userData.year != null ? '${userData.year}' : 'N/A',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          child: Text(
                            'Department',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            userData.dept != null ? '${userData.dept}' : 'N/A',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          child: Text(
                            'Gender',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            '${userData.gender}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Container(
                child: Center(child: Text('Loading...')),
              );
            }
          }),
    );
  }
}

//user timeline class
class UserTimeline extends StatefulWidget {
  final user;
  final userData;

  const UserTimeline({Key key, this.user, this.userData}) : super(key: key);
  @override
  _UserTimelineState createState() => _UserTimelineState();
}

class _UserTimelineState extends State<UserTimeline> {
  @override
  Widget build(BuildContext context) {
    return PaginateFirestore(
      query: Firestore.instance
          .collection('social')
          .document('posts')
          .collection('userPostCollection')
          .document(widget.user.uid)
          .collection('userPosts')
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
        return PostCard(
          post: snapshot,
          user: widget.user,
          passed: false,
        );
      },
    );
  }
}
