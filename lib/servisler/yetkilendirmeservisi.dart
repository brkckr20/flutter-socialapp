import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_app/modeller/kullanici.dart';

class YetkilendirmeSevisi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String aktifKullaniciId;

  Kullanici _kullaniciOlustur(FirebaseUser kullanici) {
    return kullanici == null ? null : Kullanici.firebasedenUret(kullanici);
  }

  Stream<Kullanici> get durumTakipcisi {
    return _firebaseAuth.onAuthStateChanged.map(_kullaniciOlustur);
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
  /**
   * GOOGLE İLE GİRİŞ YAPABİLMEK İÇİN FİREBASEDEN GOOGLE İÇİN PARMAK İZİ OLUŞTURMA YÖNERGELERİ İZLENİR.
   * PARMAK İZİ OLUŞTURMAK İÇİN TERMİNALDEN CD ANDROİD KLASÖRÜNE GİDİLİR.
   * BULUNAN KLASÖR İÇERİSİNDE ./gradlew signingReport ÇALIŞTIRILARAK ÇIKAN EKRANDAKİ SHA1 KODLARINDAN Bİ TANESİ KOPYALANARAK
   * FİREBASE DE PARMAK İZİ EKLE KISMINA YAPIŞTIRILIR VE GOOGLE ADRESİ YAPILANDIRMASI İÇİN BİR ADRES BELİRLENİR. SONRA DA TAMAM - 
   * DENİLEREK PROJEYE EKLENİR.
   * 
   */

  Future<Kullanici> googleIleGirisYap() async {
    GoogleSignInAccount googleHesabi = await GoogleSignIn().signIn();
    GoogleSignInAuthentication googleYetkiKartim =
        await googleHesabi.authentication;
    AuthCredential sifresizGirisBelgesi = GoogleAuthProvider.getCredential(
        idToken: googleYetkiKartim.idToken,
        accessToken: googleYetkiKartim.accessToken);
    // programa şifresiz giriş için şifresiz giriş belgesi döndürür.

    //  print(googleHesabi.id);
    //  print(googleHesabi.displayName);

    var girisKarti =
        await _firebaseAuth.signInWithCredential(sifresizGirisBelgesi);

    // print(girisKarti.user.uid);
    // print(girisKarti.user.displayName);
    // print(girisKarti.user.photoURL);
    return _kullaniciOlustur(girisKarti.user);
  }

  Future<void> sifremiSifirla(String eposta) async {
    await _firebaseAuth.sendPasswordResetEmail(email: eposta);
  }
}
