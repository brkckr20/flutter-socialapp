/**
 *  metot zinciri kullanımı
 *  void döndüren bir metotun devamında tekrardan void döndüren bir metot çağrılamaz.
 *  o yüzden ikinci bir metot ekleyecek isek metotlar arasına 1 değil 2 nokta koymalıyız.
 *  sayilar..add(1)..add(2)..add(3); gibi
 * 
 *  bunu sadece listelerde kullanmak zorunda değiliz.
 *  örneğin class ın içindeki özelliklere değer tanımlarken nesne_Adi..ad="burak"..soyad="cakir" gibi
 */

void main(List<String> args) {
  List sayilar = [];
  sayilar.add(1);
  sayilar.add(2);
  sayilar.add(3);
}

/**
 * 
 *  ??= boş değil ise doldur operatörü
 * 
 *  print(2 ?? 3);
 *  bu örnekte iki soru işaretinin solu boş değil ise onu yazdırır. boş ise sağ kısımdakini yazdırır.
 * 
 */
