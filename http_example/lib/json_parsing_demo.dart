import 'dart:convert';

const String json = '''
{
  "error": {
    "code" : 200,
    "message": "ok"
  },
  "body": {
    "message": "hello",
    "number": 123,
    "boolean": true,
    "float": 12.3
  }
}
''';

void main() {
  var parsed = jsonDecode(json);
  Map<String, dynamic> error = parsed['error'];
  Map<String, dynamic> body = parsed['body'];

  print("error.code = ${error['code']}");
  print("error.message = ${error['message']}");
  print("body.message = ${body['message']}");
  print("body.number = ${body['number']}");
  print("body.boolean = ${body['boolean']}");
  print("body.float = ${body['float']}");
}
