import 'package:flutter/material.dart';
import 'package:social_app/servisler/yetkilendirmeservisi.dart';

class AnaSayfa extends StatefulWidget {
  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () => YetkilendirmeSevisi().cikisYap(),
          child: Text("Çık"),
        ),
      ),
    );
  }
}
