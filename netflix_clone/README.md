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


## lecture3

홈화면을 구성할 Movie 클래스를 생성한다.
Movie자체가 가진 속성(title, keyword, poster, like)를 클래스로 묶어서 관리한다.
data와 관련된 소스는 model 폴더에 묶어서 관리한다.
```
class Movie {
  final String title;
  final String keyword;
  final String poster;
  final bool like;

  Movie.fromMap(Map<String, dynamic> map)
      : title = map['title'],
        keyword = map['keyword'],
        poster = map['poster'],
        like = map['like'];

  @override
  String toString() => "Movie<$title:$keyword>";
}
```


## lecture4

홈화면 UX를 실제로 구성한다.
한개의 화면이지만, 여러개의 layout과 widget으로 구성되어 복잡하게 느껴질수 있다.

우선 홈화면은 ListView > Stack이 놓여진 모습이다.
상단에 TopBar가 나타나고, CarouselImage 위젯이 그 아래 나타난다.
CarouselImage에서 출력될 정보는 전 강의에서 정의된 Movie가 List형태로 전송된다.
```
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Stack(
          children: <Widget>[
            CarouselImage(movies: movies),
            TopBar(),
          ],
        )
      ],
    );
  }
```

CarouselImage는 당연히 StatefulWidget이다.
상태 클래스(CarouselImageState)에서 StatefulWidget(CarouselImage)의 속성정보 접근은 widget.썸씽 형태로 접근한다.
아래는 movies라는 상태를 StatefulWidget에서 가져오는 방법과, 각각의 항목들을 매핑하는 예제이다.
```
class _CarouselImageState extends State<CarouselImage> {
  List<Movie> movies;
  List<Widget> images;
  List<String> keywords;
  List<bool> likes;
  int _currentPage = 0;
  String _currentKeyword;

  @override
  void initState() {
    super.initState();
    movies = widget.movies;
    images = movies.map((m) => Image.asset('./images/' + m.poster)).toList();
    keywords = movies.map((m) => m.keyword).toList();
    likes = movies.map((m) => m.like).toList();
    _currentKeyword = keywords[0];
  }
```

실제 UX영역은 아래와 같은 구조로 되어있다.
우선 세로로 widget들이 배치되므로, Column으로 선언되어 있다.
이후 아래와 같은 구성으로 분포되어 있다.
* Padding (공백)
* CarouselSlider (슬라이드 형식으로 배치될 이미지)
* Container.Text (keyword 출력용 widget)
* Container.Row.Buttons (하단의 기능 버튼)
* Container.Row.Indicator (슬라이더 페이지를 나타낼 인디케이터)

실제로 눈에 보여지는 영역이 어떠한 식으로 배치되어야 하는지 감잡기 좋은 샘플이라고 생각된다.