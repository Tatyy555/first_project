import 'package:flutter/material.dart';
import 'package:first_project/newslistpage.dart';


// ログイン画面用Widget
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // メッセージ表示用
  String infoText = '';
  // 入力したメールアドレス・パスワード
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // メインロゴ
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  children:const <Widget>[
                    // いい感じの余白を挿入する。
                    Text('',
                      style: TextStyle(
                        fontSize: 10,
                      )
                    ),
                    Text('NEWS',
                      style: TextStyle(
                        fontSize: 50,
                        color: Colors.white, 
                      ),
                    ),
                    Text('LOG',
                      style: TextStyle(
                        fontSize: 50,
                        color: Colors.white, 
                      ),
                    ),
                  ]
                )
              ),  

              // いい感じの余白を挿入する。
              const Text('',
                style: TextStyle(
                  fontSize: 30,
                )
              ),

              // メールアドレス入力
              TextFormField(
                decoration: const InputDecoration(labelText: 'メールアドレス'),
                onChanged: (String value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              // パスワード入力
              TextFormField(
                decoration: const InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              Container(
                padding: const EdgeInsets.all(8),
                // メッセージ表示
                child: Text(infoText),
              ),
              Row(
                // 余白を均等に並べる。
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:<Widget>[
                  SizedBox(
                    width: 120,
                    // ログイン登録ボタン
                    child: OutlinedButton(
                      child: const Text('ログイン'),
                      onPressed: () async {

                        // 一旦、ログイン画面を押すとニュースリスト画面に遷移するようにしました。
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> const NewsListPage())
                        );


                        // // firbaseを導入してから着手する。
                        // try {
                        //   // メール/パスワードでログイン
                        //   final FirebaseAuth auth = FirebaseAuth.instance;
                        //   final result = await auth.signInWithEmailAndPassword(
                        //     email: email,
                        //     password: password,
                        //   );
                        //   // ログインに成功した場合
                        //   // チャット画面に遷移＋ログイン画面を破棄
                        //   await Navigator.of(context).pushReplacement(
                        //     MaterialPageRoute(builder: (context) {
                        //       return ChatPage(result.user!);
                        //     }),
                        //   );
                        // } catch (e) {
                        //   // ログインに失敗した場合
                        //   setState(() {
                        //     infoText = "ログインに失敗しました：${e.toString()}";
                        //   });
                        // }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    // ユーザー登録ボタン
                    child: ElevatedButton(
                      child: const Text('ユーザー登録'),
                      onPressed: () async {
                        // // firebaseを導入してから着手する。
                        // try {
                        //   // メール/パスワードでユーザー登録
                        //   final FirebaseAuth auth = FirebaseAuth.instance;
                        //   final result = await auth.createUserWithEmailAndPassword(
                        //     email: email,
                        //     password: password,
                        //   );
                        //   // ユーザー登録に成功した場合
                        //   // チャット画面に遷移＋ログイン画面を破棄
                        //   await Navigator.of(context).pushReplacement(
                        //     MaterialPageRoute(builder: (context) {
                        //       return ChatPage(result.user!);
                        //     }),
                        //   );
                        // } catch (e) {
                        //   // ユーザー登録に失敗した場合
                        //   setState(() {
                        //     infoText = "登録に失敗しました：${e.toString()}";
                        //   });
                        // }
                      },
                    ),
                  ),
                ]
              )
            ],
          ),
        ),
      ),
    );
  }
}