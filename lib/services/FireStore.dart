import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FirestoreService{

  //get collection
  final CollectionReference UserDetails = FirebaseFirestore.instance.collection('UserData');

  //read the user data
  Stream<QuerySnapshot> getDetails(){
    final details = UserDetails.orderBy('timestamp', descending: true).snapshots();
    return details;
  }
}