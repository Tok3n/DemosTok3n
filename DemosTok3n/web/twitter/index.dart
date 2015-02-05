import "dart:html";
import "package:Tok3n_Dart/tok3n_dart.dart";

void main(){
  querySelector("#publicacion").onClick.listen((_)=>startAuth());
}

void startAuth(){
  Tok3nClient tkn = new Tok3nClient("cb4e4e13-c106-5fec-6b48-788c2a4f29fb",querySelector("body"));
  tkn.addUser();
  tkn.response.then((_)=>responded());
}

void responded(){
  window.location.assign("https://twitter.com/intent/tweet?text=${Uri.encodeComponent("Sending a Tweet with Tok3n")}&related=${Uri.encodeComponent("tok3napp,opentok3n")}");
  
}