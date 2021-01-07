import 'package:flutter/material.dart';
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

  void _kullaniciOlustur() async {
    var _formState = _formAnahtari.currentState;
    if (_formState.validate()) {
      _formState.save();
      setState(() {
        yukleniyor = true;
      });
      try {
        await YetkilendirmeSevisi().mailIleKayit(email, sifre);
        Navigator.pop(context); //giriş yapıldığı için anasayfaya yönlendirdi
      } catch (hata) {
        uyariGoster(hataKodu: hata);
      }
    }
  }

  uyariGoster({hataKodu}) {
    String hataMesaji;
    if (hataKodu == "ERROR_INVALID_EMAIL") {
      hataMesaji = "Girdiğiniz mail adresi geçersizdir.";
    } else if (hataKodu == "ERROR_EMAIL_ALREADY_IN_USE") {
      hataMesaji = "Girdiğiniz mail daha önce kaydedilmiş";
    } else if (hataKodu == "ERROR_WEAK_PASSWORD") {
      hataMesaji = "Daha zor bir şifre belirleyin";
    }

    var snackBar = SnackBar(content: Text(hataMesaji));
    _scaffoldAnahtari.currentState.showSnackBar(snackBar);
  }
}
