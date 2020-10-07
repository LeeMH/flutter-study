# http_example

rest api 호출을 위한 http 사용법과 json 사용법을 배운다.

## 필요 라이브러리

http 사용을 위해서는 http 라이브러리 추가가 필요하다.
pubspec.yaml 파일에 아래 라이브러리를 추가
```
dependencies:
  flutter:
    sdk: flutter
  http: ^0.12.0+2
```

json 파싱을 위해서는 dart:convert 라이브러리 import가 필요하다.
http는 as를 사용해 http라는 별칭을 사용할수 있게 했다.
```
import 'package:http/http.dart' as http;
import 'dart:convert';
```

### json 파싱
jsonDecode(json_string) 메소드를 사용해 Map형태로 사용가능하다.

```
Map<String, dynamic> data = jsonDecode(response.body);
```
