



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';


class postTemplate extends StatelessWidget {
  List <String> tags = ['tag1','tag2','tag3','tag4','tag5','tag6','tag7','tag8'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 350,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 50,
                child: ListTile(
                  title: Text("Title of the post goes here!"),
                  trailing: GestureDetector(
                    onTap: ()=> print("Read More Pressed!"),
                    child: RadiantGradientMask(child: Icon(Icons.arrow_forward,size: 35,color: Colors.white,),),
                  ),
                ),
              ),
              Divider(thickness: 1.5,),
              Expanded(child: Container(decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.vertical(top:Radius.circular(34),bottom:Radius.circular(34),)
              ),child: Image(image: AssetImage('assets/images/modelPostBig.png'),fit: BoxFit.contain, height: 300,)))
            ],
          ),
        ),
      ),
    );
  }
}

class RadiantGradientMask extends StatelessWidget {
  RadiantGradientMask({this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.centerLeft,
        colors: [Colors.lightBlueAccent, Colors.deepPurpleAccent],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}

class postExpanded extends StatefulWidget {
  final String title = 'Hello First Post Title';
  final String description ='"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';
  final List <String> tags;
  final List<String> urlList;
  final List<String> ownerID;
  final String postImageUrl;

  postExpanded({this.tags, this. urlList, this.postImageUrl, this.ownerID});

  @override
  _postExpandedState createState() => _postExpandedState();
}

class _postExpandedState extends State<postExpanded> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(  //
              child: Image(
                image: AssetImage('assets/images/grayBG.png'),
                fit : BoxFit.fill,
              )),
          SafeArea(
            bottom: false,
            child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.vertical(top:Radius.circular(34),bottom:Radius.circular(34),)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 250,),
                          Text(
                            widget.title, style: TextStyle(
                            fontFamily:'Avenir',
                            fontSize: 31,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w900,),
                            textAlign: TextAlign.left,
                          ),
                          Divider(color: Colors.black38),
                          Text(widget.description,
                            softWrap: true,

                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Divider(color: Colors.black38),

                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                    onDoubleTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>expandPhoto(imageUrl: widget.postImageUrl,title: widget.title,))),
                    child: Hero(tag:'image',child: Image.asset('assets/images/modelPostBig.png'),)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class expandPhoto extends StatelessWidget {
  final String title;
  final String imageUrl;
  expandPhoto({this.imageUrl, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title),),
      backgroundColor: Colors.grey,
      body: Container(
        child: Center(
          child: Hero(
            tag: 'image',
            child: PhotoView(
              imageProvider: NetworkImage(imageUrl),
            ),
          ),

        ),
      ),
    );
  }
}