import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

CollectionReference usercollection=FirebaseFirestore.instance.collection("users");
CollectionReference notescollection=FirebaseFirestore.instance.collection("usernotes");
FirebaseStorage firebaseStorage=FirebaseStorage.instance;