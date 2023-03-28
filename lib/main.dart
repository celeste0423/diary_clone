import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_pencake_clone/repository/notepage_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'page/app.dart';

void main() async {
  //파이어 베이스 시작하려면 메인 화면에 이거 붙여줄 것
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final snapshot = await FirebaseFirestore.instance.collection('notepages').orderBy(FieldPath.documentId).limit(1).get();
  final _notepage = Notepage.fromJson(snapshot.docs.first.data());

  runApp(MyApp(
    baseNotePage: _notepage,
    ),
  );
}

class MyApp extends StatelessWidget {
  final Notepage baseNotePage;
  const MyApp({super.key, required this.baseNotePage,});

  @override
  Widget build(BuildContext context) {
    // final String fontName = '';
    return GetMaterialApp(
      title: 'Diary_clone',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        // fontFamily: fontName,
      ),
      home: App(baseNotePage: baseNotePage),
    );
  }
}
