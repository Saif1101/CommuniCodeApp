import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_inventory/viewProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'googleLoginScreen.dart';



class search extends StatefulWidget {
  @override
  _searchState createState() => _searchState();
}

 // To control/clear the search bar





class _searchState extends State<search> {
  TextEditingController searchController = TextEditingController(); // To control/clear the search bar

  Future<QuerySnapshot> searchResultsFuture;
//  List<UserResult> searchResults = [];//Store and update the search results by using the setState function from inside the handleSearch function


  handleSearch(String query){
   Future<QuerySnapshot> users = usersRef.where("displayName", isGreaterThanOrEqualTo: query).get();
   setState(() {
     searchResultsFuture = users;
   });

  }


  clearSearch(){ //Clearing the search bar to allow user to change/edit entry
    searchController.clear();

  }

  buildSearchResults(){               ///Using a future builder to access
    ///the search results that are stored in the future
    ///takes two parameters: context and the user snapshots
    return FutureBuilder(                                                              ///ISSUE: Circular progress indicator doesn't stop when there are no results or when the field
      future: searchResultsFuture,                                                       /// or when the field is empty
        builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(child:CircularProgressIndicator(),);
        }
        List<UserResult> searchResults = [];
        snapshot.data.docs.forEach((doc){
          User user = User.fromDocument(doc);
          UserResult searchResult = UserResult(user);
          searchResults.add(searchResult);
        });
        return ListView(
          children: searchResults,
        );
        },
    );
  }



  AppBar buildSearchField(){
    return  AppBar(
      flexibleSpace: Image(image: AssetImage('assets/images/ThemeDark.png'),
          fit: BoxFit.cover),
      backgroundColor: Colors.white,
      title: Container(
        decoration: BoxDecoration(
          color: Color(0xFFffffff),
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            controller: searchController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(20),
              hintText: 'Search for other users..',
              filled: true,
              prefixIcon: Icon(
                Icons.account_box,
                size: 28.0,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () => clearSearch(),
              )
            ),
                onFieldSubmitted: handleSearch, // passes in the typed query to the function handleSearch
          ),
        ),
      )
    );
  }

  buildBodyWallpaper(){
    return Stack(
      children: [
        Positioned.fill(
            child: Image(
              image: AssetImage('assets/images/grayBG.png'),
              fit : BoxFit.fill,
            )
        ),
        Container(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Divider(color: Colors.black,thickness: 3.0,),
//                Container(
//                  decoration: BoxDecoration(
//                      image: DecorationImage(
//                          image: AssetImage('assets/images/noPostsToShow.png')
//                      )
//                  ),
//                ),
                          Align(
                            alignment: Alignment(1,1),
                            child: Text("Search",
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.black,
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment(1,1),
                            child: Text("For",
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.black,

                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment(1,1),
                            child: Text("Users",
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.black,

                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Divider(color: Colors.black,thickness: 3.0,),
                          SizedBox(height: 50,),


                        ],
                      ),
                    ),
                  ),
            ),
      ],
    );
  }


  @override
  Widget build(BuildContext Context) {
    return Scaffold(
      appBar: buildSearchField(),
      body: searchResultsFuture == null ? buildBodyWallpaper() : Stack(
        children:[
          buildBodyWallpaper(),
          buildSearchResults()
        ],
      ),
    );
  }
}


///USER RESULT WIDGET
class UserResult extends StatelessWidget {
  final User user;

  UserResult(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      color : Colors.white.withOpacity(0.8),
      child: Column(
        children: <Widget>[
          SizedBox(height:12.0),
          GestureDetector(
            onTap:  () => redirectToProfile(context, profileID: user.id),
            child:  Card(
              elevation: 10,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.lightBlueAccent,
                  backgroundImage: CachedNetworkImageProvider(user.photoUrl), //Using a cached network image provider so that
                  ///we can temporarily cache the image/store it within a cache folder for later use so that we don't
                  ///have to load it every time
                ),
                title: Text(
                    user.displayName,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    )
                ),
                subtitle: Text(
                  user.username,
                  style: TextStyle(
                    color: Colors.black38,
                  ),
                ),
              ),
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.lightBlueAccent,
          ),
          SizedBox(height: 10.0,)
        ],
      ),
    );
  }
}

redirectToProfile(BuildContext context, {String profileID}){
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => viewProfile(
          profileID: profileID
      )
    )
  );
}

