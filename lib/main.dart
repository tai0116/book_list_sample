import 'package:book_lisy_sample/book_list/book_list_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

//WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();によって、firebaseがイニシャライズされる。なぜできるのかと言えば、infoplistを入れたから。

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookListSample',
      home: BookLisyPage(),
    );
  }
}
