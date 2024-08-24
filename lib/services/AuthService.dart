import 'package:farm_pro/customFunction.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

signInWithGoogle(context) async{
  //begin sign in processs

  //loading begin
  loadAnimation(context);

  GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

  //obtain auth details from the requset
  GoogleSignInAuthentication? gAuth = await gUser?.authentication;

  //create a new user credential
  AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: gAuth?.accessToken,
    idToken:  gAuth?.idToken,
  );

  //sign in
  await FirebaseAuth.instance.signInWithCredential(credential);

  //close loading
  Navigator.pop(context);
}
