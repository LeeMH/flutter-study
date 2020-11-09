# cloud_firestore_example

cloud_firestore 예제를 실습.
[예제](https://codelabs.developers.google.com/codelabs/flutter-firebase/#0)의 기반으로 작성.


## cloud firestore
cloud firestore는 클라우드로 제공되는 NoSql 스토어이다.
서버 없이, app이나 클라이언트에서 직접 액세스해서 사용할수 있어, 각광(?) 받는것 같다.
복잡한 도메인 로직없는 컨텐츠 베이스의 애플리케이션을 개발하기는 괜찮은 방법같다.

## 사용방법
당연히 의존성을 추가해야 한다.
현재 최신버젼을 추가한다.
```
dependencies:
  flutter:
    sdk: flutter
  cloud_firestore: ^0.13.0+1
```

이후 사용은 아주 간단(?)하다.
안드로이드/iOS 네이브쪽 프로젝트에 간단한 셋팅을 해주면된다.
자세한 내용은 [여기](https://codelabs.developers.google.com/codelabs/flutter-firebase/#6)를 참고하자.
간단하게 요약하면, google-services.json파일을 다운받아 안드로이드 프로젝트에 넣고, 종속성을 추가하는 것이다.
단, 안드로이드 프로젝트에 2개의 gradle파일이 존재한다. 위치를 잘보고 내용을 추가하자.

애플리케이션에서 사용은 아래와 같다.
Firestore의 인스턴스를 통해서 사용할 컬렉션(baby)을 선택하고 정보를 가져오면 된다.
나머지는 빌더를 통해 위젯을 생성하는 로직이다.
sql처럼 단순 where조건도 당연히 있을것 같지만, 이 예제에는 포함되어 있지 않다.
```
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('baby').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }
```

마지막으로 데이터를 갱신하는 로직이 나온다.
DocumentSnapshot으로 데이터를 받고, 여기서는 votes필드를 업데이트하는 내용이다.
votes필드는 숫자형 필드이다.
단순히 record.votes +1 할수도 있지만, 여기서는 FieldValue.increment()메소드를 이용한다.
여러 사용자의 app 인스턴스에 공유된 값의 원자성을 보호할수 있는 방법인듯 하다.
```
  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
            title: Text(record.name),
            trailing: Text(record.votes.toString()),
            onTap: () => record.reference
                .updateData({'votes': FieldValue.increment(1)})),
      ),
    );
  }
}
```

