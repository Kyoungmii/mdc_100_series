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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shrine/database.dart';
import 'package:shrine/user.dart';

import 'app.dart';
import 'home.dart';
import 'login.dart';

String name ='';
String email='';
String imageUrl='';
String uid='';
String status_message='I promise to take the test honestly before God';


class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  UserModel? _userFromFirebaseUser(User user) {
  return user != null ? UserModel(uid: user.uid) : null;
}

  Stream<UserModel?> get user {
    return _auth.authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user!));
  }

  Future signInAnonymous() async {

      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      if (user != null) {
        // Checking if email and name is null
        //assert(user.email != null);
        //assert(user.displayName == null);
        //assert(user.photoURL != null);
        assert(user.uid != null);

        //name = user.displayName!;
        email = 'Anonymous';
        imageUrl = 'http://handong.edu/site/handong/res/img/logo.png';
        uid = user.uid;

        // Only taking the first part of the name, i.e., First Name
        if (name.contains(" ")) {
          name = name.substring(0, name.indexOf(" "));
        }

        assert(await user.getIdToken() != null);

        final User? currentUser = _auth.currentUser;
        assert(user.uid == currentUser?.uid);

        print('signInWithGoogle succeeded: $user');
        await DatabaseService(uid: user.uid).updateAnonData(status_message, uid);

        return '$user';
      }

      return null;
    }

  Future<String?> signInWithGoogle() async {
    await Firebase.initializeApp();

    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleSignInAuthentication =
    await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );

    final UserCredential result = await _auth.signInWithCredential(credential);
    final User? user = result.user;

    if (user != null) {
      // Checking if email and name is null
      assert(user.email != null);
      assert(user.displayName != null);
      assert(user.photoURL != null);
      assert(user.uid != null);

      name = user.displayName!;
      email = user.email!;
      imageUrl = user.photoURL!;
      uid = user.uid;

      // Only taking the first part of the name, i.e., First Name
      if (name.contains(" ")) {
        name = name.substring(0, name.indexOf(" "));
      }

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User? currentUser = _auth.currentUser;
      assert(user.uid == currentUser?.uid);

      print('signInWithGoogle succeeded: $user');
      await DatabaseService(uid: user.uid).updateUserData(email, name, status_message, uid);

      return '$user';
    }

    return null;
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Signed Out");
  }

  Future signOut() async {
    try{
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }
}