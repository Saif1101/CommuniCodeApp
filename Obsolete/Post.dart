import 'package:coding_inventory/googleLoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../lib/models/user.dart';
import 'package:url_launcher/url_launcher.dart';


class Post extends StatefulWidget {
  final String postTitle;
  final String postId;
  final String ownerId;
  final String username;
  final String description;
  final String mediaUrl;
  final List urlList;
  final List tags;

  Post({
    this.postTitle,
  this.postId,
  this.ownerId,
  this.username,
  this.description,
  this.mediaUrl,
  this.urlList,
    this.tags,
  });

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      postTitle: doc.data()['postTitle'],
      postId: doc.data()['postID'],
      ownerId: doc.data()['ownerID'],
      username: doc.data()['username'],
      description: doc.data()['description'],
      mediaUrl: doc.data()['imageUrl'],
      urlList: doc.data()['siteLinks'],
      tags:  doc.data()['tags'],
    );
  }

  @override
  _PostState createState() => _PostState(
    postTitle: this.postTitle,
      postId: this.postId,
      ownerId: this.ownerId,
      username: this.username,
      description: this.description,
      mediaUrl: this.mediaUrl,
      urlList: this.urlList,
      tags: this.tags,
  );
}

class _PostState extends State<Post> {
  final String postTitle;
  final String postId;
  final String ownerId;
  final String username;
  final String description;
  final String mediaUrl;
  final List urlList;
  final List tags;

  _PostState({
    this.postTitle,
  this.postId,
  this.ownerId,
  this.username,
  this.description,
  this.mediaUrl,
  this.urlList,
  this.tags,
  });

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  ovalClipIconButton(String siteName, String url){
    return Container(
      width: 56,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 2.0,
              spreadRadius: 1.0,
            )
          ]
      ),
      child: ClipOval(
        child: Material(// button color
          child: InkWell(
            splashColor: Colors.red, // inkwell color
            child: SizedBox(width: 56, height: 56, child:Image(
              image: new AssetImage("assets/Icons/$siteName.jpg"),
              width: 32,
              height:32,
              color: null,
              fit: BoxFit.scaleDown,
            ),),
            onTap: () => _launchURL(url),
          ),
        ),
      ),
    );
  }

  buildCircleAvatar(){
    return FutureBuilder(
        future: usersRef.doc(ownerId).get(),
        builder: (context,snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              padding: EdgeInsets.all(10.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.purple),
              ),
            );
          }
          else if ((snapshot.connectionState == ConnectionState.done)){
            User user = User.fromDocument(snapshot.data);
            return Container(
              child: Column(
                children: [
                  CircleAvatar(
                      radius: 42,
                      backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                    backgroundColor: Colors.grey,
                  ),
                  Text(user.username), //To display the username below the circle avatar
                ],
              ),
            );
          }
          else{
            return Text("Hello");
          }
        }
    );
  }

  buildPostHeader(){
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(left : 70.0),
        child: Text(postTitle,
          style:TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16
          ) ,),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 10.0,left: 80.0),
        child: Text(description),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Lik',style: TextStyle(fontSize: 20),),
          IconButton(icon: Icon(Icons.favorite),),
        ],
      ),
    );
  }

  buildPostImageSpace(){
    Container(
        foregroundDecoration:BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [0, 0.3],
          ),),
        child: Image(image: NetworkImage(mediaUrl),fit: BoxFit.contain,height:300));
  }

  buildLinkButtonRow(){
    List <Widget> buttons = [];
    for(int i = 0; i<urlList.length; i+2){
      buttons.add(ovalClipIconButton(urlList[i], urlList[i+1]));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: buttons,
    );
  }

  buildTagsRow(){
    Container(
      height: 44,
      width: 300,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(22))
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        itemBuilder: (BuildContext context, int index){
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.black)
            ),
            margin: EdgeInsets.only(right: 13, left: 13, bottom: 5),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, bottom: 5.0, right: 15, left:15
              ),
              child: Text(tags[index],
                style: TextStyle(
                    color: Colors.black
                ),),
            ),
          );
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 150,//*Container
          child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)
                ),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buildPostHeader(),
                    Stack(
                      children: [
                        buildPostImageSpace(),// Container displaying the post image
                        Positioned(
                          bottom: 10.0,
                            child: Container(
                              width: 150,
                              //Set width parameter equal to *Container so that the buttons space themselves out equally
                              child:
                                Padding(
                                    padding: const EdgeInsets.only(left:5,right: 10),
                                  child: buildLinkButtonRow(),)//Row With LinkButtons
                            ),
                        ),

                      ],
                    ),
                    buildCircleAvatar(), //Display the profile image as a circleavatar on top of the stack
                  ],
                ),
              )
            ],
          )
        ],
          ),
        ),
      ],
    );
  }
}
