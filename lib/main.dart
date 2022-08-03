import 'package:blog/Pages/add_and_edit_items.dart';
import 'package:blog/Pages/details_page.dart';
import 'package:blog/Pages/show_items.dart';
import 'package:blog/Pages/home_page.dart';
import 'package:blog/Pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD2LAa0E3TpONy-4BFIbNj_JmlKMny8jBo",
      appId: "com.example.blog",
      messagingSenderId: "874380109592",
      projectId: "nna-blog",
      storageBucket: "gs://nna-blog.appspot.com",
    ),
  );
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mr. Hunger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      routes: {
        '/home': (context) => const HomePage(),
        '/admin': (context) => const LoginPage(),
        '/admin/show-items': (context) => const ShowContentPage(),
        '/admin/add-items': (context) => AddAndEditItemsPage(id: 1),
      },
      home: const HomePage(),
      // home: AddAndEditItemsPage(id: 1),
    );
  }
}
