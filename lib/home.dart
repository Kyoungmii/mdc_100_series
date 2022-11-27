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
// limitations under the License.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shrine/profile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shrine/wishlist.dart';


import 'add.dart';
import 'detail.dart';
import 'model/product.dart';
import 'model/products_repository.dart';

List<String> name2 = ['necklace1', 'ring1', 'BeigeBag', 'PinkBag', 'CloverNecklace', 'bracelet'];
List<String> price = ['18 dollars', '22 dollars', '100 dollars', '200 dollars', '300 dollars', '250 dollars'];
//final storageRef = FirebaseStorage.instance.ref();
//final imageRef = storageRef.child("product_image/0-0.jpg");
List<String> urls = ['https://firebasestorage.googleapis.com/v0/b/final-53451.appspot.com/o/product_image%2F1.jpeg?alt=media&token=8f26f97c-7c9b-4807-ba6f-7652a0b49de3',
  'https://firebasestorage.googleapis.com/v0/b/final-53451.appspot.com/o/product_image%2F2.jpeg?alt=media&token=d38fb131-badd-4f03-b017-31a99298b4b5',
  'https://firebasestorage.googleapis.com/v0/b/final-53451.appspot.com/o/product_image%2F3.jpeg?alt=media&token=e83a6d67-c196-4f8d-a2c2-dbee6ac35c23',
  'https://firebasestorage.googleapis.com/v0/b/final-53451.appspot.com/o/product_image%2F4.jpeg?alt=media&token=37587e3d-facd-4343-bb42-cac173db1d5f',
  'https://firebasestorage.googleapis.com/v0/b/final-53451.appspot.com/o/product_image%2F5.jpeg?alt=media&token=66bd163e-859d-4afa-80a4-eb0a36f65897',
  'https://firebasestorage.googleapis.com/v0/b/final-53451.appspot.com/o/product_image%2F6.jpeg?alt=media&token=4fbb5254-7135-46d5-a795-752c8d729f9f'];
List<String> drop = <String>['ASC', 'DESC'];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  Future getImage() async {
    final storageRef = FirebaseStorage.instance.ref().child("product_image");
    final listResult = await storageRef.listAll();
    //for (var prefix in listResult.prefixes) {
    // The prefixes under storageRef.
    // You can call listAll() recursively on them.
    // }

    for (var item in listResult.items) {
      String url = await item.getDownloadURL();
      // The items under storageRef.
    }
  }

  CollectionReference get messages => FirebaseFirestore.instance.collection('product');

  Future<void> _addMessage() async {
    await messages.add(<String, dynamic>{
      'created_at': FieldValue.serverTimestamp(),
      //'updated_at': FieldValue.serverTimestamp(),
    });
  }

  List<Card> _buildGridCards(int count) {
    List<Card> cards = List.generate(
        count,
            (int index) {
          return Card(
        clipBehavior: Clip.antiAlias,
        // TODO: Adjust card heights (103)
        child: Column(
          // TODO: Center items on the card (103)
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 11,
              child: Image.network(
                urls[index],
                fit: BoxFit.fitWidth,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  // TODO: Align labels to the bottom and center (103)
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // TODO: Change innermost Column (103)
                  children: <Widget>[
                    // TODO: Handle overflowing labels (103)
                    Text(
                      name2[index],
                      style: TextStyle(fontSize: 15),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      price[index],
                      style: TextStyle(fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: () {Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DetailPage(urls[index], name2[index], price[index])),
                          );
                        _addMessage();
                        FirebaseFirestore.instance.collection('product').doc(name2[index]).update({'created_at': FieldValue.serverTimestamp()});
                      FirebaseFirestore.instance.collection('product').doc(name2[index]).update({'updated_at': FieldValue.serverTimestamp()});
                      },
                      child: Text('more', style: TextStyle(fontSize: 10)),),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
    );
    return cards;
  }

  // TODO: Add a variable for Category (104)
  @override
  Widget build(BuildContext context) {
    // TODO: Return an AsymmetricView (104)
    // TODO: Pass Category variable to AsymmetricView (104)
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.person,
            semanticLabel: 'profile',
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return ProfilePage();
                },
              ),
            );
          },
        ),
        title: const Text('Main'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              semanticLabel: 'modify',
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return WishlistPage();
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.add,
              semanticLabel: 'add',
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return AddPage();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body:
    Column(
      children: [
        DropdownButtonExample(),
      Expanded(
      child:
      GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        childAspectRatio: 8.0 / 9.0,
        children: _buildGridCards(price.length),
      ),

    ),

    ],
    ),
      resizeToAvoidBottomInset: false,
    );
  }
}
class DropdownButtonExample extends StatefulWidget {


  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = drop.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: drop.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}