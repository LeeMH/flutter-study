# navigation_example

flutter 화면이동에 대한 예제

## Navigator

stack과 같이 동작하며, push와 pop 메소드가 있다.
새로운 화면으로 이동할때는 push를 통해 화면을 전환.
```
  _showNextPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NextPage()));
  }
```

이전버튼이나 돌아오기 버튼을 클릭하면 pop메소드를 호출
```
  _backToMainPage(BuildContext context) {
    Navigator.pop(context);
  }
```

## Routes를 활용한 Navigator

방식은 Navigator와 동일하지만, 미리 정해진 routes를 통해 이동한다.
routes는 첫번째 화면의 widget이 생성될때 선언한다.
initialRoute를 통해, 첫화면으로 출력될 route경로를 선언한다.
```
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/next': (context) => NextPage(),
      },
    );
  }
```

이동은 동일하게 navigator에 push를 하면된다.
단, push메소드의 명칭이 pushNamed 이다.
```
  _showNextPage(BuildContext context) {
    Navigator.pushNamed(context, '/next');
  }
```
