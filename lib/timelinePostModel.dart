import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'googleLoginScreen.dart';
import 'models/postTemplateCondensed.dart';
import 'models/postTemplateExpanded.dart';
import 'models/user.dart';

class timelinePostTemplate extends StatelessWidget {
  final String title;
  final String description;
  final List <String> tags ;
  final List<String> urlList;
  final String postImageUrl;
  final String postID;
  final String ownerID;
  final String postStatus;
  final int cookiesToAward;

  String photoUrl;
  String username;
  String displayName;


  timelinePostTemplate({this.title, this.description, this.tags,
      this.urlList, this.postImageUrl, this.postID, this.ownerID,
      this.postStatus, this.cookiesToAward});

  factory timelinePostTemplate.fromDocument(DocumentSnapshot doc) {
    return timelinePostTemplate(
      postStatus : doc.data()['postStatus'],
      ownerID: doc.data()["ownerID"],
      postID: doc.data()['postID'],
      title: doc.data()['postTitle'],
      description: doc.data()['description'],
      postImageUrl: doc.data()['imageUrl'],
      urlList: doc.data()['siteLinks'].cast<String>(),
      tags:  doc.data()['tags'].cast<String>(),
      cookiesToAward: doc.data()['cookiesToAward'],
    );
  }



  buildPostHeader(){
    return FutureBuilder(
      future: usersRef.doc(ownerID).get(),
        builder:(context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting){
            return Container(
              height: 50,
              width: 50,
              padding: EdgeInsets.only(bottom: 10.0),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.purple),
                ),
              ),
            );
          }
          else if(snapshot.connectionState == ConnectionState.done){
            User postOwner = User.fromDocument(snapshot.data);
            Widget col = Padding(
              padding: const EdgeInsets.only(left:15.0),
              child: Row(
              children: [
                CircleAvatar(backgroundImage: CachedNetworkImageProvider(postOwner.photoUrl,),radius: 40),
                SizedBox(width: 5.0,),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:6.0,bottom: 25),
                      child: Text("${postOwner.username}   ",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black,
          background: Paint()
          ..strokeWidth = 22.0
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeJoin = StrokeJoin.round),),
                    ),
                    SizedBox(height: 5.0,),
                  ],
                )
              ]
            )
            );
            Widget listTile = ListTile(
              leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(postOwner.photoUrl,),radius: 72),
              title: Text("${postOwner.username}",style: TextStyle(color: Colors.black,backgroundColor: Colors.grey
              ),),
              subtitle: Text("${postOwner.username}",style: TextStyle(color: Colors.black,backgroundColor: Colors.grey),),
              tileColor: Colors.transparent,
            );
            return col;
          }
          else{
            return Text('Could not build post header!');
          }
        });
  }

  Widget statusOval(){
    return CircleAvatar(backgroundImage: AssetImage("assets/images/post$postStatus.png"),backgroundColor:Colors.white,radius: 12);
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        Column(
          children: [
            SizedBox(height:30.0),
            Center(
              child: SizedBox(
                height: 375,
                width: MediaQuery.of(context).size.width-30,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 55,
                          child: ListTile(
                            title: Row(
                              children: [
                                Flexible(
                                  flex:5,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:60.0,top:13,right: 10,),
                                    child: Text(title, overflow: TextOverflow.ellipsis,maxLines: 3,softWrap: false,style: TextStyle(fontSize: 18),),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top:10,right: 10),
                                    child: statusOval(),
                                  ),
                                )
                              ],
                            ),
                            trailing: GestureDetector(
                              onTap: (){print("owner ID is ${ownerID} and post status is ${postStatus}");
                              Navigator.push(context,MaterialPageRoute(builder: (context)=> postExpanded(cookiesToAward: cookiesToAward,postStatus: postStatus, ownerID: ownerID, title: title, description: description, tags: tags, urlList: urlList, postImageUrl: postImageUrl,postID: postID,)));},
                              child: RadiantGradientMask(child: Icon(Icons.arrow_forward,size: 35,color: Colors.white,),),
                            ),
                          ), //Title and Read More Button that directs to an instance of postTemplateExpanded
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:15),
                          child: Divider(thickness: 1.5,),
                        ),
                        Expanded(child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius: BorderRadius.vertical(top:Radius.circular(34),bottom:Radius.circular(34),),
                          ),
                          child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(22)),
                            child: Image(image: CachedNetworkImageProvider(postImageUrl),
                              fit: BoxFit.contain,
                              height: 300,),),),) //Post image displayed in a rounded rectangle
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        buildPostHeader(),
      ],
    );
  }




}