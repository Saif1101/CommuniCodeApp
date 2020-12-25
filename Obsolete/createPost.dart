import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

Map linkMap = {'Github': [],'Hackerrank':[],'CodeChef': [], 'CodeChef':[], 'Browser':[]};
List <List<String>> lists = [];// Create a Map to w/ Keys = ['Github', 'Hackerrank','CodeChef','CodeForces',"Browser"], and Value = URL



class createPost extends StatefulWidget {
  @override
  _createPostState createState() => _createPostState();
}

class _createPostState extends State<createPost> {
  //////////////////////////////////////////////////
  String postID = Uuid().v4();


  String title, desc;
  var tags=[];


  File selectedImage; ////STORING THE IMAGE FILE

  //////////////////////COMPRESSING IMAGE///////////////////////////////////////////////////////
  compressImage() async{
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(selectedImage.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postID.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile,quality:85));
  }
  //////////////////////////////////////////////////////////////////////////////////////////////



  bool isUploading = false;  ////HANDLING THE UPLOADING TICKER


  uploadBlog() async{
    setState(() {
      isUploading=true;
    });
    if(selectedImage!= null){
      await compressImage();
     // await uploadImage(file);
      Reference firebaseStorageRef = FirebaseStorage.instance.ref();
    }
  }

  Future getImage() async {
    var picker = ImagePicker();
    var image = await picker.getImage(source:ImageSource.gallery);

    setState(() {
      selectedImage = File(image.path);
    });
  }
////////////////////////////////////////////////////////////////////DYNAMIC LIST FOR LINKS///////////////////////////////////////////////////////
  List<linkIconBoxField> dynamicList = []; //List of all used linkIconBoxField Widgets
  /* Three Attributes:
  String selectedType;
  String url;
  Image selectedIcon;*/

  Map linkMap = {'Github': '','Hackerrank':'','CodeChef': '', 'CodeChef':''};                        // Create a Map to w/ Keys = ['Github', 'Hackerrank','CodeChef','CodeForces',"Browser"], and Value = URL

  addDynamic(){
    setState(() {});
    if (dynamicList.length >= 4) {
      return;
    }
    dynamicList.add(new linkIconBoxField());
  }



  removeDynamic(){
    setState((){});
    dynamicList.isNotEmpty?dynamicList.removeLast():null;
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
        onPressed: ()=>addDynamic(),
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
  Widget tagsWidget() {
    return TextFieldTags(
        tagsStyler: TagsStyler(
            tagTextStyle: TextStyle(fontWeight: FontWeight.bold),
            tagDecoration: BoxDecoration(color: Colors.blue[300],
              borderRadius: BorderRadius.circular(8.0),),
            tagCancelIcon: Icon(
                Icons.cancel, size: 18.0, color: Colors.blue[900]),
            tagPadding: const EdgeInsets.all(6.0)
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
  printContents(){
    print(lists);
    }


  ////////////////////////////////////////////////////////////////////////////////      ///////////////////////////////////////////////////////////


  @override
  Widget build(BuildContext context) {



    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: printContents,
      ),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
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
          GestureDetector(
            onTap: isUploading? null: ()=> uploadBlog(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Icon(Icons.file_upload)
            ),
          )
        ]
      ),
      body:SingleChildScrollView(
        child: Column(
            children: <Widget>[
              isUploading==false?SizedBox(height:1.0,width:2.0):SizedBox(height:5.0, width: double.infinity,child: LinearProgressIndicator(valueColor:  AlwaysStoppedAnimation<Color>(Color(0xFFf1b900)),)),
              SizedBox(height: 10,),
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
                      decoration:  InputDecoration(
                          hintText: "Title"
                      ),
                    ),
                    TextField(
                      decoration:  InputDecoration(
                          hintText: "Description"
                      ),
                    ),
                    tagsWidget(),
                    _addLinkButtonRow(),
                    Column(children: dynamicList),
                    Center(
                        child: dynamicList.isNotEmpty?FlatButton.icon(onPressed: removeDynamic, icon: Icon(Icons.clear), label: Text("Clear")):Text('')
                        ),
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



////////////////////////////////// List of small boxes which faciliate input of links

class linkIconBoxField extends StatefulWidget {
  @override
  _linkIconBoxFieldState createState() => _linkIconBoxFieldState();

}

class _linkIconBoxFieldState extends State<linkIconBoxField> {
  //DATA MEMBERS CONTAINING INFO ABOUT EACH ROW CREATED
  String selectedType;
  String url;
  Image selectedIcon;

  //MAP CONTAINING THE NAME AND IMAGE OF EACH WEBSITE
  final Map<String, Image> _data = Map.fromIterables(
      ['Github', 'Hackerrank','CodeChef','CodeForces',"Browser"],
      [Image(
        image: new AssetImage("assets/Icons/github.png"),
        width: 34,
        height: 34,
        color: null,
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
      ),Image(
        image: AssetImage('assets/Icons/hackerrank.png'),
        width: 34,
        height:34,
        color: null,
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
      ),
        Image(
          image: AssetImage('assets/Icons/codechef.jpg'),
          width: 34,
          height:34,
          color: null,
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
        ),
        Image(
          image: AssetImage('assets/Icons/codeforces.png'),
          width: 34,
          height:34,
          color: null,
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
        ),
        Image(
          image: AssetImage('assets/Icons/browser.jpg'),
          width: 34,
          height:34,
          color: null,
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
        ),]);

  @override
  Widget build(BuildContext context) {
    return Row(
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
        Expanded(
          flex: 1,
            child: TextFormField(
              autovalidate: true,
              validator: (value){
                if(value.isEmpty){
                  return "Enter A Valid URL";
                };
                return "Done!";
              },
              onSaved: (val){
                setState(() {
                  url = val;
                  lists.add([selectedType,url]);
                });

              },
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5.0),
            )
            ),
          ),
      ],
    );
  }
}


