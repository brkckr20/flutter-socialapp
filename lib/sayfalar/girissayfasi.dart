import 'package:flutter/material.dart';
import 'package:social_app/sayfalar/hesapolustur.dart';

class GirisSayfasi extends StatefulWidget {
  @override
  _GirisSayfasiState createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  final _formAnahtari = GlobalKey<FormState>();
  bool yukleniyor = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _sayfaElemanlari(),
          _yuklemeAnimasyonu(),
        ],
      ),
    );
  }

  Widget _yuklemeAnimasyonu() {
    if (yukleniyor == true) {
      return Center(child: CircularProgressIndicator());
    } else {
      return SizedBox();
    }
  }

  Widget _sayfaElemanlari() {
    return Form(
      key: _formAnahtari,
      child: ListView(
        padding: EdgeInsets.only(right: 20, left: 20, top: 60),
        children: [
          FlutterLogo(
            size: 90.0,
          ),
          SizedBox(
            height: 80.0,
          ),
          TextFormField(
            autocorrect: true, //klavyenin otomatik tamamlaması
            keyboardType: TextInputType
                .emailAddress, //klavye tipi. mail olunca @ işareti otomatik olarak gelir.
            decoration: InputDecoration(
              hintText: "Email Adresinizi girin..",
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
          ), //yazi yazma alanı
          SizedBox(
            height: 40.0,
          ),
          TextFormField(
            obscureText: true, //parola gizleme
            decoration: InputDecoration(
              hintText: "Şifrenizi girin..",
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
          ), //yazi yazma alanı
          SizedBox(
            height: 60.0,
          ),
          Row(
            children: [
              Expanded(
                child: FlatButton(
                  onPressed: () {
                    /**hesap oluştur sayfasına yönlendirme */
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HesapOlustur()));
                  },
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
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: FlatButton(
                  onPressed: _girisYap,
                  child: Text(
                    "Giriş Yap",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  color: Theme.of(context).primaryColorDark,
                ),
              )
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Center(child: Text("Veya")),
          SizedBox(
            height: 20.0,
          ),
          Center(
              child: Text(
            "Google İle Giriş Yap",
            style: TextStyle(
              fontSize: 19.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          )),
          SizedBox(
            height: 20.0,
          ),
          Center(child: Text("Şifremi Unuttum")),
        ],
      ),
    );
  }

  void _girisYap() {
    if (_formAnahtari.currentState.validate()) {
      //form doğrulamasında hata yoksa
      setState(() {
        yukleniyor = true;
      });
    }
  }
}
