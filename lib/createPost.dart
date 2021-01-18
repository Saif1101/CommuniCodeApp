import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'dart:io';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

////Pages
import 'models/user.dart';
import 'googleLoginScreen.dart';





class createPost extends StatefulWidget {
  final User currentUser;

  createPost({this.currentUser});
  @override
  _createPostState createState() => _createPostState();
}

class _createPostState extends State<createPost> {
  TextEditingController _titleController = TextEditingController(); //Controller for post title field
  TextEditingController _descController = TextEditingController();  //Controller for post description field


  String postID = Uuid().v4(); //Generating a unique postID

  String postTitle =null , desc = null; //Store the title and the description of the post

////////////////////////////////////////////////////////////// Handling submission of image from the user

  File selectedImage = null; ////STORING THE IMAGE FILE

  Future getImage() async {
    var picker = ImagePicker();
    var image = await picker.getImage(source:ImageSource.gallery);

    setState(() {
      selectedImage = File(image.path);
    });
  }

 //Compressing the selected image
  compressImage() async{
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(selectedImage.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postID.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile,quality:85));
  }
  //////////////////////////////////////////////////////////////////////////////////////////////HANDLING UPLOAD///////////////////////////////////////////////////////

  bool isUploading = false;////HANDLING THE UPLOADING TICKER

  stringColourIfReady(){
    if(selectedImage!=null && postTitle.isNotEmpty && desc.isNotEmpty)
      return ("#d13328");
  } ////To change the colour of the tick from red to green


  Future <String> uploadImage (imageFile) async {
    Reference uploadTask =  firebaseStorageRef.child("post_$postID.jpg");
    await uploadTask.putFile(imageFile);
    String downloadUrl = await uploadTask.getDownloadURL();
    return downloadUrl;

  }

  createPostInFirestore({String mediaUrl, String title, String description, List <String> tagsList, List<String> urls}){
    postsRef.doc(widget.currentUser.id).collection('userPosts').doc(postID).set({
      'postStatus'  : 'Open',
      'cookiesToAward': 2,
      'postTitle': title,
      'postID': postID,
      'ownerID': widget.currentUser.id,
      'username': widget.currentUser.username,
      'imageUrl': mediaUrl,
      "description": description,
      'tags': tagsList,
      'siteLinks': urls,
      'timestamp': timestamp,
      'likes':{},
    });
    setState(() {
      selectedImage = null;
      dynamicList = [];
      postTitle = null;
      desc = null;
      formInfo =[];
      isUploading = false;
      _titleController.clear();
      _descController.clear();
    });

  }


  handleSubmit() async{
    if(selectedImage!= null && postTitle!=null && desc!= null){
      setState(() {
        isUploading=true;
      });
      await compressImage();
      String mediaUrl = await uploadImage(selectedImage);
      createPostInFirestore(
        mediaUrl: mediaUrl,
          title: postTitle,
          description: desc,
          tagsList: tags,
          urls: formInfo);
      Alert(
        context: context,
        type: AlertType.info,
        title: "",
        desc: "Post Uploaded",
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }else{
      Alert(
        context: context,
        type: AlertType.info,
        title: "",
        desc: "Invalid Image/Title/Description",
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }
  }



////////////////////////////////////////////////////////////////////DYNAMIC LIST FOR LINKS///////////////////////////////////////////////////////

  List <String> formInfo= []; //Has all the data entered through the link rows in the form of ["WebsiteName","URL"]

  List<linkIconBoxField> dynamicList = []; //List of all linkIconBox Widgets, Used for storing widgets on addition and deletion.

  int index = 0;


  addForm(){
    setState((){
      dynamicList.add(new linkIconBoxField(index : index,parent: this));
      formInfo.insert(index, '');
      formInfo.insert(index+1, '');
      index = index+2;
    });
  }



  removeForm(){
    setState((){
     dynamicList.removeLast();
     formInfo.removeLast();
     formInfo.removeLast();
     index=index-2;
    });
  }
  ////////////////////////////////////////////////////////////////// Add Button Which Adds A Link Row To The Screen /////////////////////////////////////////////////////////////

  Widget _addLinkButtonRow(){
    return Row(children: <Widget>[
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only( right: 20.0),
            child: Divider(
              color: Colors.black,
              height: 36,
            )),
      ),
      FlatButton(
        shape: RoundedRectangleBorder(side: BorderSide(
            color: Colors.blue,
            width: 1,
            style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(50)),
        onPressed: addForm,
        child: Row(
          children: [
            Icon(Icons.add),
            Text("Add Links",
              style: TextStyle(fontWeight: FontWeight.bold),),
          ],
        ),
      ),
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 20.0),
            child: Divider(
              color: Colors.black,
              height: 36,
            )),
      ),
    ]);
  }

  ////////////////////////////////////////////////////// TAGS WIDGET ////////////////////////////////////////////////////////////////////////////////

  List <String> tags=[];        //List containing all the inputted tags

  Widget tagsWidget() {
    return TextFieldTags(
      initialTags: [],
        tagsStyler: TagsStyler(
            tagTextStyle: TextStyle(fontWeight: FontWeight.bold),
            tagDecoration: BoxDecoration(color: Colors.blue[300],
              borderRadius: BorderRadius.circular(8.0),),
            tagCancelIcon: Icon(
                Icons.cancel, size: 18.0, color: Colors.blue[900]),
            tagPadding: const EdgeInsets.all(5.0)
        ),
        textFieldStyler: TextFieldStyler(),
        onTag: (tag) {setState(() {
          tags.add(tag);
        });},
        onDelete: (tag) {setState(() {
          tags.remove(tag);
        });}
    );
  }


  /////////////////////////////////////////////////Circular Progress Indicator That Shows Up On The AppBar///////////////////////////////////////////////

  Widget circularProgressAppBar(){
    return Container(
      padding: EdgeInsets.symmetric(vertical:14.0),
      height: 1.0,
      width: 33.0,
      child: CircularProgressIndicator(valueColor:  AlwaysStoppedAnimation<Color>(Color(0xFFf1b900))),
    );
  }

  Widget uploadGestureDetector(){
    setState(() {
    });
    return GestureDetector(
      onTap: isUploading? null:()=>handleSubmit(),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Icon(Icons.file_upload,
              size: 35.0,
              color: Colors.white
      ),
    ));
  }


