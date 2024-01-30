import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:peanut/network/url.dart';

class Request{
  final String url;
  final dynamic body;
  final dynamic header;

  Request({required this.url,this.body,this.header});

  Future<http.Response> get(){
    print(urlBase+url);
    return http.get(Uri.parse(urlBase+url),headers: header).timeout(Duration(seconds: 30));
  }
  Future<http.Response> post() {
    return http.post(Uri.parse(urlBase+url),headers: header, body: body).timeout(Duration(seconds: 30));
  }

  Future<http.Response> delete(){
    print(urlBase+url);
    return http.delete(Uri.parse(urlBase+url),headers: header).timeout(Duration(seconds: 30));
  }



}
