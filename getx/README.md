# getx

flutter 상태관리 라이브러리 getx에 대해서 정리한다.


## Getting Started
getx는 flutter에서 가장 인기있는 상태관리 라이브러리중 하나이다.

자세한 내용은 아래 pub.dev 사이트 문서를 참고한다.

https://pub.dev/packages/get


## 설치
pubspec.yaml 파일에 라이브러리 추가를 하고,
flutter pub get을 한번 실행하면 OK
```
dependencies:
  get: ^3.15.0
```


## 상태관리
우선 상태관리가 필요한 경우, StatefulWidget을 상속받고, State 를 상속받는 클래스 이렇게 2개를 구현하는것이 공식이다.
getx는 이 작업을 드라마틱하게 간결하게 처리한다.
공식문서 설명에 보면, 간결하면서도 성능상 문제없을정도로 훌룡한 퍼포먼스를 낸다는 설명도 어디즈음 있다.

간단한 아래 샘플을 보자.

우선 특이한점은 Home이 StatelessWidget이다.
즉, 상태(값)의 변화에 따라 화면 갱신이 불가능하다.
하지만, 변경된 상태가 계속 반영된다.

이유는 Obx() 객체에 있다.
해당 객체안에서 관리되는 상태갑을 사용하면 자동으로 갱신된다.(마치 setState메소드를 호출한것 처럼.)
이렇게 관리되는 변수는 .obs를 붙여서 명시적으로 관리됨을 나타낸다.

```
void main() => runApp(MaterialApp(home: Home()));

class Home extends StatelessWidget {
  var count = 0.obs;
  @override
  Widget build(context) => Scaffold(
      appBar: AppBar(title: Text("counter")),
      body: Center(
        child: Obx(() => Text("$count")),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => count ++,
      ));
}
```

## 전역상태관리
위 예제는 하나의 클래스안에서 사용되는 상태갱신에 대해 다루었다.
즉, StatefulWidget 사용을 좀더 간결하게 해주었다고 생각할수 있다.
하지만, App 여러 화면에서 혹은 화면과 화면 이동에서 값을 주고 받으려면, 서로 상태를 공유하려면 어떻게 해야 할까?
많은 방법론이 있고, 다양한 패턴이 존재하는것으로 알고 있다.
getx에서는 아주 간단한 해결책을 제시한다.

GetxController를 상속받은 클래스를 선언하면, App의 모든 화면에서 상태(값)에 접근 가능하다.
```
class Controller extends GetxController {
  var count = 0;
  void increment() {
    count++;
    update();
  }
}
```
참고로, 변수에 .obs를 붙여주면 상태관리가 된다는 명시적인 선언이다.
이러한 경우, update() 메소드를 호출하지 않아도 자동 갱신된다.


## 페이지 전환에서 상태관리
실제 App을 개발하면, 화면과 화면 전환에서 상태를 주고 받는 일이 많을것이다.
교재나 문서에는 Provider를 사용해서 변경하고 그를 감지하는 번거로운 방법이 주로 사용된것 같다.
하지만, getx에서는 이를 드라마틱하게 해결하는것 같다.

우선 getx를 사용하기 위해서는 MaterialApp이 아닌 GetMaterialApp을 사용해야 한다.
```
void main() => runApp(GetMaterialApp(home: Sample2()));
```

우선 Sample2라는 화면에서 전역상태를 관리하는 컨트롤러를 Get프레임워크(?)로 넣어준다.
이 화면에서만 사용된다면, 이럴 필요가 없지만, 다른 화면으로 전환시 Get프레임 워크에서 관장하는 컨트롤러를 공유하기 위함인것으로 추측된다.
```
class Sample2 extends StatelessWidget {
  final controller = Get.put(Controller());
```

우선 컨트롤러의 값(상태)를 실시간으로 갱신하기 위해서는 Obs() 객체 안에서 구현하거나,
GetBuilder<Controller>(), GetX<Controller>() 객체 안에서 구현해야 한다.
개인적으로 GetX<Controller>가 가장 마음에 들어 해당 방식을 주로 사용한다.
```
            GetX<Controller>(
                builder: (_) => Text(
                      'clicks: ${controller.count}',
                    )),
```


이제 화면 전환이다.
Navigator를 사용하는 대신 Get을 사용한다.
간단하게 이동한 화면을 넣고 Get.to()하면 된다.
```
            RaisedButton(
              child: Text('Next Route'),
              onPressed: () {
                Get.to(Second());
              },
            ),
```

Second화면에서 해당값을 사용하는 예제이다.
Get.find()를 통해 컨트롤러를 구해오고, ctrl.count 형식으로 값을 사용하면된다.
위에서는 GetX를 통해 사용했는데, 여기서는 그냥 사용한다.
차이는 GetX를 사용하면 StatefulWidget에서 setState()한 효과와 동일하다.
Second 위젯에서는 counter값을 출력하고 변경할 일은 없기때문에, 그냥 사용했다.(StatelessWidget과 같은형식)
```
class Second extends StatelessWidget {
  final Controller ctrl = Get.find();
  @override
  Widget build(context){
     return Scaffold(body: Center(child: Text("${ctrl.count}")));
  }
}
```