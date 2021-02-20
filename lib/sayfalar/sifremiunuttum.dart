import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/servisler/yetkilendirmeservisi.dart';

class SifremiUnuttum extends StatefulWidget {
  @override
  _SifremiUnuttumState createState() => _SifremiUnuttumState();
}

class _SifremiUnuttumState extends State<SifremiUnuttum> {
  bool yukleniyor = false;
  final _formAnahtari = GlobalKey<FormState>();
  String email;
  final _scaffoldAnahtari = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldAnahtari,
      appBar: AppBar(
        title: Text("Şifremi Sıfırla"),
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
                    height: 50,
                  ),
                  Container(
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: _sifreyiSifirla,
                      child: Text(
                        "Şifremi Sıfırla",
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

  void _sifreyiSifirla() async {
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeSevisi>(context, listen: false);
    var _formState = _formAnahtari.currentState;
    if (_formState.validate()) {
      _formState.save();
      setState(() {
        yukleniyor = true;
      });
      try {
        await _yetkilendirmeServisi.sifremiSifirla(email);
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
    } else {
      hataMesaji = "Hata : $hataKodu";
    }

    var snackBar = SnackBar(content: Text(hataMesaji));
    _scaffoldAnahtari.currentState.showSnackBar(snackBar);
  }
}
