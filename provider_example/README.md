# provider_example

flutter 상태 관리에 대한 예제

## Provider

한 위젯에서 공유할 상태(값)은 멤버변수로 처리하면 된다.
하지만, App전체에서 공유할 상태(값)과 갱신시 그에 대한 처리를 하려면 Provider를 이용한다.

전체 구조는 아래와 같다.
* 상태객체 : 상태(값)을 가지고 있는 객체를 말한다. get,set 처리가 되어 있어야 하며, 이 예제에서는 state_simple.dart이다.
* ChnageNotifierProvider : 상태객체를 생성하고, 그에 대한 접근을 제공한다. 이 예제에서는 login_form_demo_v2.dart와 관련있다.
* Provider : 상태객체에 대한 접근과 갱신(write)을 담당한다. 이 예제에서는 page_login.dart와 관련있다.
* Consumer : 상태객체에 대한 접근과 읽기(read)를 담당한다. 이 예제에서는 page_main.dart와 관련있다.


### 상태객체
ChangeNotifier를 확장하고, 상태변수와 getter/setter를 설정하면 된다.
```
class SimpleState extends ChangeNotifier {
  String _email;

  void setEmail(String email) {
    this._email = email;
  }

  String get email => _email;
}
```

### ChangeNotifierProvider
상태객체를 생성하고, 그에 대한 접근을 제공한다.
runApp에서 사용할 상태객체를 create에서 생성하고, child 속성으로 첫 위젯을 선언한다.
여러개의 상태객체가 필요한경우, MultiProvider를 사용하면 된다고 한다. (이건 추후 레퍼런스등을 참고해서 스터디하자!!)
```
void main() => runApp(ChangeNotifierProvider(
      create: (context) => SimpleState(),
      child: StateLoginDemo(),
    ));

```

### Provider
상태 객체에 값을 갱신하는 역할을 한다. 
쉽게 전역(app 전체에)으로 공유되는 상태값에 write 한다고 하면 조금 이해가 빠르다.
책에서는 상태 객체를 가져올때, listen 속성 정의가 없다.
아마 flutter 버젼이 업그레이드 되면서 추가되었거나, 디폴트 속성이 없어졌을 것이다.
```
  void _onLogin(BuildContext context) {
    final String email = _emailController.text;
    final SimpleState state = Provider.of<SimpleState>(context, listen: false);
    state.setEmail(email);

    Navigator.pushNamed(context, MAIN_PAGE);
  }
```

참고로, 2020년 10월 7일 현재 버젼은 아래와 같다.
```
mhlee@pop-os:~/workspace/flutter-study$ flutter --version
Flutter 1.20.3 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 216dee60c0 (5주 전) • 2020-09-01 12:24:47 -0700
Engine • revision d1bc06f032
Tools • Dart 2.9.2
```

### Consumer
상태객체에 대한 접근과 읽기를 담당한다.
상태객체에 값이 변경되면, 소비하는(Consumer) 객체들은 모두 해당 정보를 받고 갱신된다.(고 믿는다. 당연한가..)
Consumer로 감싸서 객체를 생성하고, 그 내부에서 사용하면 된다.
크게 어렵지는 않은데, 좀더 쉬운 방법이 있지 않을까 싶다.
이건 메뉴얼/레퍼런스를 좀 더 참고해보고 업데이트 해보자!!
```
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<SimpleState>(
          builder: (context, state, child) {
            return Text('로그인 완료: ${state.email}');
          },
        ),
      ),
    );
  }
```