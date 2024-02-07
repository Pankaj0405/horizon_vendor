import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Controllers/auth_controller.dart';

var firebaseAuth = FirebaseAuth.instance;

var firestore = FirebaseFirestore.instance;

var authController = AuthController.instance;