// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the Licens
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shrine/auth.dart';
import 'package:shrine/signin.dart';
import 'home.dart';
import 'login.dart';
import 'add.dart';
import 'package:flushbar/flushbar.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';


List<String> name3 = [];

class DetailPage extends StatefulWidget {
  final String url1;
  final String name1;
  final String price1;

  const DetailPage(this.url1, this.name1, this.price1);

  @override
  _DetailPageState createState() => _DetailPageState();
}


class _DetailPageState extends State<DetailPage> {

  CollectionReference _reference = FirebaseFirestore.instance.collection('product');
  int fabIconNumber =0;
  Icon fab = Icon(Icons.shopping_cart);

  Future<void> deleteImage(String imageFileUrl) async {
    var fileUrl = Uri.decodeFull(Path.basename(imageFileUrl)).replaceAll(new RegExp(r'(\?alt).*'), '');


    final Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child(fileUrl);
    await firebaseStorageRef.delete();

  }
  late String fileRef = widget.name1;
  late var userdocument = FirebaseFirestore.instance.collection('product').doc(fileRef);

  //late var setdateTime = userdocument.update({"timestamp": FieldValue.serverTimestamp()});
  //late DateTime dt = DateTime.parse(setdateTime as String);
  //late String formatted = ;
  //late String t = "$dt";
  //late final storageRef = FirebaseStorage.instance.ref().child("product_image").child(widget.name1);
  //late final time2 = FirebaseFirestore.instance.collection('product').doc(widget.name1).set({ "timestamp": FieldValue.serverTimestamp()});

  //late final stat = FileStat.statSync(fileRef);


String data1='';
  void updatedata() async{
    final usercol=FirebaseFirestore.instance.collection("product").doc(fileRef);
    await usercol.get().then((value) => {
      data1 = value['created_at'],
      //data2 = value['updated_at'],
      print(data1)
    });
  }
 // String? valueFromFirebase;
 // Future<String?> getData() async{
 //   var a = await FirebaseFirestore.instance.collection('product').doc(fileRef).get();
 //   setState(() {
 //     valueFromFirebase= a['created_at'];
 //   });
 // }





  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      height: 130, width: 100,
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.name1),
                Text(widget.price1),
              ],),
            //const FavoriteWidget(),
          ),
          const FavoriteWidget(),
        ],
      ),
    );
    // var purID;
    // Future<String?> getData() async{
    //   await FirebaseFirestore.instance
    //       .collection('product')
    //       .doc(fileRef)
    //       .get()
    //       .then((DocumentSnapshot documentSnapshot) async {
    //     if (documentSnapshot.exists) {
    //       var data = documentSnapshot.data();
    //       var res = data as Map<String, dynamic>;
    //       'created_at': purID;
    //     }
    //   });
    // }
    // final CollectionReference Collection1 = FirebaseFirestore.instance.collection('product');
    //
    // Future getdatatime(String status_message, String uid) async{
    //   return await Collection1.doc(fileRef).get({
    //     'status_message': status_message,
    //   } as GetOptions?);
    // }



    Widget textSection = Container(
      height: 150, width: 200,
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          Flexible(
            child:
            const Text(
              'The acc you wanted to have :) Get it today!',
              softWrap: true,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),),
          const SizedBox(height: 10.0),

          FloatingActionButton(
            child: fab,
            onPressed: () => setState((){
              if(fabIconNumber == 0){
                fabIconNumber++;
                fab = Icon(Icons.check);
              }

            }),
            backgroundColor: Colors.blueAccent,
          ),
        ],),

    );

    return MaterialApp(
      title: 'hotel detail',
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back_ios),
              onPressed: (){Navigator.pop(context);}),
          title: Text('Detail'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.create,
                semanticLabel: 'modify',
              ),
              onPressed: () {

              },
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                semanticLabel: 'delete',
              ),
              onPressed: () {
                deleteImage(widget.url1);

                name2.remove(widget.name1);
                price.remove(widget.price1);
                urls.remove(widget.url1);

                print(name2);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return HomePage();
                    },
                  ),
                );

              },
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Stack(
              children: [
                Hero(
                  tag: 'image',
                  child:
                    Image.network(widget.url1,
                      width: 700,
                      height: 240,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],),
            titleSection,
            const Divider(
              height: 1.0,
              endIndent: 0,
              color: Colors.blue,
            ),
            textSection,

          ],
        ),
      ),
    );
  }



}

class FavoriteWidget extends StatefulWidget {
  const FavoriteWidget();

  @override
  State<FavoriteWidget> createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  // #enddocregion _FavoriteWidgetState-build
  bool _isFavorited = true;
  int _favoriteCount = 0;

  SnackBar snackBar = SnackBar(
    content: Text('I Like It!'),
  );
  SnackBar snackBar1 = SnackBar(
    content: Text('You can only do it once!!'),
  );

  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _favoriteCount += 1;
        _isFavorited = false;
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        //_favoriteCount += 1;
        ScaffoldMessenger.of(context).showSnackBar(snackBar1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(0),
          child: IconButton(
            padding: const EdgeInsets.all(0),
            alignment: Alignment.centerRight,
            icon: (_isFavorited
                ? const Icon(Icons.thumb_up)
                : const Icon(Icons.thumb_up)),
            color: Colors.red[500],
            onPressed: _toggleFavorite,
          ),
        ),
        SizedBox(
          width: 18,
          child: SizedBox(
            child: Text('$_favoriteCount'),
          ),
        ),
      ],
    );
  }
// #docregion _FavoriteWidgetState-fields
}