//////////////////////////////////////////////////////////////////Building the screen////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          flexibleSpace: Image(image: AssetImage('assets/images/ThemeDark.png'),
              fit: BoxFit.cover),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ///ADD PHOTO LOGO,
              ///

            ],
          ),
          backgroundColor:  Colors.black54,
          elevation: 0.0,
          actions: <Widget>[
            isUploading?circularProgressAppBar():uploadGestureDetector()
          ]
      ),
      body:SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 5,),
            GestureDetector(
              onTap: (){
                getImage();
              },
              child: selectedImage != null ? Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius:  BorderRadius.circular(6.0),
                  child: Image.file(
                      selectedImage
                  ),
                ),

              ) :
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(50),
                ),
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Add A Snippet Of Your Code!"),
                    Icon(
                      Icons.add_a_photo,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height:8.0),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child:
                Column(
                  children:<Widget> [
                    TextField(
                      maxLength: 50,
                      controller: _titleController,
                      onChanged: (val){
                        setState(() {postTitle=val;});

                      },
                      decoration:  InputDecoration(
                          hintText: "Title"
                      ),
                    ),
                    TextField(
                      maxLines: null,
                      maxLength: 150,
                      keyboardType: TextInputType.multiline,
                      controller: _descController,
                      onChanged: (val)=>desc=val,
                      decoration:  InputDecoration(
                          hintText: "Description "
                      ),
                    ),
                    tagsWidget(),
                    _addLinkButtonRow(),
                    SingleChildScrollView(child: Column(children:dynamicList)),
                    dynamicList.isNotEmpty?IconButton(icon: Icon(Icons.clear),onPressed: removeForm,):SizedBox(height: 3.0,)
                  ],
                )
            ),
          ],
        ),
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed:()=> print(tags),
//      ),

    );
  }
}



////////////////////////////////// List of small boxes which facilitates input of links

class linkIconBoxField extends StatefulWidget {
  _createPostState parent;
  int index;
  linkIconBoxField({this.index,this.parent});

  @override
  _linkIconBoxFieldState createState() => _linkIconBoxFieldState();

}

class _linkIconBoxFieldState extends State<linkIconBoxField> {
  final formKey = GlobalKey<FormState>();
  //DATA MEMBERS CONTAINING INFO ABOUT EACH ROW CREATED, The type and the image next to the type are already initiated with default values -'Select' and "White Image"
  String selectedType='Select';
  String url;
  Image selectedIcon=Image(
      image: new AssetImage("assets/Icons/plainWhite.jpg"),
      width: 2,
      height: 34,
      color: null,
      fit: BoxFit.scaleDown,
      alignment: Alignment.center);

  //MAP CONTAINING THE NAME AND IMAGE OF EACH WEBSITE
  final Map<String, Image> _data = Map.fromIterables(
      ['Github', 'Hackerrank','CodeChef','Codeforces',"Browser"],
      [ Image(
        image: new AssetImage("assets/Icons/Github.png"),
        width: 34,
        height: 34,
        color: null,
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
      ),Image(
        image: AssetImage('assets/Icons/Hackerrank.png'),
        width: 34,
        height:34,
        color: null,
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
      ),
        Image(
          image: AssetImage('assets/Icons/CodeChef.png'),
          width: 34,
          height:34,
          color: null,
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
        ),
        Image(
          image: AssetImage('assets/Icons/Codeforces.png'),
          width: 34,
          height:34,
          color: null,
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
        ),
        Image(
          image: AssetImage('assets/Icons/Browser.png'),
          width: 34,
          height:34,
          color: null,
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
        ),]);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: 1,
                child: SizedBox(
                  height: 30.0,
                  width: 30.0,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 2.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                          items: _data.keys.map((String val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                                    child: _data[val],
                                  ),
                                  Text(val),
                                ],
                              ),
                            );
                          }).toList(),
                          hint: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                child:
                                selectedIcon ?? _data.values.toList()[0],
                              ),
                              Text(selectedType ?? _data.keys.toList()[0]),
                            ],
                          ),
                          onChanged: (String val) {
                            setState(() {
                              selectedType = val;
                              selectedIcon = _data[val];
                            });
                          }),
                    ),
                  ),
                )),
            (selectedType!=null && selectedType != 'Select')? Expanded(
              flex: 1,
              child: TextFormField(
                key: formKey,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (value){

                    if(value.isEmpty || !value.contains('@') || selectedType == 'Select' || selectedType == null){
                      return "Invalid";
                    };
                    return 'Done';
                  },
                  onChanged: (value){
                    setState(() {
                      if(!(value.isEmpty || !value.contains('@') || selectedType == 'Select' || selectedType == null)){
                        url = value;
                      }
                      else{
                        return;
                      }
                    });
                    print(url);
                      widget.parent.setState(() {
                        widget.parent.formInfo[widget.index]=(selectedType);
                        widget.parent.formInfo[widget.index+1]=(url);
                      });
                    },
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5.0),
                  )
              ),
            ):Expanded(flex:1,child: Text("Use the dropdown"),),
          ],
        ),
        SizedBox(height: 15.0,)
      ],
    );
  }
}

