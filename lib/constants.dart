import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:horizon_vendor/Controllers/auth_controller1.dart';
import '../Controllers/auth_controller.dart';

var firebaseAuth = FirebaseAuth.instance;
var buttonColor = Color(0xFF0098FF);
var firestore = FirebaseFirestore.instance;

var authController = AuthController1.instance;