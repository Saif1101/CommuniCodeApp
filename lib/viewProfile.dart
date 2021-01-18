import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';

//Pages
import 'editProfile.dart';
import 'googleLoginScreen.dart';
import 'models/user.dart';
import 'models/postTemplateCondensed.dart';


class viewProfile extends StatefulWidget {
  final String profileID;


  viewProfile({@ required this.profileID});
  @override
  _viewProfileState createState() => _viewProfileState();
}

class _viewProfileState extends State<viewProfile> {

  final String currentUserId = googleSignIn.currentUser.id;
  bool postsLoading = false;
  List<Widget>postsList=[];
  List <Widget> badges = [];
  bool badgesLoading = false;

  bool isFollowing = false;
  int followerCount = 0;
  int followingCount = 0;

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfilePosts();
    checkIfFollowing();
  }

  checkIfFollowing() async {
    DocumentSnapshot doc = await followersRef
        .doc(widget.profileID)
        .collection('userFollowers')
        .doc(currentUserId)
        .get();
    setState(() {
      isFollowing = doc.exists;
    });
  }

  getFollower() async {
    QuerySnapshot snapshot = await followersRef
        .doc(widget.profileID)
        .collection('userFollowers')
        .get();

    setState(() {
      followerCount = snapshot.docs.length;
    });
  }


  getProfilePosts  () async {
    print("Getting profile posts");
    setState(() {
      postsLoading = true;
    });
    QuerySnapshot snapshot = await postsRef
    .doc(widget.profileID)
    .collection('userPosts')
    .orderBy('timestamp',descending: true)
    .get();
    print("Query get complete");
    setState(() {
      print("Making posts from document");
      postsList = snapshot.docs.map<Widget>((doc) => postTemplate.fromDocument(doc)).toList();
      print("Post making complete");
      postsLoading = false;

    });
  } //Querying firestore and yielding all posts by the user whose profile is being visited

  buildPosts(){
    if(postsLoading){
      return Container(
        padding: EdgeInsets.only(bottom: 10.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.purple),
        ),
      );
    }
    else if(postsList.isEmpty){
      return SizedBox(
        height: 300,
        child: Center(
          child: (
          Text("No Posts!")
          ),
        ),
      );
    }
    else{
      return SizedBox(height: 300,
          width: MediaQuery.of(context).size.width,
          child: Swiper(layout: SwiperLayout.STACK, itemCount: postsList.length,itemHeight: 300,itemWidth: 350, itemBuilder: (context, index){return postsList[index];},));
    }
  } //Returning a SWIPER Widget containing all posts moulded in the format specified by the postTemplateCondensed



  buildCountsRow(int cookieCount) {
    return Padding(
      padding: const EdgeInsets.only(
          right: 38.0, left: 38.0, top: 15, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          makeBadges(), // GridView Scrollable Badges Container
          Container(
            color: Colors.black,
            width: 1,
            height: 22,
          ),
          Column(
            children: [
              CircleAvatar(
                radius: 26,
                  backgroundImage: AssetImage('assets/images/cookieVector.jpg')),
              Text(cookieCount.toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,),
              ),
            ],
          ),
          Container(
            color: Colors.black,
            width: 1,
            height: 22,
          ),
          buildProfileButton(),
        ],
      ),
    );
  } //Returns row containing the number of followers/following/posts
  //^^^TO BE REPLACED BY BADGES

  badgeTemplate(String lang){
    return SizedBox(
      width: 55,
      height: 55,
      child: Image(image: AssetImage('assets/Icons/${lang}Badge.png'),fit: BoxFit.contain,),
    );
  }



  makeBadges() {
    return FutureBuilder(
      future: usersRef.doc(widget.profileID).get(),
        builder: (context,snapshot) {
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
            List <Widget> badgesTemp = [];
            User user = User.fromDocument(snapshot.data);
            List languagesList = user.languages;

            for(int i = 0; i<languagesList.length;i++){
              badgesTemp.add(badgeTemplate(languagesList[i]));
            }
            return Container(
              height: 120,
              width: 120,
              child: Center(
                child: GridView.count(
                    shrinkWrap: true,
                    crossAxisSpacing: 5,
                    childAspectRatio: 1,
                    crossAxisCount: 2,
                    children: badgesTemp
                ),
              ),
            );
          }
          else{
            return (Text("Something went wrong"));
          }
        }
        );
  }

