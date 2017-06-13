package main

import (
	"encoding/json"
	"flag"
	"net/http"
)

type Reponse struct {
	Code   int    `json:"code"`
	Result string `json:"result"`
}

func main() {
	port := flag.String("port", "8000", "Server port")
	flag.Parse()

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		res := Reponse{
			Code:   200,
			Result: "hello world",
		}
		js, err := json.Marshal(res)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		w.Header().Set("Content-Type", "application/json; charset=UTF-8")
		w.WriteHeader(200)
		w.Write(js)
	})

	// Starts the web server
	http.ListenAndServe(":"+*port, nil)
}
