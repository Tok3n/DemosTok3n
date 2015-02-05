package app

import (
	"net/http"
	"fmt"
	"strconv"

	"appengine"
	"appengine/datastore"
)

func init(){
	http.HandleFunc("/", rootWS)
	http.HandleFunc("/_ah/warmup",warmup_method)
	http.HandleFunc("/ws/addSaldo",addSaldo)
	http.HandleFunc("/ws/addCoupon",addCoupon)
}

func warmup_method(w http.ResponseWriter, r *http.Request) {
    c := appengine.NewContext(r)
    c.Infof("OK")
}

func rootWS(w http.ResponseWriter, r *http.Request) {
	http.Redirect(w, r, "/dashboard", http.StatusMovedPermanently)
}

type Pago struct {
    User string
    Pagado float64
}
type Cupon struct {
    User string
    Tipo string
}
func addSaldo(w http.ResponseWriter, r *http.Request){
	user_str := r.FormValue("user")
	pago_str := r.FormValue("pago")
	if user_str == "" || pago_str == ""{
		fmt.Fprintf(w,"ERROR")
		return
	}

	pago, _ := strconv.ParseFloat(pago_str[1:], 64)

	c := appengine.NewContext(r)
	q := datastore.NewQuery("Pago").Filter("User = ",user_str)

	count, _ := q.Count(c)

	if count >0{
		t := q.Run(c)
		var x Pago
        key, _ := t.Next(&x)
        x.Pagado = x.Pagado + pago

        datastore.Put(c,key,&x)
        fmt.Fprintf(w,"%f",x.Pagado)
	}else{
		var x Pago
		x.User = user_str
		x.Pagado = pago
        
        key := datastore.NewIncompleteKey(c,"Pago",nil)

        datastore.Put(c,key,&x)
        fmt.Fprintf(w,"%f",x.Pagado)
	}
}

func addCoupon(w http.ResponseWriter, r *http.Request){
	user_str := r.FormValue("user")
	pago_str := r.FormValue("kind")
	if user_str == "" || pago_str == ""{
		fmt.Fprintf(w,"ERROR")
		return
	}

	c := appengine.NewContext(r)
	q := datastore.NewQuery("Cupon").Filter("User = ",user_str).Filter("Tipo = ",pago_str)

	count, _ := q.Count(c)

	if count >0{
		
        fmt.Fprintf(w,"EXISTE")
	}else{
		var x Cupon
		x.User = user_str
		x.Tipo = pago_str
        
        key := datastore.NewIncompleteKey(c,"Cupon",nil)

        datastore.Put(c,key,&x)
        fmt.Fprintf(w,"BIEN")
	}
}

func clearCoupons(w http.ResponseWriter, r *http.Request ){
	user_str := r.FormValue("user")
	if user_str == ""{
		fmt.Fprintf(w,"ERROR")
		return
	}
	c := appengine.NewContext(r)
	q := datastore.NewQuery("Cupon").Filter("User = ",user_str).Filter("Tipo = ","1")
	var x []Cupon
	keys, _ := q.GetAll(c,&x)
	for i := range keys{
		datastore.Delete(c,keys[i])
	}
}



