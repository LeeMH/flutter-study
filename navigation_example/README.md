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

## 동적 routes 활용 : onGenerateRoutes

새로운 화면으로 넘어갈때 파라메터를 넘겨주어야 할때가 있다.
이럴때 동적 routes를 활용해서 파라메터는 넘겨줄수 있다.

우선 전체적인 구조는 아래와 같다.
* contact_demo_v3 : 메인메소드가 있는 첫번째 위젯이다. 로딩후 바로 page_contact_list를 출력
* page_contact_list : 주소록의 내용을 출력하는 위젯. onTap 메소드에 이동할 route 정보가 설정되어 있다.
* page_contact_detail : 주소록의 상세 내용을 출력하는 위젯. 파라메터로 전달된 Contact 정보를 출력한다.

우선 동적 route 설정을 본다. (contact_demo_v3)
onGenerateRoute 항목을 이용해서 설정하고, settings.name 즉, 라우팅 경로가 ContactDetailPage와 일치한다면 ContactDetailPage 위젯을 리턴한다.
이때 파라메터로 c 즉, 직전화면에서 넘어온 파라메터를 같이 넘겨준다.
```
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ContactListPage(),
      onGenerateRoute: (RouteSettings settings) {
        if (ContactDetailPage.routeName == settings.name) {
          Contact c = settings.arguments;
          return MaterialPageRoute(builder: (context) => ContactDetailPage(c));
        }

        return _noWay;
      },
    );
```

이번에는 Contact를 넘겨주는 page_contact_list 구조를 보자.
ListTile을 만들면서 onTap이벤트에 Navigator push 내용이 정의된다.
(난 왜 tap을 자꾸 tab이라고 칠까?? 매번 오타로 에러다!!)
pushNamed를 사용하며, 당연히 경로는 ContactDetailPage.routeName을 사용해서 detail 페이지로 넘어감을 나타낸다.
이때 arguments를 통해서 c 즉, 선택된 주소를 넘겨준다.
이정보는 위 설명에서 setting.arguments에 설정된다.
```
  Widget _buildRow(BuildContext context, int ii) {
    Contact c = _contacts.elementAt(ii);

    return ListTile(
        leading: (c.avatar != null && c.avatar.length > 0)
            ? CircleAvatar(
                backgroundImage: MemoryImage(c.avatar),
              )
            : CircleAvatar(
                child: Text(c.initials()),
              ),
        title: Text(c.displayName ?? ''),
        onTap: () => Navigator.pushNamed(
              context,
              ContactDetailPage.routeName,
              arguments: c,
            ));
  }
```

마지막으로 이벤트의 마지막으로 열리는 page_contact_detail 내용을 보자.
자기 자신의 route 경로가 static 변수로 선언되어 있다.
그리고, 파라메터로 넘어올 Contact를 받을 _contact가 선언되어 있고, 당연히 생성자도 선언되어 있다.
넘어온 Contact의 상세 정보만 출력할뿐, 내용에 대한 갱신은 없기 때문에 StatelessWidget으로 정의된다.
```
  static const String routeName = '/contact';

  final Contact _contact;

  ContactDetailPage(this._contact);

```


## Permssion 관련
서버 사이드 개발자이기 때문에 앱개발에 능숙하지 않다.
특히, 안드로이드/iOS 기기/프레임워크에 종속된 내용은 아직 익숙치 않다.
다행히 Permission 관련된 내용은 잘 정리(라이브러리화) 되어 있다.
Permisson이 필요한 위젯의 생성자에서는 async/await를 사용해서 반드시 permisson을 확득하고 다음으로 넘어가자.
만약 이부분을 놓치면, 앱이 그냥 죽어 버리고 statck trace에 permisson 관련된 에러를 보게된다.

```
void initState() {
    super.initState();
    _checkPermission();
  }

  _checkPermission() async {
    await PermissionHandler().requestPermissions([PermissionGroup.contacts]);
    _refreshContacts();
  }
```

