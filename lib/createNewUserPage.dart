
import 'package:flutter/material.dart';
import 'dart:async';


class createNewUserPage extends StatefulWidget {
  @override
  _createNewUserPageState createState() => _createNewUserPageState();
}

class _createNewUserPageState extends State<createNewUserPage> {
  final _formKey = GlobalKey <FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String username;
  String validationCheckString = "Enter Your Username";

  List<ListItem<String>> languageList;

  @override
  void initState(){
    super.initState();
    initializeLanguageList();
  }

  initializeLanguageList(){
    languageList = [];
    List <String> languages = ['python','c++','java','javascript','kotlin','ruby','swift'];
    for (int i = 0; i < languages.length; i++)
      languageList.add(ListItem<String>(language: languages[i],iconPath: 'assets/Icons/${languages[i]}.png'));
  }


  submitUsernameAndLanguages(){
    final form = _formKey.currentState;
    List<String> selectedLanguages = [];
     for(int i = 0 ; i<languageList.length; i++){
       if(languageList[i].isSelected)
         selectedLanguages.add(languageList[i].language);
     };

    if(form.validate()) { // go through all the validation steps once again
      form.save();
      final snackBar = SnackBar(content: Text("Welcome $username!"));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      Timer(Duration(seconds: 2), (){ /// Adding a 2 second delay before popping back to previous page
        Navigator.pop(context, {"username":username, "languages" : selectedLanguages});
      }
      );
      ///pop navigator to go back to the previous route
    }//Returning the username to the previous page
  }

  Widget _validationDivider(){
    return Row(
      children: [
        Expanded(
          child: Container(
              margin: const EdgeInsets.only( right: 10.0),
              child: Divider(
                color: Colors.white,
                height: 36,
              )
          ),
        ),
        Expanded(
          child:Center(
            child:
              Text(
              '$validationCheckString',
                style: TextStyle(
                  color: Colors.white,
                ),
        ),
          )
        ),
        Expanded(
          child: Container(
              margin: const EdgeInsets.only( left: 10.0),
              child: Divider(
                color: Colors.white,
                height: 36,
              )
          ),
        ),
      ]
    );
  }

  Widget _badgeDivider(){
    return Row(
        children: [
          Expanded(
            child: Container(
                margin: const EdgeInsets.only( right: 10.0),
                child: Divider(
                  color: Colors.white,
                  height: 36,
                )
            ),
          ),
          Expanded(
              child:Text(
                'What do you code in?',
                softWrap: false,
                style: TextStyle(
                  color: Colors.white,
                ),
              )
          ),
          Expanded(
            child: Container(
                margin: const EdgeInsets.only( left:10.0),
                child: Divider(
                  color: Colors.white,
                  height: 36,
                )
            ),
          ),
        ]
    );
  }

  Widget _usernameField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Container(
            alignment: Alignment.centerLeft,
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
            height: 60.0,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: TextFormField(

                  validator: (value){
                    if(value.trim().length<3 || value.isEmpty){
                      setState(() {
                        validationCheckString = "Username too short";
                      });
                    } else if (value.trim().length>12) {
                      setState(() {
                        validationCheckString = "Username too short";
                      });
                    }
                  },
                  onSaved: (value)=> username = value,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: 'Must be atleast 3 characters',
                    hintStyle: TextStyle(
                      color: Colors.black54
                    ),
                  ),
                ),
              ),
            )
        )
      ],
    );
  }

  Widget yellowUsernameIcon(){
    return Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.lightBlueAccent, Colors.deepPurpleAccent],
                begin: Alignment.bottomRight,
                end: Alignment.centerLeft),
          color: Color(0xFFf1b900),
          shape: BoxShape.rectangle,
          borderRadius:  new BorderRadius.all(Radius.circular(70.0)
          ),
        ),
        child:  Ink(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.lightBlueAccent, Colors.deepPurpleAccent],
                begin: Alignment.bottomRight,
                end: Alignment.centerLeft),
            borderRadius: BorderRadius.all(Radius.circular(80.0)),
          ),
          child: Container(
              constraints: const BoxConstraints(minWidth: 40.0, minHeight: 36.0), // min sizes for Material buttons
              alignment: Alignment.center,
              child: Text(
                  'Profile Setup',
                  style: TextStyle(
                    color: Colors.white,
                    shadows: [
                      Shadow( // bottomLeft
                          offset: Offset(-1.5, -1.5),
                          color: Colors.grey
                      ),
                      Shadow( // bottomRight
                          offset: Offset(1.5, -1.5),
                          color: Colors.black
                      ),
                      Shadow( // topRight
                          offset: Offset(1.5, 1.5),
                          color: Colors.black
                      ),
                      Shadow( // topLeft
                          offset: Offset(-1.5, 1.5),
                          color: Colors.grey
                      ),
                    ],

                    letterSpacing: 1.6,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                  )
              )
          ),
        )
    );
  }

  Widget _loginButton(){
    return Container(
        padding: EdgeInsets.symmetric(vertical:1.0),
        width: double.infinity,
        child: RaisedButton(
            elevation: 25.0,
            onPressed: ()=> submitUsernameAndLanguages(),
            padding: EdgeInsets.all(15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Ink(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.lightBlueAccent, Colors.deepPurpleAccent],
                    begin: Alignment.bottomRight,
                    end: Alignment.centerLeft),
                borderRadius: BorderRadius.all(Radius.circular(80.0)),
              ),
              child: Container(
                constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                alignment: Alignment.center,
                child: Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      shadows: [
                        Shadow( // bottomLeft
                            offset: Offset(-1.5, -1.5),
                            color: Colors.grey
                        ),
                        Shadow( // bottomRight
                            offset: Offset(1.5, -1.5),
                            color: Colors.black
                        ),
                        Shadow( // topRight
                            offset: Offset(1.5, 1.5),
                            color: Colors.black
                        ),
                        Shadow( // topLeft
                            offset: Offset(-1.5, 1.5),
                            color: Colors.grey
                        ),
                      ],

                      letterSpacing: 1.6,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    )
                )
              ),
            ),

        )
    );
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
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/ThemeDark.png'),
              fit: BoxFit.fill,)
    ),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFFFFF).withOpacity(0.3)
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 100.0),
                yellowUsernameIcon(),
                SizedBox(height: 10.0),
                _usernameField(),
                SizedBox(height: 10.0),
                _validationDivider(),
                SizedBox(height: 10.0),
                _languageGridView(),
                _badgeDivider(),
                SizedBox(height: 30.0),
                _loginButton(),

              ],

            ),
          ),
        ),
    )
    );
  }
}


class ListItem<T>{
  bool isSelected = false;
  T language;
  T iconPath;
  ListItem({this.language, this.iconPath});
}