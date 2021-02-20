import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/modeller/gonderi.dart';
import 'package:social_app/modeller/kullanici.dart';
import 'package:social_app/sayfalar/profil.dart';
import 'package:social_app/sayfalar/yorumlar.dart';
import 'package:social_app/servisler/firestoreservisi.dart';
import 'package:social_app/servisler/yetkilendirmeservisi.dart';

class GonderiKarti extends StatefulWidget {
  final Gonderi gonderi;
  final Kullanici yayinlayan;

  const GonderiKarti({Key key, this.gonderi, this.yayinlayan})
      : super(key: key);
  @override
  _GonderiKartiState createState() => _GonderiKartiState();
}

class _GonderiKartiState extends State<GonderiKarti> {
  int _begeniSayisi = 0;
  bool _begendin = false;
  String _aktifKullaniciId;

  @override
  void initState() {
    super.initState();
    _aktifKullaniciId = Provider.of<YetkilendirmeSevisi>(context, listen: false)
        .aktifKullaniciId;
    _begeniSayisi = widget.gonderi.begeniSayisi;
    begeniVarmi();
  }

  begeniVarmi() async {
    bool begeniVarMi =
        await FireStoreServisi().begeniVarMi(widget.gonderi, _aktifKullaniciId);
    if (begeniVarMi) {
      /** NOT MOUNTED HATASININ ÇÖZÜMÜ */
      /** setstaleri if koşulu içinde mounted yazılır. */
      if (mounted) {
        setState(() {
          _begendin = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          _gonderiBasligi(),
          _gonderiResmi(),
          _gonderiAlt(),
        ],
      ),
    );
  }

  gonderiSecenekleri() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Seçim Yap'),
            children: [
              SimpleDialogOption(
                child: Text("Gönderiyi Sil"),
                onPressed: () {
                  FireStoreServisi().gonderiSil(
                      aktifKullaniciId: _aktifKullaniciId,
                      gonderi: widget.gonderi);
                  Navigator.pop(context);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  "Vazgeç",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Widget _gonderiBasligi() {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Profil(
                          profilSahibiId: widget.gonderi.yayinlayanId,
                        )));
          },
          child: CircleAvatar(
            backgroundColor: Colors.blue,
            backgroundImage: widget.yayinlayan.fotoUrl.isNotEmpty
                ? NetworkImage(widget.yayinlayan.fotoUrl)
                : AssetImage("assets/avatar.png"),
          ),
        ),
      ),
      title: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Profil(
                        profilSahibiId: widget.gonderi.yayinlayanId,
                      )));
        },
        child: Text(
          widget.yayinlayan.kullaniciAdi,
          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
      ),
      trailing: _aktifKullaniciId == widget.gonderi.yayinlayanId
          ? IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () => gonderiSecenekleri())
          : null,
      contentPadding: EdgeInsets.all(0),
    );
  }

  Widget _gonderiResmi() {
    return GestureDetector(
      onDoubleTap: _begeniDegistir,
      child: Image.network(
        widget.gonderi.gonderiResmiUrl,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 400,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _gonderiAlt() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: !_begendin
                  ? Icon(
                      Icons.favorite_border,
                      size: 35.0,
                    )
                  : Icon(
                      Icons.favorite,
                      size: 35.0,
                      color: Colors.red,
                    ),
              onPressed: _begeniDegistir,
            ),
            IconButton(
                icon: Icon(Icons.comment),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Yorumlar(
                                gonderi: widget.gonderi,
                              )));
                })
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            "$_begeniSayisi beğeni",
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 2.0),
        widget.gonderi.aciklama.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: RichText(
                  text: TextSpan(
                    text: widget.yayinlayan.kullaniciAdi + " ",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: [
                      TextSpan(
                          text: widget.gonderi.aciklama,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          )),
                    ],
                  ),
                ),
              )
            : SizedBox(
                height: 0.0,
              ),
      ],
    );
  }

  void _begeniDegistir() {
    if (_begendin) {
      /// zaten beğendiği için beğenmesini iptal edeceğimiz kodları yazacagız.
      setState(() {
        _begendin = false;
        _begeniSayisi = _begeniSayisi - 1;
      });
      FireStoreServisi().gonderiBegeniKaldir(widget.gonderi, _aktifKullaniciId);
    } else {
      ///beğeni ekleme işlemini yapacağımız kodları
      setState(() {
        _begendin = true;
        _begeniSayisi = _begeniSayisi + 1;
      });
      FireStoreServisi().gonderiBegen(widget.gonderi, _aktifKullaniciId);
    }
  }
}
