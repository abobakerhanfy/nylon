


class LocalProducts{
  String? nameAr ,nameEn ,  decEn ,decAr,image;
  int id,count ;
  int?  price;
  bool? isFov , isCart ;
  LocalProducts(
      this.image,
      this.id,
      this.nameAr,
      this.decAr,
      this.decEn,
      this.isCart,
      this.isFov,
      this.nameEn,
      this.price,
      this.count
      );
}
class LocalData{
 static   List<LocalProducts> data = [
    LocalProducts(
       'images/test18.jpg',
       1,
      'اكواب ورقيه اسود طبقه واحدة',
        'اكواب اسود 12اونص (50حبة)',
        'Tin dessert dish (125 pieces)',
        false,
        false,
        'Tin dishes',
            12,
      1,
    ),
    LocalProducts(
      'images/test5.png',
      1,
      'اطباق قصدير',
      'صحن قصدير حلى (125حبة)',
      'Tin dessert dish (125 pieces)',
      false,
      false,
      'Tin dishes',
      13,
      1,
    ),

  ];
}
class DeliveryData{
  String? name , email , phone, address,city , postalNumber;
  DeliveryData({
    this.name,
    this.address,
    this.city,
    this.email,
    this.phone,
    this.postalNumber
});
}

