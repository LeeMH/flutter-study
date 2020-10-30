# font_example

폰트를 적용하는 방법을 알아보자.

## font적용 방법

font적용방법은 [공식문서]](https://flutter.dev/docs/cookbook/design/fonts)에 잘나와 있다.
우선 pubspec.yaml화일에 fonts 부분을 수정하면 된다.
root디렉토리/fonts 폴더를 만들고 다운받은 NotoSansKr 폰트를 넣었다.

```
  fonts:
    - family: NotoSansKR
      fonts:
        - asset: fonts/NotoSansKR-Black.ttf
        - asset: fonts/NotoSansKR-Bold.ttf
        - asset: fonts/NotoSansKR-Light.ttf
        - asset: fonts/NotoSansKR-Medium.ttf
        - asset: fonts/NotoSansKR-Regular.ttf
        - asset: fonts/NotoSansKR-Thin.ttf
```

실제 사용은 테마에서 font familly를 설정하고, TextStyle을 통해 사용될 폰트속성을 지정하는 방식으로 사용한다.

아래는 NotoSansKR을 사용한다는 테마데이터 설정이다.
```
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'NotoSansKR',
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
```

아래는 실제 사용될 Text에 대한 TextStyle 설정이다.
```
            Text(
              '누른 버튼 횟수:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
```

간단하게 둘러본 font설정이다.
공식문서 font다음이 바로 [테마 설정관련](https://flutter.dev/docs/cookbook/design/themes)이다.
디자인적인 요소를 잘 모르지만, 프로젝트 초기에 테마설정을 UX 담당자와 협업하여 빠르게 정의하고,
실제 개별 화면,도메인에서는 동일한 look & feel을 주는 방식으로 하면 상당히 효과가 좋을것 같다.