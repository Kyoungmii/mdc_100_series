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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shrine/user.dart';

import 'app.dart';
import 'auth.dart';
import 'home.dart';
import 'login.dart';



class DatabaseService {

  final String uid;
  DatabaseService({required this.uid});


  final CollectionReference Collection = FirebaseFirestore.instance.collection('user');

  Future updateUserData(String email, String name, String status_message, String uid) async{
    return await Collection.doc(uid).set({
      'email': email,
      'name': name,
      'status_message': status_message,
      'uid': uid
    });
  }

  Future updateAnonData(String status_message, String uid) async{
    return await Collection.doc(uid).set({
      'status_message': status_message,
      'uid': uid
    });
  }

}