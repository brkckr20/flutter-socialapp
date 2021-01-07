import 'package:flutter/material.dart';
import 'package:social_app/yonlendirme.dart';
import 'package:firebase_core/firebase_core.dart';

//void main() => runApp(MyApp());

/**
 * [core/no-app] No Firebase App '[DEFAULT]' has been created - call Firebase.initializeApp()
 * hatası alındığında pubdev den flutter_core paketini indirip run kısmını aşağıdaki gibi düzenle
 * 
 * 
 */
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Projem',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Yonlendirme(),
    );
  }
}
