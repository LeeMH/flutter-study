# netflix clone 인프런 강의

인프런의 [넷플릭스 클론](https://www.inflearn.com/course/flutter-netflix-clone-app) 강의를 정리

## lecture1

넷플릭스의 UX의 기본 뼈대를 만든다.

### 폴더구조
* model : 데이터의 구조와 통신관련된 소스를 모아둔다.
* screen : 각각의 화면을 모아둔다.
* widget : 재사용 할수 있는 단위 위젯(컴포넌트)을 모아둔다.

### 소스 설명
크게 TabView와 하단 TabBar로 구성된 UX이다.

home속성에 DefaultTabController를 생성하였고,
length의 값은 4로 4개의 페이지로 구성된다.
4개의 페이지는 children의 속성으로 들어가는데, 우선은 빈컨테이너만 생성해 넣는다.
특이점은 physics의 NeverScrollableScrollPhysics이다.
스크롤을 통해 이동되지 않도록 하는 속성이며, 하단 bottomNavigation 버튼을 통해 이동하도록 진행한다.
```
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netflix clone',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        accentColor: Colors.white,
      ),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Container(),
              Container(),
              Container(),
              Container()
            ],
          ),
          bottomNavigationBar: Bottom(),
        ),
      ),
    );
  }
```

TabController는 StatefulWidget임에도 불구하고, setState를 설정하는 내용은 없다.
일단 구조를 보면, ChangeNotifier를 상속했으며, TabBar를 통해 상태가 관리된다고 나온다.
암묵적으로 TabBar를 통해 상태가 자동갱신되는 셋트상품 같은 구조인것 같다.
자세한 내용은 문서등을 참조하면서 업데이트 하자.


## lecture2

홈화면을 만든다.
우선 상단의 Netflix로고와 TV프로그램, 내가찜한 컨텐츠, 영화 메뉴를 생성한다.

### 상단 로고 이미지
이미지는 pubspec.yaml에 미리 선언해 두어야 한다.
아래 예시에서는 root/images 폴더를 생성하고 그안에 bbongflix_logo.png를 넣었다.
```
  # To add assets to your application, add an assets section, like this:
  assets:
    - images/bbongflix_logo.png
  #   - images/a_dot_ham.jpeg
```
사용은 Image.asset를 이용한다.
```
          Image.asset(
            'images/bbongflix_logo.png',
            fit: BoxFit.contain,
            height: 25,
          ),
```

### 상단바(TobBar) UX 구조
Container안에 Row로 Widget이 배치되는 구조이며, 안정적인 view를 위해 mainAxisAlignment: MainAxisAlignment.spaceBetween 속성을 사용해 각각의 Row 아이템을 배치하였다.

또한, 상단바는 Home화면에서만 사용되므로 별도의 widget으로 분리하지 않고, home_screen파일안에 구현하였다.