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

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shrine/profile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'home.dart';

import 'model/product.dart';
import 'model/products_repository.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}


class _AddPageState extends State<AddPage> {

  final _productnameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();

  CollectionReference _reference = FirebaseFirestore.instance.collection('product');

  String imageUrl ='http://handong.edu/site/handong/res/img/logo.png';

  uploadImage() async{
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    print('${file?.path}');

    if(file==null) return;
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImage = referenceRoot.child('product_image');
    Reference referenceImageToUpload = referenceDirImage.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(File(file!.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
    }catch(error){

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Text("cancel"),
          onPressed: () {Navigator.pop(context);},
        ),
        title: const Text('Add'),
        actions: <Widget>[
      IconButton(
      icon: Text("Save"),
      onPressed: () {
        if(key.currentState!.validate()){
          String itemName = _productnameController.text;
          String price = _priceController.text;
          String descrip = _descriptionController.text;

          Map<String, String> dataToSend = {
            'name': itemName,
            'price': price,
            'description': descrip,
            'image': imageUrl,
          };

          _reference.add(dataToSend);
          //name2.add(itemName);
        }

        Navigator.pop(context);},
    ),
        ],
      ),
      body: SafeArea(
        child: Form(
    key: key,
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15),),
            border: Border.all(color: Colors.white),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                ),
              ],
            ),
            child: (imageUrl != null)
              ? Image.network(imageUrl) : Image.network('http://handong.edu/site/handong/res/img/logo.png')
          ),
        ),
      IconButton(onPressed: () async{
        uploadImage();
        print(name2);
        },
      icon: Icon(Icons.camera_alt)
      ),
      TextField(
    controller: _productnameController,
    decoration: const InputDecoration(
    filled: true,
    labelText: 'Product Name',
    ),
      ),
    const SizedBox(height: 12.0),
    TextField(
    controller: _priceController,
    decoration: const InputDecoration(
    filled: true,
    labelText: 'Price',
    ),
    ),
    const SizedBox(height: 12.0),
    TextField(
    controller: _descriptionController,
    decoration: const InputDecoration(
    filled: true,
    labelText: 'Description',
    ),
    ),
    ],
    ),
    ),
    ),);
  }
}
