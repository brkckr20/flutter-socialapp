import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_app/servisler/firestoreservisi.dart';
import 'package:social_app/servisler/storageservisi.dart';
import 'package:social_app/servisler/yetkilendirmeservisi.dart';

class Yukle extends StatefulWidget {
  @override
  _YukleState createState() => _YukleState();
}

class _YukleState extends State<Yukle> {
  File dosya; //kullanabilmek için dart:io import et
  bool yukleniyor = false;
  TextEditingController aciklamaTextKumandasi = TextEditingController();
  TextEditingController konumTextKumandasi = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return dosya == null ? yukleButonu() : gonderiFormu();
  }

  Widget yukleButonu() {
    return IconButton(
        icon: Icon(
          Icons.file_upload,
          size: 50.0,
        ),
        onPressed: () {
          fotografSec();
        });
  }

  Widget gonderiFormu() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text(
          "Gönderi oluştur",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              dosya = null;
            });
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.black,
            ),
            onPressed: _gonderiOlustur,
          )
        ],
      ),
      body: ListView(
        children: [
          yukleniyor
              ? LinearProgressIndicator()
              : SizedBox(
                  height: 0.0,
                ),
          AspectRatio(
            //en boy oranı
            aspectRatio: 16.0 / 9.0,
            child: Image.file(
              dosya,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: aciklamaTextKumandasi, // input içindeki değeri okuma
            decoration: InputDecoration(
              hintText: "Açıklama Ekle",
              contentPadding: EdgeInsets.only(left: 15.0, right: 15.0),
            ),
          ),
          TextFormField(
            controller: konumTextKumandasi, // input içindeki değeri okuma
            decoration: InputDecoration(
              hintText: "Nerede Çekildi",
              contentPadding: EdgeInsets.only(left: 15.0, right: 15.0),
            ),
          )
        ],
      ),
    );
  }

  void _gonderiOlustur() async {
    if (!yukleniyor) {
      setState(() {
        yukleniyor = true;
      });
      String resimUrl = await StorageServisi().gonderiResmiYukle(dosya);
      String aktifKullaniciId =
          Provider.of<YetkilendirmeSevisi>(context, listen: false)
              .aktifKullaniciId;
      await FireStoreServisi().gonderiOlustur(
          gonderiResmiUrl: resimUrl,
          aciklama: aciklamaTextKumandasi.text,
          yayinlayanId: aktifKullaniciId,
          konum: konumTextKumandasi.text);
      setState(() {
        yukleniyor = false;
        aciklamaTextKumandasi.clear();
        konumTextKumandasi.clear();
        dosya = null;
      });
    }

    // print(resimUrl);
  }

  fotografSec() {
    return showDialog(
        // alttaki iki parametreyi alır
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Gönderi Oluştur"),
            children: [
              SimpleDialogOption(
                child: Text("Fotoğraf Çek"),
                onPressed: () {
                  fotoCek();
                },
              ),
              SimpleDialogOption(
                child: Text("Galeriden Seç"),
                onPressed: () {
                  galeridenSec();
                },
              ),
              SimpleDialogOption(
                child: Text("İptal"),
                onPressed: () {
                  Navigator.pop(context); //diyalog penceresini kapatır
                },
              ),
            ],
          );
        });
  }

  fotoCek() async {
    Navigator.pop(context);
    var image = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 800.0,
      maxHeight: 600.0,
      imageQuality: 80,
    );
    setState(() {
      dosya = File(image.path);
    });
  }

  galeridenSec() async {
    Navigator.pop(context);
    var image = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 800.0,
      maxHeight: 600.0,
      imageQuality: 80,
    );
    setState(() {
      dosya = File(image.path);
    });
  }
}
