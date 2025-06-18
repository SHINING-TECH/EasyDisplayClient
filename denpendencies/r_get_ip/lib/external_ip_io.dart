import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<String> getExternalIp() async {
  Completer<String> result = Completer();
  HttpClient client = HttpClient();
  client
      .getUrl(Uri.parse("https://api.ipify.org/?format=json"))
      .then((HttpClientRequest request) {
    // Optionally set up headers...
    // Optionally write to the request object...
    // Then call close.
    return request.close();
  }).then((HttpClientResponse response) {
    // Process the response.
    response.transform(utf8.decoder).listen((event) {
      final map = json.decode(event);
      result.complete(map['ip']);
    });
  });
  return result.future;
}
