import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_inventory/activityFeedPage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


import 'models/user.dart';

//PAGES
import 'createPost.dart';
import 'searchPage.dart';
import 'timeline.dart';
import 'viewProfile.dart';
import 'createNewUserPage.dart';
import 'models/postTemplateCondensed.dart';







final Reference firebaseStorageRef = FirebaseStorage.instance.ref(); //To upload and storage the images

final timelineRef = FirebaseFirestore.instance.collection('timeline'); //To store posts that show in each users' timeline
final postsRef = FirebaseFirestore.instance.collection('posts'); //To store information about the posts(title/description/tags/urls/ImageUrl)
final usersRef = FirebaseFirestore.instance.collection('users');//To store information about user profiles (id/username/email/displayPhoto/displayName/bio)
final commentsRef = FirebaseFirestore.instance.collection('comments');//To store comment information
final followersRef = FirebaseFirestore.instance.collection('followers');//To store followers information
final followingRef = FirebaseFirestore.instance.collection('following');//To store following information
final activityFeedRef = FirebaseFirestore.instance.collection('feed');//To store data and build an activity feeds for users

final GoogleSignIn googleSignIn = GoogleSignIn();
final firebaseAuth.FirebaseAuth _auth = firebaseAuth.FirebaseAuth.instance;
final DateTime timestamp = DateTime.now();

User currentUser; ///By creating a user variable containing all the data
///the user operating the app, we'll be able to pass that data throughout
///our app and provide access to more features to the user.

class loginPageOnlyGoogle extends StatefulWidget {
  @override
  _loginPageOnlyGoogleState createState() => _loginPageOnlyGoogleState();
}

class _loginPageOnlyGoogleState extends State<loginPageOnlyGoogle> {
  int pageIndex = 0;
  bool isAuth = false;
  PageController pageController;

  logout(){
    googleSignIn.signOut();
  }

  login() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final firebaseAuth.AuthCredential credential = firebaseAuth.GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );



    final firebaseAuth.UserCredential authResult = await _auth.signInWithCredential(credential);


  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    //DETECTS WHEN A USER IS SIGNED IN
    googleSignIn.onCurrentUserChanged.listen((account) {
     handleSignIn(account);
    }, onError:(err) {
      print("ERROR : $err");
    } );
//     Re authenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then((account){
      handleSignIn(account);
    }, onError: (err){
      print("Error : $err");
    });
  }

  handleSignIn(GoogleSignInAccount account) async {
    if(account != null){

      await createUserInFirestore();
      setState(() {
        isAuth=true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }



  createUserInFirestore() async {
    /* 1) Check if user already exists in the firebase database
    according to their ID */
    final GoogleSignInAccount user = googleSignIn.currentUser;

    final GoogleSignInAuthentication googleSignInAuthentication = await user.authentication;

    final firebaseAuth.AuthCredential credential = firebaseAuth.GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
//    print("Current user id: ${currentUser.id}");


    final firebaseAuth.UserCredential authResult = await _auth.signInWithCredential(credential);
    DocumentSnapshot doc = await usersRef.doc(user.id).get();

    if(!doc.exists){
      /*2) If NOT, direct the user to the set up profile page. ->
     Get their username and generate new ID
     */
     final usernameAndLanguages = await Navigator.push(context, MaterialPageRoute(builder: (context) => createNewUserPage()));

     usersRef.doc(user.id).set({
       'cookies': 0,
       'id':user.id,
       'username':usernameAndLanguages['username'],
       'photoUrl':user.photoUrl,
       'email': user.email,
       'displayName': user.displayName,
       'bio':'',
       'languages':usernameAndLanguages['languages'],
       'timestamp': timestamp,
     });
     doc = await usersRef.doc(user.id).get();
    }

    setState(() {
      currentUser = User.fromDocument(doc);
    });
    // 3) Get username from the create accounts page and use it to create
    // a new user document in users collection.
  }

  Widget _buildLoginPage() {
    return Scaffold(
      body:Stack(
        children: [Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/ThemeDark.png'),
                fit: BoxFit.fill,)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(22)),
                  child: Image(image: AssetImage("assets/images/CodingInventoryLogo.png"),fit: BoxFit.contain,height:300)),
              GestureDetector(
                onTap: login,
                child: Container(
                    width: 260.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/google_sign_up.png'),
                          fit: BoxFit.cover),
                    )
                ),

              ),
              SizedBox(height:25),
            ],
          ),
        ),
          Container(
              width: 260.0,
              height: 60.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/logoBlackBG_preview_rev_1.png'),
                    fit: BoxFit.cover),
              )
          ),
        ],
      ),
    );
  }

  onPageChanged(int pageIndex){
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  navigationOnTap(int index){
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  Widget homeScreen(){

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        children: <Widget>[
          viewProfile(profileID: currentUser?.id),
          Timeline(currentUser : currentUser),
          createPost(currentUser : currentUser),
          search(),
          activityFeed(),
        ],
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.white,
        buttonBackgroundColor: Colors.grey[200],
        backgroundColor: Colors.white30,
        items: <Widget>[
          RadiantGradientMask(
            child: Icon(Icons.person,
                color: Colors.white,
                size: 25),
          ),
          RadiantGradientMask(
            child: Icon(Icons.list,
                color: Colors.white,
                size: 25),
          ),
          RadiantGradientMask(
            child: Icon(Icons.add,
                color: Colors.white,
                size: 35),
          ),
          RadiantGradientMask(
            child: Icon(Icons.search,
                color: Colors.white,
                size: 25),
          ),
          RadiantGradientMask(
            child: Icon(Icons.notifications_active,
                color: Colors.white,
                size: 25),
          ),
        ],
        onTap: (index) {
          //Handle button tap
          navigationOnTap(index);
        },
        height: 45,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? homeScreen() : _buildLoginPage();
  }
}
