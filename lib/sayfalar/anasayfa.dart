import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/sayfalar/akis.dart';
import 'package:social_app/sayfalar/ara.dart';
import 'package:social_app/sayfalar/duyurular.dart';
import 'package:social_app/sayfalar/profil.dart';
import 'package:social_app/sayfalar/yukle.dart';
import 'package:social_app/servisler/yetkilendirmeservisi.dart';

class AnaSayfa extends StatefulWidget {
  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int _aktifSayfaNo = 0;
  PageController sayfaKumandasi;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sayfaKumandasi = PageController();
  }

  @override
  void dispose() {
    sayfaKumandasi.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String aktifKullaniciId =
        Provider.of<YetkilendirmeSevisi>(context, listen: false)
            .aktifKullaniciId;
    return Scaffold(
      body: PageView(
        physics:
            NeverScrollableScrollPhysics(), //kaydırılıp ekran değiştirilmesini kapatma
        onPageChanged: (acilanSayfaNo) {
          setState(() {
            _aktifSayfaNo = acilanSayfaNo;
          });
        },
        controller: sayfaKumandasi,
        children: [
          Akis(),
          Ara(),
          Yukle(),
          Duyurular(),
          Profil(
            profilSahibiId: aktifKullaniciId,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _aktifSayfaNo,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey[600],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Akış"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            title: Text("Keşfet"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_upload),
            title: Text("Yükle"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            title: Text("Duyurular"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Profil"),
          ),
        ],
        onTap: (secilenSayfaNo) {
          setState(() {
            //  _aktifSayfaNo = secilenSayfaNo;
            sayfaKumandasi.jumpToPage(secilenSayfaNo);
          });
        },
      ),
    );
  }
}
