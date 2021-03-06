import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/modeller/kullanici.dart';
import 'package:social_app/servisler/firestoreservisi.dart';
import 'package:social_app/servisler/yetkilendirmeservisi.dart';

class HesapOlustur extends StatefulWidget {
  @override
  _HesapOlusturState createState() => _HesapOlusturState();
}

class _HesapOlusturState extends State<HesapOlustur> {
  bool yukleniyor = false;
  final _formAnahtari = GlobalKey<FormState>();
  String kullaniciAdi, email, sifre;
  final _scaffoldAnahtari = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldAnahtari,
      appBar: AppBar(
        title: Text("Hesap Oluştur"),
      ),
      body: ListView(
        children: [
          yukleniyor ? LinearProgressIndicator() : SizedBox(height: 0.0),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formAnahtari,
              child: Column(
                children: [
                  TextFormField(
                    autocorrect: true, //klavyenin otomatik tamamlaması
                    decoration: InputDecoration(
                      hintText: "Kullanıcı adınızı girin..",
                      labelText: "Kullanıcı adı",
                      errorStyle: TextStyle(
                        fontSize: 16.0,
                      ),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (girilenDeger) {
                      //form doğrulama
                      if (girilenDeger.isEmpty) {
                        return "Kullanıcı adı boş bırakılamaz";
                      } else if (girilenDeger.trim().length < 4 ||
                          girilenDeger.trim().length > 10) {
                        return "Kullanıcı adı en az 4 en fazla 10 karakter olmalıdır.";
                      }
                      return null;
                    },
                    onSaved: (girilenDeger) => kullaniciAdi = girilenDeger,
                    // kaydet kullanici adı
                  ), //yazi yazma alanı
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType
                        .emailAddress, //klavye tipi. mail olunca @ işareti otomatik olarak gelir.
                    decoration: InputDecoration(
                      hintText: "Email Adresinizi girin..",
                      labelText: "Mail",
                      errorStyle: TextStyle(
                        fontSize: 16.0,
                      ),
                      prefixIcon: Icon(Icons.mail),
                    ),
                    validator: (girilenDeger) {
                      //form doğrulama
                      if (girilenDeger.isEmpty) {
                        return "E-mail alanı boş bırakılamaz";
                      } else if (!girilenDeger.contains("@")) {
                        //@ sembolü yoksa
                        return "Girilen değer mail formatında olmalıdır.";
                      }
                      return null;
                    },
                    onSaved: (girilenDeger) => email = girilenDeger,
                    // kaydet email
                  ), //yazi yazma alanı
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    obscureText: true, //parola gizleme
                    decoration: InputDecoration(
                      hintText: "Şifrenizi girin..",
                      labelText: "Şifre",
                      errorStyle: TextStyle(
                        fontSize: 16.0,
                      ),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (girilenDeger) {
                      //form doğrulama
                      if (girilenDeger.isEmpty) {
                        return "Şifre alanı boş bırakılamaz";
                      } else if (girilenDeger.trim().length < 4) {
                        return "Şifre 4 karakterden az olamaz";
                      }
                      return null;
                    },
                    onSaved: (girilenDeger) => sifre = girilenDeger,
                    // kaydet şifre
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: _kullaniciOlustur,
                      child: Text(
                        "Hesap Oluştur",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

/**
 * 
 * kullanici objesi döndürür.
 */
  void _kullaniciOlustur() async {
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeSevisi>(context, listen: false);
    var _formState = _formAnahtari.currentState;
    if (_formState.validate()) {
      _formState.save();
      setState(() {
        yukleniyor = true;
      });
      try {
        Kullanici kullanici =
            await _yetkilendirmeServisi.mailIleKayit(email, sifre);
        if (kullanici != null) {
          FireStoreServisi().kullaniciOlustur(
            id: kullanici.id,
            email: kullanici.email,
            kullaniciAdi: kullanici.kullaniciAdi,
          );
        }
        Navigator.pop(context); //giriş yapıldığı için anasayfaya yönlendirdi
      } catch (hata) {
        setState(() {
          yukleniyor = false;
        });
        uyariGoster(hataKodu: hata.code); //hata olması durumunda
      }
    }
  }

  /**
   *  hata olması durumda aşağıdaki kodlar çalışacak. şuan çalışmıyor tekrardan dön bu konuya.
   *  şuan için aynı epostaya ikinci bir kayıt olurken hata ile karşılaşırsa diye çalışmıyor.
   * 
   */

  uyariGoster({hataKodu}) {
    String hataMesaji;
    if (hataKodu == "invalid-email") {
      hataMesaji = "Girdiğiniz mail adresi geçersizdir.";
    } else if (hataKodu == "emaıl-already-ın-use") {
      hataMesaji = "Girdiğiniz mail daha önce kaydedilmiş";
    } else if (hataKodu == "weak-password") {
      hataMesaji = "Daha zor bir şifre belirleyin";
    } else {
      hataMesaji = "Hata : $hataKodu";
    }

    var snackBar = SnackBar(content: Text(hataMesaji));
    _scaffoldAnahtari.currentState.showSnackBar(snackBar);
  }
}
