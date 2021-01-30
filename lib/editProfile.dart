import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_inventory/googleLoginScreen.dart';
import 'package:flutter/material.dart';

import 'createNewUserPage.dart';
import 'models/user.dart';

class editProfile extends StatefulWidget {
  final String currentUserID;

  editProfile({this.currentUserID});

  @override
  _editProfileState createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _bioValid = true;
  bool _userNameValid = true;


  TextEditingController usernameController = TextEditingController();
  TextEditingController userBioController = TextEditingController();
  List alreadySelectedLanguages = [];
  List<ListItem<String>> languageList=[];

  bool isLoading = false;
  User user;

  @override
  void initState() {
    // TODO: implement initState

    getUser();

    super.initState();
  }

  Widget linearProgress(){
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.purple),
      ),
    );
  }

  getUser() async{
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await usersRef.doc(widget.currentUserID).get();
    user = User.fromDocument(doc);
    usernameController.text = user.username;
    userBioController.text = user.bio;
    alreadySelectedLanguages = user.languages;
    print(alreadySelectedLanguages);
    initializeLanguageList();
    setState(() {
      isLoading = false;
    });
  }

  Column buildUsernameField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:  EdgeInsets.only(top:12.0,bottom: 7.5),
          child: Text("Username",
          style: TextStyle(
            color: Colors.black
          ),)
        ),
        Container(
          height: 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                spreadRadius: 2,
              )
            ]
          ),
          child: TextField(
            controller:usernameController,
            decoration: InputDecoration(
              focusColor: Colors.amberAccent,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0)
            ),
          ),
        )
      ],
    );
  }

  Column buildBioField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding:  EdgeInsets.only(top:12.0,bottom: 5.0),
            child: Text("Bio",
              style: TextStyle(
                  color: Colors.black
              ),)
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 2,
                )
              ]
          ),
          child: TextField(
            controller:userBioController,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0)
            ),
          ),
        )
      ],
    );
  }

  initializeLanguageList(){
    print("Selected langs");
    print(alreadySelectedLanguages);
    List languages = ['python','c++','java','javascript','kotlin','ruby','swift'];
    for (int i = 0; i < languages.length; i++){
      ListItem item = ListItem<String>(language: languages[i],iconPath: 'assets/Icons/${languages[i]}.png');
    if(alreadySelectedLanguages.contains(languages[i])){
      item.isSelected = true;
    }
      languageList.add(item);
  };
}

  Widget _getListItem(BuildContext context, int index){
    return SizedBox(
      child: GestureDetector(
        onTap: (){
          setState(() {
            languageList[index].isSelected = !languageList[index].isSelected;
          });

        },
        child: Card(
          elevation: 20,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          color: languageList[index].isSelected ? Colors.blue[100] : Colors.white,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(
                image: AssetImage(languageList[index].iconPath),
                fit: BoxFit.contain,
                height: 64,
                width: 64,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _languageGridView(){
    return SizedBox(
      height: 210,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:25.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32.0),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.5,
            crossAxisCount: 3,
            children:<Widget>[
              for(int i =0; i<languageList.length;i++) _getListItem(context, i)
            ] ,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    userBioController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  updateProfileData(){
    print("Update button tapped");
    List<String> newSelectedLanguages = [];
    for(int i = 0 ; i<languageList.length; i++){
      if(languageList[i].isSelected)
        newSelectedLanguages.add(languageList[i].language);
    };
    print(newSelectedLanguages);

    print("${usernameController.text}");
    print("${userBioController.text}");

    setState(() {
      usernameController.text.trim().length<3||
      usernameController.text.isEmpty? _userNameValid = false : _userNameValid = true;

      userBioController.text.trim().length>80 ||
          userBioController.text.isNotEmpty? _bioValid = false : _bioValid = true;
    });
    print(_userNameValid);
    print(_bioValid);
    if(_userNameValid && _bioValid){
      usersRef.doc(widget.currentUserID).update({
        'languages': newSelectedLanguages,
        'username': usernameController.text.trim(),
        'bio': userBioController.text.trim(),
      });
      print("User and bio valid");
      SnackBar snackbar = SnackBar(backgroundColor: Colors.black,content: Text("Profile updated! Changes will be reflected when you refresh."));
      _scaffoldKey.currentState.showSnackBar(snackbar);
      Timer(Duration(seconds: 3), () {
       Navigator.pop(context);
      });
    }
    else if(usernameController.text.trim().length<3){
      SnackBar snackbar = SnackBar(content: Text("Username too short"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
    else if(userBioController.text.trim().length>80 || userBioController.text.trim().isEmpty){
      SnackBar snackbar = SnackBar(content: Text("Bio should be less than 80 words"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text('Edit Profile',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),),
      ),
      body: isLoading?linearProgress(): ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top:16.0, bottom:8.0),
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                  )
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      buildUsernameField(),
                      SizedBox(height: 7.0,),
                      buildBioField(),
                      SizedBox(height: 10.0,),
                      _languageGridView(),
                      RaisedButton(
                        color: Colors.white,
                        onPressed: updateProfileData,
                      child: Text(
                        "Update Profile",
                        style: TextStyle(
                          color: Colors.redAccent,
                        ),
                      ),)
                    ],
                  )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
