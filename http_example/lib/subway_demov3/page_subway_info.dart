import 'package:flutter/material.dart';
import 'model/subway_arrival.dart';
import 'api/subway_api.dart' as api;

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  TextEditingController _stationController =
      TextEditingController(text: api.DEFAULT_STATION);
  List<SubwayArrival> _data = [];
  bool _isLoading = false;
  //SubwayArrival subwayArrival;

  List<Card> _buildCards() {
    print('>>> _data.length ? ${_data.length}');

    List<Card> res = [];
    if (_data.length == 0) {
      return res;
    }

    for (SubwayArrival info in _data) {
      Card card = Card(
        child: Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 11,
              child: Image.asset(
                'images/icon/subway.jpg',
                fit: BoxFit.fitHeight,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      info.trainLineName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      info.arvlMsg2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

      res.add(card);
    }

    return res;
  }

  @override
  void initState() {
    super.initState();
    _getInfo();
  }

  _onClick() {
    print('클릭 이벤트 발생');
    _getInfo();
  }

  _getInfo() {
    setState(() {
      _isLoading = true;
    });

    String station = _stationController.text;
    api.httpGet(station).then((value) => {
          setState(() {
            _data = value;
          })
        });

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('지하철 실시간 정보'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  child: Row(
                    children: <Widget>[
                      Text('역이름'),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 150,
                        child: TextField(
                          controller: _stationController,
                        ),
                      ),
                      Expanded(
                        child: SizedBox.shrink(),
                      ),
                      RaisedButton(
                        child: Text('조회'),
                        onPressed: _onClick,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text('도착정보'),
                ),
                SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: _buildCards(),
                  ),
                )
              ],
            ),
    );
  }
}
