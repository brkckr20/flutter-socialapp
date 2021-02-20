import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_app/modeller/gonderi.dart';
import 'package:uuid/uuid.dart';

class StorageServisi {
  StorageReference _storage = FirebaseStorage.instance.ref();
  //depolama alanına ulaştık

  String resimID;

  Future<String> gonderiResmiYukle(File resimDosyasi) async {
    // depolanacak dosya adı ve hani dosyanın depolanacağı.
    resimID = Uuid().v4();
    //resimlerin isimlerinin karışmaması için benzersiz kimlik oluşturmak

    var yuklemeYoneticisi = _storage
        .child("resimler")
        .child("gonderiler")
        .child("gonderi_$resimID.jpg")
        .putFile(resimDosyasi);
    /**
    child => ana dizinin çocuğu olmasını sağladık
    başına bir child daha eklenerek anadizin altında bir klasör oluşturduk ve  ve resmi o dizin altına ekleme yaptırdık


    child("gonderiler/resimler/gonderi.jpg") şeklinde de yazılabilir.
     */
    StorageTaskSnapshot snapshot = await yuklemeYoneticisi.onComplete;
    String yuklenenResimUrl = await snapshot.ref.getDownloadURL();
    return yuklenenResimUrl;
    //await yuklemeYoneticisi.whenComplete((tamam) => print(tamam));
  }

  Future<String> profilResmiYukle(File resimDosyasi) async {
    // depolanacak dosya adı ve hani dosyanın depolanacağı.
    resimID = Uuid().v4();
    //resimlerin isimlerinin karışmaması için benzersiz kimlik oluşturmak

    var yuklemeYoneticisi = _storage
        .child("resimler")
        .child("profil")
        .child("profil_$resimID.jpg")
        .putFile(resimDosyasi);
    /**
    child => ana dizinin çocuğu olmasını sağladık
    başına bir child daha eklenerek anadizin altında bir klasör oluşturduk ve  ve resmi o dizin altına ekleme yaptırdık


    child("gonderiler/resimler/gonderi.jpg") şeklinde de yazılabilir.
     */
    StorageTaskSnapshot snapshot = await yuklemeYoneticisi.onComplete;
    String yuklenenResimUrl = await snapshot.ref.getDownloadURL();
    return yuklenenResimUrl;
    //await yuklemeYoneticisi.whenComplete((tamam) => print(tamam));
  }

  gonderiResmiSil(String gonderiResmiUrl) {
    RegExp arama =
        RegExp(r"gonderi_.+\.jpg"); // birden fazla joker işareti gelecek
    var eslesme = arama.firstMatch(gonderiResmiUrl);
    String dosyaAdi = eslesme[0];
    if (dosyaAdi != null) {
      _storage.child("resimler/gonderiler/$dosyaAdi").delete();
    }
  }
}
