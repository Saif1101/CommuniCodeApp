import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_inventory/googleLoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class activityFeed extends StatefulWidget {
  @override
  _activityFeedState createState() => _activityFeedState();
}

class _activityFeedState extends State<activityFeed> {

  getActivityFeed()async{
    QuerySnapshot snapshot = await activityFeedRef
        .doc(currentUser.id)
        .collection('feedItems')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .get();
    List<activityFeedItem> feedItems = [];
    snapshot.docs.forEach((doc) {
      feedItems.add(activityFeedItem.fromDocument(doc));
    });
    return feedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.white,
          title: Center(child: Text("Activity", style: TextStyle(color:Colors.black,fontWeight: FontWeight.w900,fontSize: 32.0),)),
        flexibleSpace: Image(image: AssetImage('assets/images/whiteBG.png'),
            fit: BoxFit.cover),
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: Image(
                image: AssetImage('assets/images/grayBG.png'),
                fit : BoxFit.fill,
              )
          ),
          Container(
            child: FutureBuilder(
              future : getActivityFeed(),
              builder: (context,snapshot){
                if(!snapshot.hasData){
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.purple),
                    ),
                  );
                }
                return ListView(children: snapshot.data);
              },
            )
          ),
        ],
      ),
    );
  }
}

Widget mediaPreview;
String activityItemText;

class activityFeedItem extends StatelessWidget {
  final String username;
  final String userId;
  final String type; // 'like', 'follow', 'comment'
  final String mediaUrl;
  final String postId;
  final String userProfileImg;
  final String commentData;
  final Timestamp timestamp;

  activityFeedItem({
    this.username,
    this.userId,
    this.type,
    this.mediaUrl,
    this.postId,
    this.userProfileImg,
    this.commentData,
    this.timestamp,
  });

  factory activityFeedItem.fromDocument(DocumentSnapshot doc) {
    return activityFeedItem(
      username: doc.data()['username'],
      userId: doc.data()['userId'],
      type: doc.data()['type'],
      postId: doc.data()['postId'],
      userProfileImg: doc.data()['userProfileImg'],
      commentData:doc.data()['commentData'],
      timestamp: doc.data()['timestamp'],
      mediaUrl: doc.data()['mediaUrl'],
    );
  }

  configureMediaPreview() {
    if (type == "like" || type == 'comment') {
      mediaPreview = GestureDetector(
        onTap: () => print('showing post'),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(

                decoration: BoxDecoration(
                  borderRadius:BorderRadius.all(Radius.circular(22)),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(mediaUrl),
                  ),
                ),
              )),
        ),
      );
    } else {
      mediaPreview = Text('');
    }
     if (type == 'follow') {
      activityItemText = "is following you";
    } else if (type == 'comment') {
      activityItemText = 'replied: $commentData';
    } else if (type == 'cookie') {
      activityItemText = 'awarded you a cookie!';
    } else {
      activityItemText = "Error: Unknown type '$type'";
    }
  }
  @override
  Widget build(BuildContext context) {
    configureMediaPreview();

    return Padding(
      padding: EdgeInsets.only(bottom:5.0),
      child: Container(
        color: Colors.white54,
        child: Card(
          elevation: 20.0,
          child: ListTile(
            title: GestureDetector(
              onTap: ()=> print("Show Profile"),
              child: RichText(
                overflow:  TextOverflow.ellipsis,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: username,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' $activityItemText',
                    )
                  ]
                )
              )
            ),
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(userProfileImg),
            ),
            subtitle: Text(
              timeago.format(timestamp.toDate()),
              overflow: TextOverflow.ellipsis,
            ),
            trailing: mediaPreview,
          ),
        ),
      )
    );
  }
}

