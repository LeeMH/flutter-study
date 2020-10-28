# widget_study

flutter 주요 위젯을 사용법을 샘플을 통해 익혀본다.
예제와 설명은 아래 사이트를 참고한다.
https://api.flutter.dev/flutter/widgets/widgets-library.html


## AppBar
App 상단에 앱의 위치하는 가장 익숙한 위젯이다.
일반적으로 앱의 이름, 현재 페이지의 설명등이 나온다.
또한, 아이콘 버튼을 통해 주요 메뉴로 이동할수 있다.
이허한 이유인지 actions라는 속성이 별도로 존재한다.
에제에서는 IconButton이 추가되고 각각의 버튼은 onPress속성에 이벤트 처리로직을 가지고 있다.
```
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('AppBar Demo'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              //ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            tooltip: 'Next Page',
            onPressed: () {
              openPage(context);
            },
          ),
        ],
      ),
      body: const Center(
          child: Text(
        'This is the home page',
        style: TextStyle(fontSize: 24),
      )),
    );
```


## Stack
여러개의 위젯이 겹쳐지면서 배치되는 형태이다.
child의 가장 위에 위치한 위젯이 바닥이고,
가장 아래 위치한 위젯이 가장 앞이다.
디자인 개념을 잘 몰랐을때는 무슨용도일까 생각했는데,
생각해보면 대부분의 디자인이 각각의 layer를 겹쳐놓은것과 같은 모습이다.

아래의 에제는 
빨간색 안에, 녹색, 그리고 그 안에 파란색이 있는 간단한 에제이다.
```
        body: Stack(
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              color: Colors.red,
            ),
            Container(
              width: 90,
              height: 90,
              color: Colors.green,
            ),
            Container(
              width: 80,
              height: 80,
              color: Colors.blue,
            ),
          ],
```