import 'package:flutter/material.dart';
import 'package:social_app/modeller/kullanici.dart';
import 'package:social_app/sayfalar/anasayfa.dart';
import 'package:social_app/sayfalar/girissayfasi.dart';
import 'package:social_app/servisler/yetkilendirmeservisi.dart';

class Yonlendirme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: YetkilendirmeSevisi().durumTakipcisi,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          Kullanici aktifKullanici = snapshot.data;
          return AnaSayfa();
        } else {
          return GirisSayfasi();
        }
      },
    );
  }
}
