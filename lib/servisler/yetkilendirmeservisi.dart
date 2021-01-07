import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/modeller/kullanici.dart';

class YetkilendirmeSevisi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Kullanici _kullaniciOlustur(User kullanici) {
    return kullanici == null ? null : Kullanici.firebasedenUret(kullanici);
  }

  Stream<Kullanici> get durumTakipcisi {
    return _firebaseAuth.authStateChanges().map(_kullaniciOlustur);
  }

  mailIleKayit(String eposta, String sifre) async {
    /*mail ile kayıt olma metodumuz */
    var girisKarti = await _firebaseAuth.createUserWithEmailAndPassword(
        email: eposta, password: sifre);
    return _kullaniciOlustur(girisKarti.user);
  }

  mailIleGiris(String eposta, String sifre) async {
    /*mail ile giriş yapma metodumuz */
    var girisKarti = await _firebaseAuth.signInWithEmailAndPassword(
        email: eposta, password: sifre);
    return _kullaniciOlustur(girisKarti.user);
  }

  Future<void> cikisYap() {
    return _firebaseAuth.signOut(); // çıkış yapma metodumuz
  }
}
