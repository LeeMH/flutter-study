# location_example

위치정보를 구하고 출력하는 예제

## geolocator 라이브러리

channel 프로그램을 통해 위경도 좌표를 구할수 있으나,
[geolocator 라이브러리](https://pub.dev/packages/geolocator/versions/5.3.2+2)를 이용해서 출력하도록 간단하게 구현

### 퍼미션 설정
기기 자원에 접근하기 위해서는 퍼미션 설정이 되어야 한다.
퍼미션 설정 역시 잘 만들어진 [라이브러리](https://pub.dev/packages/permission_handler/versions/4.0.0)를 이용한다.

우선 AndroidManifest.xml에 필요한 권한을 추가한다.
```
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

사용시점에 async/await를 사용하여 퍼미션을 획득하고 진행한다.
```
  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  _checkPermissions() async {
    await PermissionHandler().requestPermissions([PermissionGroup.location]);
  }
```


### 위치정보 사용
geolocator 라이브러리를 이용하여 간단하게 위경도 좌표를 구할수 있다.
```
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      String result = "(${position.latitude}, ${position.longitude})";
      _newText = '현재 위치는 $result ';
    } on PlatformException {
      _newText = '현재 위치를 사용할 수 없습니다.';
    }
```