import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_app/modeller/kullanici.dart';
import 'package:social_app/servisler/firestoreservisi.dart';
import 'package:social_app/servisler/storageservisi.dart';
import 'package:social_app/servisler/yetkilendirmeservisi.dart';

class ProfiliDuzenle extends StatefulWidget {
  final Kullanici profil;

  const ProfiliDuzenle({Key key, this.profil}) : super(key: key);
  @override
  _ProfiliDuzenleState createState() => _ProfiliDuzenleState();
}

class _ProfiliDuzenleState extends State<ProfiliDuzenle> {
  var _formKey = GlobalKey<FormState>();
  String _kullaniciAdi;
  String _hakkinda;
  File _secilmisFoto;
  bool _yukleniyor = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context)),
        backgroundColor: Colors.grey[100],
        title: Text(
          'Profili Düzenle',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.check, color: Colors.black), onPressed: _kaydet),
        ],
      ),
      body: ListView(
        children: [
          _yukleniyor
              ? LinearProgressIndicator()
              : SizedBox(
                  height: 0,
                ),
          _profilFoto(),
          _kullaniciBilgileri(),
        ],
      ),
    );
  }

  _kaydet() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _yukleniyor = true;
      });
      _formKey.currentState.save();
      // print(_kullaniciAdi);
      // print(_hakkinda);

      String profilFotoUrl;
      if (_secilmisFoto == null) {
        profilFotoUrl = widget.profil.fotoUrl;
      } else {
        profilFotoUrl = await StorageServisi().profilResmiYukle(_secilmisFoto);
      }

      String aktifKullaniciId =
          Provider.of<YetkilendirmeSevisi>(context, listen: false)
              .aktifKullaniciId;
      FireStoreServisi().kullaniciGuncelle(
          kullaniciId: aktifKullaniciId,
          kullaniciAdi: _kullaniciAdi,
          hakkinda: _hakkinda,
          fotoUrl: profilFotoUrl);

      setState(() {
        _yukleniyor = false;
      });

      Navigator.pop(context);
    }
  }

  _profilFoto() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 20.0),
      child: Center(
        //resim sığmadığı için eklendi (center widgeti)
        child: InkWell(
          onTap: _galeridenSec,
          child: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: _secilmisFoto == null
                ? NetworkImage(widget.profil.fotoUrl)
                : FileImage(_secilmisFoto),
            radius: 55,
          ),
        ),
      ),
    );
  }

  _galeridenSec() async {
    var image = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxWidth: 800.0,
        maxHeight: 600.0,
        imageQuality: 80);
    setState(() {
      _secilmisFoto = File(image.path);
    });
  }

  _kullaniciBilgileri() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12.0,
        right: 12.0,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              initialValue: widget.profil.kullaniciAdi,
              decoration: InputDecoration(
                labelText: "Kullanıcı Adı",
              ),
              validator: (girilendeger) {
                return girilendeger.trim().length <= 3
                    ? 'Kullanıcı adı en az 4 karakter olmalıdır.'
                    : null;
              },
              onSaved: (girilendeger) {
                _kullaniciAdi = girilendeger;
              },
            ),
            TextFormField(
              initialValue: widget.profil.hakkinda,
              decoration: InputDecoration(
                labelText: "Hakkında",
              ),
              validator: (girilendeger) {
                return girilendeger.trim().length > 100
                    ? 'Hakkında bilgisi 100 karakterden fazla olmamalıdır.'
                    : null;
              },
              onSaved: (girilendeger) {
                _hakkinda = girilendeger;
              },
            ),
          ],
        ),
      ),
    );
  }
}
