import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class Client {
  final String baseUrl = "https://www.rakwa.com/api/";

  Map<String, String> appHeaders = {
    'Content-Type': "application/json",
    'Accept': "application/json"
  };

  String fullUrl(path) {
    return baseUrl + path;
  }

  Future<http.Response> getPath(String path, {Map<String, String>? headers}) {
    appHeaders.addAll(headers ?? {});

    print("sssssssss" + fullUrl(path));
    print("sssssssss" + appHeaders.toString());
    Uri uri = Uri.parse(fullUrl(path));
    return responseBuilder(http.get(
      uri,
      headers: appHeaders,
    ));
  }

  Future<http.Response> get(String path,
      {Map<String, String>? headers, Map<String, dynamic>? params}) {
    appHeaders.addAll(headers ?? {});

    String url = fullUrl(path).replaceAll("https://", "");
    String subUrl = url;
    List<String> urls = url.split('/');
    String domain = urls[0];
    if (urls.length > 1) {
      subUrl = url.substring(url.indexOf('api'));
    }

    Uri uri = Uri.https(domain, subUrl, params);
    return responseBuilder(http.get(
      uri,
      headers: appHeaders,
    ));
  }

  Future<http.Response> post(String path,
      {Map<String, String>? headers,
      Map<String, dynamic>? body,
      bool isQuery = false}) {
    appHeaders.addAll(headers ?? {});

    print("pmmmmmmost $appHeaders");

    if (isQuery) {
      String url = fullUrl(path).replaceAll("https://", "");
      String subUrl = url;
      List<String> urls = url.split('/');
      String domain = urls[0];
      if (urls.length > 1) {
        subUrl = url.substring(url.indexOf('api'));
      }
      print("post url$domain $subUrl ,$body");
      Uri uri = Uri.https(domain, subUrl, body);
      return responseBuilder(http.post(
        uri,
        headers: appHeaders,
      ));
    } else {
      String url = fullUrl(path);
      Uri uri = Uri.parse(url);
      return responseBuilder(http.post(
        uri,
        headers: appHeaders,
        body: json.encode(body),
      ));
    }
  }

  Future<http.Response> put(String path,
      {Map<String, String>? headers, Map<String, dynamic>? body}) {
    appHeaders.addAll(headers ?? {});

    String url = fullUrl(path);
    Uri uri = Uri.parse(url);
    print('yyyyyyyyyyyy' + body.toString());
    return responseBuilder(http.put(
      uri,
      headers: appHeaders,
      body: json.encode(body),
    ));
  }

  Future<http.Response> delete(String path,
      {Map<String, String>? headers,
      Map<String, dynamic>? body,
      bool isQuery = false}) {
    headers?.addAll(appHeaders);
    if (isQuery) {
      String url = fullUrl(path).replaceAll("https://", "");
      String subUrl = url;
      List<String> urls = url.split('/');
      String domain = urls[0];
      if (urls.length > 1) {
        subUrl = url.substring(url.indexOf('api'));
      }
      Uri uri = Uri.https(domain, subUrl, body);
      return responseBuilder(http.delete(uri, headers: headers));
    } else {
      String url = fullUrl(path);
      Uri uri = Uri.parse(url);
      return responseBuilder(
          http.delete(uri, headers: headers, body: json.encode(body)));
    }
  }

  Future<http.Response> multiPart(String path,
      {String action = "PUT",
      Map<String, String>? headers,
      Map<String, dynamic>? body,
      bool multipart = true,
      Map<String, File> namedFiles = const {},
      List<File> files = const []}) async {
    String url = fullUrl(path);
    Uri uri = Uri.parse(url);

    var request = http.MultipartRequest(action, uri);

    request.headers.addAll(headers ?? {});

    if (multipart) {
      request.headers[HttpHeaders.contentTypeHeader] =
          'multipart/form-data;charset=utf-8;application/json';
    }

    body?.forEach((key, value) {
      if (value != null) request.fields[key] = value.toString();
    });

    print('yyyyyyyyyyyy' + request.fields.toString());

    for (var file in files) {
      final image = await http.MultipartFile.fromPath("image", file.path);
      request.files.add(image);
    }

    namedFiles.forEach((key, mfile) async {
      print('bbbbbbbbbbbbb' + key.toString());

      final file = await http.MultipartFile.fromPath(key, mfile.path);
      request.files.add(file);
    });

    return request.send().then((http.StreamedResponse value) {
      return value.stream
          .bytesToString()
          .then((body) => Future.value(http.Response(body, value.statusCode)));
    });
  }

  Future<http.Response> responseBuilder(Future<http.Response> baseResponse) {
    return baseResponse.onError((error, stackTrace) {
      return Future.value(http.Response("{}", 404));
    }).timeout(
      const Duration(seconds: 60),
      onTimeout: () {
        return http.Response('Time out', 408);
      },
    );
  }
}
