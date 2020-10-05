import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class CustomCard extends StatelessWidget {
  final QuerySnapshot snapshot;
  final int index;

  const CustomCard({Key key, this.snapshot, this.index}) : super(key: key);


  @override
  Widget build(BuildContext context) {
   

    var snapshotData = snapshot.docs[index];
    var docuid=snapshot.docs[index].id;


    TextEditingController nameInputController=TextEditingController(
        text: snapshotData.get('name'));
    TextEditingController titleInputController=TextEditingController(
      text: snapshotData.get('title')
    );
    TextEditingController descriptionInputController=TextEditingController(
      text: snapshotData.get('description')
    );
    
    var timetoDate =new DateTime.fromMillisecondsSinceEpoch(
        (snapshotData.get('timestamp').seconds) * 1000);
    var dateFormatted=new DateFormat("EEE,MM,d,y").format(timetoDate);
    return Column(
      children: <Widget>[
        
       Container(
         height: 190,
         child: Column(
           children: <Widget>[
             Card(
               elevation: 9,
               child: Column(
                 children: <Widget>[
                   ListTile(
                     title: Text(snapshotData.get("title")),
                     subtitle: Text(snapshotData.get("description")),
                     leading: CircleAvatar(
                       radius: 34,
                       child:Text(snapshotData.get('description').toString()[0]) ,
                     ),


                   ),

                   Padding(
                     padding: const EdgeInsets.all(10.0),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.end,
                       children: <Widget>[
                         Text("By: ${snapshotData.get('name')}"),
                         Text(dateFormatted ==null ? " " :
                           dateFormatted),
                       ],
                     ),
                   ),


                   Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: <Widget>[
                       IconButton(icon: Icon(Icons.mode_edit,size: 15,),
                           onPressed:() async{
                         await showDialog(context: context,
                         child: AlertDialog(
                           contentPadding: EdgeInsets.all(10),
                           content: Column(
                             children: <Widget>[
                               Text("please to update this form"),
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
                                FirebaseFirestore.instance.collection("board").doc(docuid).update({
                                  "name":nameInputController.text,
                                  "title":titleInputController.text,
                                  "description":descriptionInputController.text,
                                  "timestamp":new DateTime.now()
                                }).then((response){
                                  Navigator.pop(context);
                                });

                                /* FirebaseFirestore.instance.collection("board")
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
                                 );*/
                               }


                             }, child:Text("update"))
                           ],
                         )
                         );

                       }),
                       SizedBox(height: 19,),
                       IconButton(icon: Icon(Icons.delete_outline,size: 15,),
                           onPressed:() async {
                         var collectionReference = FirebaseFirestore.instance.collection("board");
                         await collectionReference.doc(docuid).delete();



                      //print(docuid);
                       })
                     ],
                   )
                 ],
               ),

             ),
           ],

         ),

       ),

        // Text(snapshot.docs[index].get('description'))
      ],
    );
  }
}
