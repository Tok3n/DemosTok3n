import "dart:html";
import "dart:convert";
import "package:intl/intl.dart";
import "package:Tok3n_Dart/tok3n_dart.dart";

void main(){
  new Calculator();
}

class Calculator{
  TextInputElement text;
  Calculator(){
    var container = querySelector("body");
    var div = new Element.html("""
<div>
  <table>
    <tr>
      <td colspan="3">
        <input type="text" id="text" value="\$0" />
      </td>
    </tr>
    <tr>
      <td>
        <input type="button" value="1" id="boton1" />
      </td>
      <td>
        <input type="button" value="2" id="boton2" />
      </td>
      <td>
        <input type="button" value="3" id="boton3" />
      </td>
    </tr>

    <tr>
      <td>
        <input type="button" value="4" id="boton4" />
      </td>
      <td>
        <input type="button" value="5" id="boton5" />
      </td>
      <td>
        <input type="button" value="6" id="boton6" />
      </td>
    </tr>

    <tr>
      <td>
        <input type="button" value="7" id="boton7" />
      </td>
      <td>
        <input type="button" value="8" id="boton8" />
      </td>
      <td>
        <input type="button" value="9" id="boton9" />
      </td>
    </tr>

    <tr>
      <td>
        <input type="button" value="0" id="boton0" />
      </td>
    </tr>

    <tr>
      <td colspan="3">
        <input type="button" value="Pagar" id="next" /><input type="button" value="Cancelar" id="cancel" />
      </td>
    </tr>
  </table>
</div>
""");
    container.nodes.clear();
    container.nodes.add(div);
    
    text = div.querySelector("#text");
    div.querySelector("#next").onClick.listen(getQR);
    div.querySelector("#cancel").onClick.listen(cancel);
    
    div.querySelector("#boton0").onClick.listen((_)=>add(0));
    div.querySelector("#boton1").onClick.listen((_)=>add(1));
    div.querySelector("#boton2").onClick.listen((_)=>add(2));
    div.querySelector("#boton3").onClick.listen((_)=>add(3));
    div.querySelector("#boton4").onClick.listen((_)=>add(4));
    div.querySelector("#boton5").onClick.listen((_)=>add(5));
    div.querySelector("#boton6").onClick.listen((_)=>add(6));
    div.querySelector("#boton7").onClick.listen((_)=>add(7));
    div.querySelector("#boton8").onClick.listen((_)=>add(8));
    div.querySelector("#boton9").onClick.listen((_)=>add(9));
  }
  
  void add(int num){
    var t = text.value.replaceAll("\$", "");
    var n = double.parse(t)*1000;
    n+=num;
    n/=100;
    
    var f = new NumberFormat("###.0#", "en_US");
    text.value=  "\$${f.format(n)}";
  }
  
  void getQR(_){
    Tok3nClient tkn = new Tok3nClient("cb4e4e13-c106-5fec-6b48-788c2a4f29fb",querySelector("body"));
    tkn.addUser();
    tkn.response.then((r)=>responded(r));
    //;
  }
  
  void responded(CustomEvent r){
    var obj = JSON.decode(r.detail);
    var user = obj["UserKey"];
    new Calculadora2(text.value,user);
  }
  
  void cancel(_){
    text.value = "\$0";
  }
}

class Calculadora2{
  String amount;
  String user;
  ImageElement img;
  Calculadora2(this.amount,this.user){
    var container = querySelector("body");
    var div = new Element.html("""
<div>
  <table>
    <tr>
      <td>
        <input type="text" id="text" value="${amount}" />
      </td>
    </tr>
    <tr>
      <td id="pagado">
        
      </td>
    </tr>
  </table>
</div>
""");
    container.nodes.clear();
    container.nodes.add(div);
    img = div.querySelector("#imagen");
    HttpRequest.getString("/ws/addSaldo?user=$user&pago=$amount").then(initted);
  }
  void initted(response){
    querySelector("#pagado").text="The payment has been authorized. Curently whe userhas payed $response in this way";
  }
  void validatedQR(response){
    new Calculator();
  }
}