//  profileHeaderListTile(){
//    return ListTile(
//      leading: CircleAvatar(
//        radius: 35,
//        backgroundImage: CachedNetworkImageProvider(
//            user.photoUrl),
//        //Add backgroundImage: User's Profile Image
//      ),
//      title: Text('${user.username}',
//          style: GoogleFonts.oswald(
//              fontSize: 40,
//              color: Colors.black,
//              fontWeight: FontWeight.w500
//          )
//      ),
//      subtitle: Text('${user.displayName}',
//        style: TextStyle(
//          fontWeight: FontWeight.bold,
//          color: Colors.black,
//
//        ),
//      ),
//    );
//  }

  buildProfileHeader() {
    return FutureBuilder(
      future: usersRef.doc(widget.profileID).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: EdgeInsets.only(bottom: 10.0),
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.purple),
            ),
          );
        }
        else if (snapshot.connectionState == ConnectionState.done) {
          User user = User.fromDocument(snapshot.data);
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 25,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 35,
                    backgroundImage: CachedNetworkImageProvider(
                        user.photoUrl),
                    //Add backgroundImage: User's Profile Image
                  ),
                  title: Text('${user.username}',
                      style: GoogleFonts.oswald(
                          fontSize: 40,
                          color: Colors.black,
                          fontWeight: FontWeight.w500
                      )
                  ),
                  subtitle: Text('${user.displayName}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,

                    ),
                  ),
                  trailing: currentUserId == widget.profileID?RadiantGradientMask(
                    child: IconButton(icon: Icon(Icons.exit_to_app),
                        color: Colors.white,
                      onPressed: ()=> googleSignIn.signOut(),
                    ),
                  ):Text('')
                ),
              ),
              buildCountsRow(user.cookies),//Followers count and the follow/unfollow/edit profile button
              //User Bio Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5.0),
                child: Text(
                  user.bio,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.black
                  ),
                ),
              ),
            ],);
        }
        else {
          return Text("Something Went Wrong!");
        }
      },
    );
  }

  buildButton({String text, Function function}){
  return Container(
    padding: EdgeInsets.only(left:18, right:  18, top: 8, bottom:8),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(33)),
        gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.deepPurpleAccent],
            begin: Alignment.bottomRight,
            end: Alignment.centerLeft)
    ),
    child: GestureDetector(
      onTap: function,
      child: Text(text,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
        ),
      ),
    ),
  );
  } // button to display given text and perform specified function

  pushToEditProfile(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> editProfile(currentUserID: widget.profileID))).then(onGoBack);
  } //Method to specify whether to direct FOLLOW/EDIT button press to edit profile page

  handleUnfollowUser(){
    setState(() {
      isFollowing = false;
    });
    //remove this user from the profile's followers collection
    followersRef
        .doc(widget.profileID)
        .collection('userFollowers')
        .doc(currentUserId)
        .get().then((doc){
          doc.reference.delete();
    });                               //DELETE IF PRESENT
    //delete user in the profile's following collection
    followingRef
        .doc(currentUserId)
        .collection('userFollowing')
        .doc(widget.profileID)
        .get().then((doc){
      doc.reference.delete();
    });
  }

  handleFollowUser(){
    setState(() {
      isFollowing = true;
    });
    //Make auth user follower of Another user (update their followers collection)
    followersRef
    .doc(widget.profileID)
    .collection('userFollowers')
    .doc(currentUserId)
    .set({});
    //Put this user in the profile's following collection
    followingRef
    .doc(currentUserId)
    .collection('userFollowing')
    .doc(widget.profileID)
    .set({});
  }

  buildProfileButton(){ //building the EDIT/FOLLOW Button next to the followers/following counts
    // viewing your own profile - should show edit profile button
    //viewing someone else's profile -> should show follow button
    bool isProfileOwner;
    isProfileOwner= currentUserId == widget.profileID;
    if(isProfileOwner){
      return buildButton(
          text: "Edit Profile",
      function: pushToEditProfile);
    }
    else if(isFollowing){
      return buildButton(text:"Unfollow",function: handleUnfollowUser);
    }
    else if(!isFollowing){
      return buildButton(text: "Follow",function: handleFollowUser);
    }
  }



  @override
  Widget build(BuildContext context) {
    print('${widget.profileID}');
    return Scaffold(
      backgroundColor: Color(0xff09031D),
        body: Stack(
          children: [
            Positioned.fill(
                child: Image(
                  image: AssetImage('assets/images/ThemeDark.png'),
                  fit : BoxFit.fill,
                )),
            ListView(
              children: [
                Card(
                  shadowColor: Colors.black,
                  elevation:25.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(64),
                    )
                  ),
                  child: buildProfileHeader(),
                ),
                Container(
                  child: Container(
                    decoration: BoxDecoration(
                        color:  Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.only(topRight:Radius.circular(34) )
                    ),
                    child: Column(
                      children: [
                        Align(alignment: Alignment(-1,-1),
                            child: Text("Posts",
                              style: TextStyle(color: Colors.white,
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold,
                              ),
                            ),
                        ),
                        buildPosts()
                      ],
                    ),
                  ),
                )
              ],
    ),
          ],
        )
    );
  }
}
