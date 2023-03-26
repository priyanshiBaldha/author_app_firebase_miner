
import 'package:author/views/screens/authorCrud_page.dart';
import 'package:author/views/screens/author_page.dart';
import 'package:author/views/screens/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        routes: {
          '/':(context) => const Homepage(),
          'author_page':(context) => const AuthorPage(),
          'author_crud':(context) => const AuthorCrud(),
        },
      )
  );
}
