import 'package:board_app/ui/custom_card.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BoardApp extends StatefulWidget {
  @override
  _BoardAppState createState() => _BoardAppState();
}

class _BoardAppState extends State<BoardApp> {
  var firestoredb=FirebaseFirestore.instance.collection("board").snapshots();
TextEditingController nameInputController;
  TextEditingController titleInputController;
  TextEditingController descriptionInputController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameInputController=TextEditingController();
    titleInputController=TextEditingController();
    descriptionInputController=TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Community Board"),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
_showDialog(context);
      },
      child: Icon(CupertinoIcons.pen),
      ),
      body: StreamBuilder(

          stream: firestoredb,
          builder: (context,snapshot){
        if(!snapshot.hasData)
          return CircularProgressIndicator();

          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context,int index){
                return CustomCard(snapshot:snapshot.data,index:index);
           /* return Text(snapshot.data.documents[index].get('description'));*/
          });
      }),
    );
  }

  _showDialog(BuildContext context) async{
    await showDialog(context:context,
        child:AlertDialog(
          contentPadding: EdgeInsets.all(10),
          content: Column(
            children: <Widget>[
              Text("please fill out the form"),
              Expanded(child: TextField(
                autofocus: true,
                autocorrect: true,
                decoration: InputDecoration(
                  labelText: "Your Name"
                ),
                controller: nameInputController,
              )),
              Expanded(child: TextField(
                autofocus: true,
                autocorrect: true,
                decoration: InputDecoration(
                    labelText: "Title"
                ),
                controller: titleInputController,
              )),
              Expanded(child: TextField(
                autofocus: true,
                autocorrect: true,
                decoration: InputDecoration(
                    labelText: "Description"
                ),
                controller: descriptionInputController,
              )),
            ],
          ),
          actions: <Widget>[
            FlatButton(onPressed: (){
              nameInputController.clear();
              titleInputController.clear();
              descriptionInputController.clear();

              Navigator.pop(context);
            }, child:Text("cancel")),

            FlatButton(onPressed: (){
if(titleInputController.text.isNotEmpty &&
nameInputController.text.isNotEmpty && descriptionInputController.text.isNotEmpty){
  FirebaseFirestore.instance.collection("board")
      .add({
    "name":nameInputController.text,
    "title":titleInputController.text,
    "description":descriptionInputController.text,
    "timestamp":new DateTime.now()
  }).then((response){
    print(response.id);
    Navigator.pop(context);
    nameInputController.clear();
    titleInputController.clear();
    descriptionInputController.clear();
  }).catchError((error)=>print("error")
  );
}


            }, child:Text("save"))
          ],


        ));
  }
}
