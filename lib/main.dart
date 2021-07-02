import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as httpClient;
import 'package:http/http.dart';
import 'package:flutter/services.dart';

/*
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
*/
Future<List<HttpResponseObject>> sendRequest(String urlRequest,String requestType,dynamic inputJsonObject) async {
  var response ;
  String responseList = '';
  if(requestType!=null){
    if(requestType=="GET"){
      //var urlRequestString = Uri.parse(urlRequest);
      //response = await httpClient.get(urlRequestString);
      //----------------------------------------------------------------------
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      HttpClientRequest request = await client.getUrl(Uri.parse(urlRequest));
      request.headers.set('content-type', 'application/json');
      //request.add(utf8.encode(json.encode(map)));
      HttpClientResponse response = await request.close();
      //print(response.statusCode);
      responseList = await response.transform(utf8.decoder).join();
      //String reply = await response.transform(utf8.decoder).join();
      print(responseList);
      //----------------------------------------------------------------------

    }else  if(requestType=="POST"){
      var urlRequestString = Uri.parse(urlRequest);
      response = await httpClient.post(
          urlRequestString, body: /* {"email":"test2@liferay.com","password":"test2Liferay","returnSecureToken":"true"}*/inputJsonObject
        //,headers: {HttpHeaders.contentTypeHeader: "application/json"
        //, HttpHeaders.contentEncodingHeader: "UTF-8"
        //    }
      );
    }
  }
  List<HttpResponseObject> result=[];
  try {
    List<dynamic> mapResult = jsonDecode(responseList);
    List<Map<String, dynamic>>? mapResultDynamic= (mapResult).map((e) => e as Map<String, dynamic>)?.toList();
    print(mapResultDynamic);
    mapResultDynamic!.forEach((element) {
      HttpResponseObject elemTmp=HttpResponseObject.fromJson(element);
      print(elemTmp);
      result.add(elemTmp);
    });
  } catch (e) {
    print(e.toString());
    result=[];
    return result;
  }
  return result;
}

class HttpResponseObject {
  final String idToken;
  HttpResponseObject({required this.idToken});
  factory HttpResponseObject.fromJson(Map<String, dynamic> json) {
    return HttpResponseObject(
        idToken: json['idToken']
    );
  }
}


void main() {
  //HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
  /*
  String url = 'https://192.168.60.106:5001/WeatherForecast';
  HttpClient client = new HttpClient();
  client.badCertificateCallback =
  ((X509Certificate cert, String host, int port) => true);
  HttpClientRequest request = await client.getUrl(Uri.parse(url));
  request.headers.set('content-type', 'application/json');

  HttpClientResponse response = await request.close();

  String reply = await response.transform(utf8.decoder).join();

  */

}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Demo';

    return MaterialApp(
      title: appTitle,
      home: null,
    );
  }
}

