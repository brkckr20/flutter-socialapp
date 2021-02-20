import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/servisler/yetkilendirmeservisi.dart';
import 'package:social_app/yonlendirme.dart';

//void main() => runApp(MyApp());

/*
 * [core/no-app] No Firebase App '[DEFAULT]' has been created - call Firebase.initializeApp()
 * hatası alındığında pubdev den flutter_core paketini indirip run kısmını aşağıdaki gibi düzenle
 * 
 * 
 */
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<YetkilendirmeSevisi>(
      create: (_) => YetkilendirmeSevisi(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Projem',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Yonlendirme(),
      ),
    );
  }
}
