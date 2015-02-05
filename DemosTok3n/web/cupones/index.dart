import "dart:html";
import "dart:async";
import "dart:convert";
import "package:Tok3n_Dart/tok3n_dart.dart";

DivElement coupon2,coupon3;
List listeners = new List();

void main(){
  coupon2 = querySelector("#cupon2");
  coupon3 = querySelector("#cupon3");
  
  var temp;
  temp = coupon2.onClick.listen(cupon2_clicked);
  listeners.add(temp);
  temp = coupon3.onClick.listen(cupon3_clicked);
  listeners.add(temp);
}

Tok3nClient tkn;
void cupon2_clicked(_){
  // agregar el codigo de tok3n
  
  tkn = new Tok3nClient("cb4e4e13-c106-5fec-6b48-788c2a4f29fb",querySelector("body"));
  tkn.addUser();
  tkn.response.then((r)=>responded2(r));
}
void cupon3_clicked(_){
  // Cupon falso
  tkn = new Tok3nClient("cb4e4e13-c106-5fec-6b48-788c2a4f29fb",querySelector("body"));
  tkn.addUser();
  tkn.response.then((r)=>responded3(r));
}

void responded2(r){
  tkn.remove();
  var data = JSON.decode(r.detail);
  HttpRequest.getString("/ws/addCoupon?user=${data["UserKey"]}&kind=0").then((_){
    window.alert("Congratulations you have a free integration with tok3n. Go to secure.tok3n.com now to use it.");
    removeSubscriptions();
  });
  
}

void responded3(r){
  tkn.remove();
  var data = JSON.decode(r.detail);
  HttpRequest.getString("/ws/addCoupon?user=${data["UserKey"]}&kind=1").then((_){
    window.alert("You have redemed this coupon.");
    removeSubscriptions();
  });
}

void removeSubscriptions(){
  listeners.forEach((StreamSubscription l){
    l.cancel();
  });
  listeners = new List();
}