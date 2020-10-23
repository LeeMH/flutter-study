# MDC-100 Series of Codelabs

## MDC101
로그인 페이지를 만드는 codelab이다.
기본적으로 TextField와 Button의 속성을 배울수 있다.
TextFiled는 TextEditingController와 바인딩되어 사용된다.

아래는 TextField 배치 code이다.
controller 속성을 통해, TextEditingController와 연결한다.
decoration 속성을 통해 place holder등을 설정가능하다.
obscureText를 통해, 마스킹된 입력(패스워드) 속성 설정이 가능하다.
```
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Password',
              ),
              obscureText: true,
            ),
```

버튼은 ButtonBar위에 배치된다.
Row->Column 속성을 사용했을것 같은데, [ButtonBar](https://api.flutter.dev/flutter/material/ButtonBar-class.html)를 사용했다.
문서를 참고하면, end-aligned row of button이라 시작한다.
Row->Column의 조합을 버튼에 일반적인 layout으로 사용할때 편하게 사용하라고 만든 위젯으로 보인다.
NEXT버튼 클릭시 Navigator.pop을 하는데, 이부분이 조금 이상했다.
하지만, main.dart를 보면 이유를 알수 있다.
ShrineApp를 호출하고 HomePage를 호출한다. 이후 login화면을 열게되므로 스택에는 home->login순으로 들어가 있고, pop을 하면 home으로 자연스레 이동하게 된다.
```
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    _usernameController.clear();
                    _passwordController.clear();
                  },
                ),
                RaisedButton(
                  child: Text('NEXT'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
```