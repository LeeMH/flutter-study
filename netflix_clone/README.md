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
ListView는 스크롤되는 위젯이다. 
디폴트 스크롤 속성이 vertical이라 별도의 속성 정의는 없다.

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


## lecture5

홈화면 하단의 CircleSlider와 BoxSlider를 추가한다.
기본적으로 메커니즘은 동일하고, 홈화면의 movies 속성을 받아 ListView에 이미지를 출력한다.

간단한 위젯이지만 배치는 한번 곰곰히 생각하고 감잡아볼 필요가 있다.
우선 Column으로 배치가된다.
당연하겠지만, 상단에 Text로 미리보기가 들어가고, 그 하단에 List가 들어간다.
List는 Column의 자식으로 직접들어갈수가 없기 때문에, Container로 감싸서 들어간다.
즉, Column > Container > ListView 의 형식으로 들어간다.
추가로, 스크롤이 가로로 되어야 하기 때문에 scrollDirection 속성을 적용한다. (디폴트는 세로)
```
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('지금 뜨는 컨텐트'),
          Container(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: makeBoxImages(movies),
            ),
          ),
        ],
      ),
    );
  }
```

ListView의 자식들은 클릭 이벤트가 있기때문에 역시 Image만 들어가는 것은 아니다.
InkWell 위젯을 이용해서 물결퍼짐 효과와 tap이벤트를 정의하고,
이미지는 다시 Container를 통해 배치된다. 이때 다시 이미지는 Align으로 한번더 감싸서 넣는다.
미세한 영역의 공백, 정렬등에 따라서 위젯이 중복되므로 상당히 복잡하게 느껴지고도 하지만, 이러한 메타 정보가 없으면 일관된 렌더링이 안되기때문에 우선은 최대한 적응하려 한다.
```
List<Widget> makeBoxImages(List<Movie> movies) {
  List<Widget> results = [];

  for (var ii = 0; ii < movies.length; ii++) {
    results.add(
      InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.only(right: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Image.asset('images/' + movies[ii].poster),
          ),
        ),
      ),
    );
  }

  return results;
}
```


## lecture6

상세화면을 출력한다.

우선 home화면에서 detail화면으로 넘어가는 이벤트 처리이다.
기존에 구현된 IconButton의 onPressed 버튼 이벤트를 구현한다.
이때, 상세화면에서 출력될 영화정보 movie를 넘겨주어야 한다.
```
                      IconButton(
                        icon: Icon(Icons.info),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<Null>(
                                fullscreenDialog: true,
                                builder: (BuildContext context) {
                                  return DetailScreen(
                                    movie: movies[_currentPage],
                                  );
                                }),
                          );
                        },
                      ),
```

상세화면을 보면 SafeArea라는 낯선 위젯이 하나 보인다.
자세한 내용은 좀더 살펴봐야 겠지만, 기기별로 화면이 깨지는 현상을 방어해주는 위젯같다.
특히 Stack을 사용했을경우, 이러한 현상이 발생하는 듯한 글이 보인다.
참조 : https://clein8.tistory.com/entry/Flutter-Widget-01-SafeArea

그리고, ListView를 통해 각각의 레이어들이 배치된다.

이후 구성은 앞의 강의와 크게 다르지 않다.
다만, blur처리등 좀더 세련된(?) 처리가 들어간다.
눈으로 볼때는 1차원 평면이지만, 각각의 작은 항목조차도 위젯이 계속 배치되면서 상당히 복잡하게 느껴진다.
아마, 기본적인 위젯 사용법을 뛰어넘고 바로 실습예제를 따라 하기 때문에 더욱 그렇게 느껴질것이라고 생각된다.

디자인적인 부분은 개별위젯을 얼마나 잘 이해하고, 이를 얼마나 잘 배치하면서 사용하냐에 따라 상당한 품질 차이가 날것이라 생각된다.
