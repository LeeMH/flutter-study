import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/subway_arrival.dart';

const String URL_PREFIX = 'http://swopenapi.seoul.go.kr/api/subway/';
const String USER_KEY = 'sample';
const String URL_SUFFIX = '/json/realtimeStationArrival/0/5/';
const String DEFAULT_STATION = '광화문';
const int STATUS_OK = 200;

String _buildUrl(String station) {
  StringBuffer sb = StringBuffer();
  sb.write(URL_PREFIX);
  sb.write(USER_KEY);
  sb.write(URL_SUFFIX);
  sb.write(station);

  print(sb.toString());

  return sb.toString();
}

Future<List<SubwayArrival>> httpGet(String station) async {
  List<SubwayArrival> res = [];

  var response = await http.get(_buildUrl(station));
  String responseBody = response.body;
  print(responseBody);

  var json = jsonDecode(responseBody);
  Map<String, dynamic> errorMessage = json['errorMessage'];

  if (errorMessage == null || errorMessage['status'] != STATUS_OK) {
    return Future.value(res);
  }

  List<dynamic> realtimeArrivalList = json['realtimeArrivalList'];
  final int cnt = realtimeArrivalList.length;

  res = List.generate(cnt, (int ii) {
    Map<String, dynamic> item = realtimeArrivalList[ii];
    return SubwayArrival(item['rowNum'], item['subwayId'], item['trainLineNm'],
        item['subwayHeading'], item['arvlMsg2']);
  });

  return Future.value(res);
}
