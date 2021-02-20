import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/modeller/gonderi.dart';
import 'package:social_app/modeller/kullanici.dart';
import 'package:social_app/servisler/firestoreservisi.dart';
import 'package:social_app/servisler/yetkilendirmeservisi.dart';
import 'package:social_app/widgetler/gonderikarti.dart';
import 'package:social_app/widgetler/silinmeyenFutureBuilder.dart';

class Akis extends StatefulWidget {
  @override
  _AkisState createState() => _AkisState();
}

class _AkisState extends State<Akis> {
  List<Gonderi> _gonderiler = [];

  _akisGonderileriniGetir() async {
    String aktifKullaniciId =
        Provider.of<YetkilendirmeSevisi>(context, listen: false)
            .aktifKullaniciId;

    List<Gonderi> gonderiler =
        await FireStoreServisi().akisGonderileriniGetir(aktifKullaniciId);
    setState(() {
      _gonderiler = gonderiler;
    });
  }

  @override
  void initState() {
    super.initState();
    _akisGonderileriniGetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("SocialApp"),
          centerTitle: true, //başlık ortala
        ),
        body: ListView.builder(
          shrinkWrap: true, //ihtiyacı kadar yer kapla
          primary: false, //kaydırma ihtiyacın yoksa kapat anlamında
          itemBuilder: (context, index) {
            Gonderi gonderi = _gonderiler[index];
            return SilinmeyenFutureBuilder(
              future: FireStoreServisi().kullaniciGetir(gonderi.yayinlayanId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox();
                }
                Kullanici gonderiSahibi = snapshot.data;
                return GonderiKarti(
                  gonderi: gonderi,
                  yayinlayan: gonderiSahibi,
                );
              },
            );
          },
          itemCount: _gonderiler.length,
        ));
  }
}
/**
 * 
 *  class Banu extends Insan with Ingilizce{
 *  
 * }
 * class Insan{
 * }
 * 
 * mixin Ingilizce on Insan{  --> on eklemesi yapılırsa sadece insan sınıfından kalıtım almış nesneler bu sınıfın özelliklerine erişebilir.
 * }
 * 
 */
