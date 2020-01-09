import 'dart:ffi';
//import 'dart:html';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newappupdate/imge_front.dart';

class LandingScreen extends StatefulWidget {
  LandingScreen({Key key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {

  File imageFile;
  var picture;
  String getText;
  
  _openGallary(BuildContext context) async{

    picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
    
 }

  _openCamera(BuildContext context) async{
    
    picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  upload() async{
    String filename = picture.path;
    print(filename);
    try{
      FormData formData = new FormData.from({'ytgy': new UploadFileInfo(picture, filename)});
      var response = await Dio().post('',data: formData);
      print(response.data);

      var state = response.data;
      getText = state;
      setState(() {
        getText = state;
      });
    }catch(err){
      print(err.message);
    }
  }

  Future<Void> _showChoicesDialog(BuildContext context){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Make a Choice"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text("Gallary"),
                onTap: () {
                  _openGallary(context);
                },
              ),
              Padding(padding: EdgeInsets.all(8.0),),
              GestureDetector(
                child: Text("Camera"),
                onTap: () {
                  _openCamera(context);
                },
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _decideImageView(){
    if(imageFile == null){
      return Text("No Image Selected");
    }else{
      return Image.file(imageFile, width: 400,height: 400); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Screen"),
      ),
      body: Builder(
        builder: (BuildContext context)=> Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _decideImageView(),
                new Padding(
                  padding: new EdgeInsets.only(bottom: 20)
                ),

                SizedBox(
                  width: 300,
                  height: 40,
                   child: RaisedButton.icon(
                      icon: Icon(Icons.camera),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      elevation: 10,
                      highlightElevation: 10,
                      color: Colors.blue,
                      textColor: Colors.white, 
                      onPressed: (){
                        _showChoicesDialog(context);
                            }, 
                      label: Text("Select Image"),
                      /*padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 100.0,
                      ),*/
                    ),
                ),
                new Padding(
                  padding: new EdgeInsets.only(bottom: 12)
                ),

                SizedBox(
                  width: 300,
                  height: 40,
                  child: RaisedButton.icon(
                      icon: Icon(Icons.select_all),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      elevation: 10,
                      highlightElevation: 10,
                      color: Colors.blue,
                      textColor: Colors.white, 
                      onPressed: (){
                        if(imageFile == null){
                          SnackBar snackbar = SnackBar(content: Text('Not Select Image, Select the image'),);
                          Scaffold.of(context).showSnackBar(snackbar);
                        }else{
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => Update()));
                          upload();
                        }
                            }, 
                      label: Text("Change"),
                      /*padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 120.0,
                      ),*/
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}