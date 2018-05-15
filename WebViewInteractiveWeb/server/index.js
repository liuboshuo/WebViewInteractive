var express = require("express");
var app = express();
var path = require("path");

app.get("/wKWebView",function (request,response) {
    response.sendFile(path.resolve("web/wKWebView.html"))
})

app.get("/webView",function (request,response) {
    response.sendFile(path.resolve("web/webView.html"))
})

app.listen(3001);