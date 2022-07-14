// Material Components widgetsを利用。
import 'package:flutter/material.dart';
// 他ファイルのプログラムを利用。
import 'package:first_project/view/item_list_page.dart';
import '../constants.dart';
import 'package:first_project/repository/auth_repository.dart';
// Firebase authと連携させるため以下追加。
import 'package:firebase_auth/firebase_auth.dart';
// 状態管理を追加。
import 'package:hooks_riverpod/hooks_riverpod.dart';


// ConsumerWidgetでProviderから値を受け渡す
class LoginPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Providerから値を受け取る
    final infoText = ref.watch(infoTextProvider);
    final email = ref.watch(emailProvider);
    final password = ref.watch(passwordProvider);

    return Scaffold(
      backgroundColor: kMainColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            // 小さい画面（iPhone8）では画面が見切れてしまっていたので、以下調整加えました。
            Container(
              padding: const EdgeInsets.only(top: 30),
              width:100,
              child: Image.asset('assets/images/logo3.png'),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 30),
              child: const Text(
              'News Logs',
              style: TextStyle(fontSize: 35, color: kBaseColor),
            ),),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  color: kBaseColor,
                ),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 80,
                    ),
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        'メールアドレス',
                        style: TextStyle(
                          color: kAccentColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onChanged: (String value) {
                        // Providerから値を更新
                        ref.watch(emailProvider.notifier).state = value;
                      }
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        'パスワード(6文字以上)',
                        style: TextStyle(
                          color: kAccentColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // パスワード入力
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      // パスワードが見えないようにする。
                      obscureText: true,
                      onChanged: (String value) {
                        // Providerから値を更新
                        ref.watch(passwordProvider.notifier).state = value;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      // メッセージ表示
                      child: Text(infoText),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      // 余白を均等に並べる。
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          width: 130,
                          height: 60,
                          // ログイン登録ボタン
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: kMainColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(70),
                                )),
                            child: const Text(
                              'ログイン',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: kBaseColor),
                            ),
                            onPressed: () async {
                              try {
                                final FirebaseAuth auth = FirebaseAuth.instance;
                                await auth.signInWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );
                                await Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) {
                                    return const ItemListPage();
                                  }),
                                );
                              } catch (e) {
                                // Providerから値を更新
                                ref.watch(infoTextProvider.notifier).state =
                                    "ログインに失敗しました：${e.toString()}";
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 130,
                          height: 60,
                          // ユーザー登録ボタン
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: kMainColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(70),
                                )),
                            child: const Text(
                              '新規登録',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: kBaseColor),
                            ),
                            onPressed: () async {
                              try {
                                final FirebaseAuth auth = FirebaseAuth.instance;
                                final result = await auth.createUserWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );
                                // ユーザー情報を更新
                                ref.watch(userProvider.notifier).state = result.user;

                                await Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) {
                                    return const ItemListPage();
                                  }),
                                );
                              } catch (e) {
                                // Providerから値を更新
                                ref.watch(infoTextProvider.notifier).state =
                                  "登録に失敗しました：${e.toString()}";
                              }
                            },
                          ),
                        ),
                      ]
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
