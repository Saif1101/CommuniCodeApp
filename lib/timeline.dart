import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_inventory/searchPage.dart';
import 'package:coding_inventory/timelinePostModel.dart';
import 'package:flutter/material.dart';

import 'googleLoginScreen.dart';
import 'models/user.dart';



final usersRef = FirebaseFirestore.instance.collection('users');

class Timeline extends StatefulWidget {
  final User currentUser;

  const Timeline({Key key, this.currentUser}) : super(key: key);
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<timelinePostTemplate> posts;
  List<String> followingList = [];

  @override
  void initState(){
    super.initState();
      getTimeline();
      getFollowing();

  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef
        .doc(currentUser.id)
        .collection('userFollowing')
        .get();
    if(mounted) {
      setState(() {
        followingList = snapshot.docs.map((doc) => doc.id).toList();
      });
    }
  }


  buildUsersToFollow() {
    return StreamBuilder(
      stream:
      usersRef.orderBy('timestamp', descending: true).limit(7).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.purple),
          );
        }
        List<UserResult> userResults = [];
        snapshot.data.documents.forEach((doc) {
          User user = User.fromDocument(doc);
          final bool isAuthUser = currentUser.id == user.id;
          final bool isFollowingUser = followingList.contains(user.id);
          // remove auth user from recommended list
          if (isAuthUser) {
            return;
          } else if (isFollowingUser) {
            return;
          } else {
            UserResult userResult = UserResult(user);
            userResults.add(userResult);
          }
        });
        return Card(
          child: Container(
            color: Colors.white.withOpacity(1),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    children: <Widget>[
                      Icon(
                        Icons.person_add,
                        color: Colors.black,
                        size: 25.0,
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Align(
                        alignment: Alignment(1,1),
                        child: Text("Start",
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.black,

                            fontSize: 32,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      SizedBox(width:10),
                      Align(
                        alignment: Alignment(1,1),
                        child: Text("Following",
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.black,

                            fontSize: 32,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(children: userResults),
              ],
            ),
          ),
        );
      },
    );
  }

  getTimeline() async{
    QuerySnapshot snapshot =  await timelineRef
        .doc(widget.currentUser.id)
        .collection('timelinePosts')
        .get();
    List<timelinePostTemplate> posts = snapshot.docs.map((doc) => timelinePostTemplate.fromDocument(doc)).toList();
    if(this.mounted) {
      setState(() {
        this.posts = posts;
      });
    }
  }
  buildTimeline() {
    if (posts == null) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.purple),
        ),
      );
    } else if (posts.isEmpty) {
      return Stack(
        children: [
          Positioned.fill(
              child: Image(
                image: AssetImage('assets/images/whiteBG.png'),
                fit : BoxFit.fill,
              )
          ),
          Align(
            alignment: Alignment(0,0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
                width:MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width*0.01),
              child: buildUsersToFollow()
//              Card(
//                elevation: 50,
//                child: Padding(
//                  padding: const EdgeInsets.all(18.0),
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    mainAxisSize: MainAxisSize.min,
//                    children: [
//                      Divider(color: Colors.black,thickness: 3.0,),
////                Container(
////                  decoration: BoxDecoration(
////                      image: DecorationImage(
////                          image: AssetImage('assets/images/noPostsToShow.png')
////                      )
////                  ),
////                ),
//                      Align(
//                        alignment: Alignment(1,1),
//                        child: Text("No",
//                          textAlign: TextAlign.right,
//                          style: TextStyle(color: Colors.black,
//
//                            fontSize: 32,
//                            fontWeight: FontWeight.w500,
//                          ),
//                        ),
//                      ),
//                      Align(
//                        alignment: Alignment(1,1),
//                        child: Text("Posts",
//                          textAlign: TextAlign.right,
//                          style: TextStyle(color: Colors.black,
//
//                            fontSize: 32,
//                            fontWeight: FontWeight.w500,
//                          ),
//                        ),
//                      ),
//                      Align(
//                        alignment: Alignment(1,1),
//                        child: Text("To",
//                          textAlign: TextAlign.right,
//                          style: TextStyle(color: Colors.black,
//
//                            fontSize: 32,
//                            fontWeight: FontWeight.w500,
//                          ),
//                        ),
//                      ),
//                      Align(
//                        alignment: Alignment(1,1),
//                        child: Text("Show",
//                          textAlign: TextAlign.right,
//                          style: TextStyle(color: Colors.black,
//
//                            fontSize: 32,
//                            fontWeight: FontWeight.w500,
//                          ),
//                        ),
//                      ),
//                      Divider(color: Colors.black,thickness: 3.0,),
//                      SizedBox(height: 50,),
//
//                    ],
//                  ),
//                ),
//              ),
            ),
          ),
        ],
      );
    } else {
      return Center(child: ListView(children: posts));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.white,
        elevation: 30.0,
        title: Center(child: Text("Timeline", style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 32.0),)),
        flexibleSpace: Image(image: AssetImage('assets/images/whiteBG.png'),
            fit: BoxFit.cover),
      ),
      body: Stack(
        children: [
//          Positioned.fill(  //
//              child: Image(
//                image: AssetImage('assets/images/grayBG.png'),
//                fit : BoxFit.fill,
//              )),
          RefreshIndicator(
            onRefresh: ()=>getTimeline(),
            child: buildTimeline(),
          ),
        ],
      ),
    );
  }
}
