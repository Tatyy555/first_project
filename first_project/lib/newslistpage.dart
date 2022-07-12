import 'package:first_project/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:first_project/newsaddpage.dart';
//import 'package:first_project/newseditpage.dart';

// Firebase authと連携させるため以下追加。
import 'package:firebase_auth/firebase_auth.dart';

// Firestoreと連携させるため以下追加。
import 'package:cloud_firestore/cloud_firestore.dart';

// newslinkから表示。
import 'package:any_link_preview/any_link_preview.dart';

// flutter_slidableを利用するため以下追加。
import 'package:flutter_slidable/flutter_slidable.dart';

import 'constants.dart';

// ニュースリスト画面のWidget。
class NewsListPage extends StatelessWidget {
  // 引数からユーザー情報を受け取れるようにする
  NewsListPage(this.user);
  // ユーザー情報
  final User user;

  // Drawerをタップで表示できるようにGlibalKeyを設定。
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _getMetadata(String url) async {
    bool isValid = _getUrlValid(url);
    if (isValid) {
      Metadata? metadata = await AnyLinkPreview.getMetadata(
        link: url,
        cache: const Duration(days: 7),
        proxyUrl: "https://cors-anywhere.herokuapp.com/", // Needed for web app
      );
      debugPrint(metadata?.title);
      debugPrint(metadata?.desc);
    } else {
      debugPrint("URL is not valid");
    }
  }

  bool _getUrlValid(String url) {
    bool isUrlValid = AnyLinkPreview.isValidLink(
      url,
      protocols: ['http', 'https'],
      hostWhitelist: ['https://youtube.com/'],
      hostBlacklist: ['https://facebook.com/'],
    );
    return isUrlValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBaseColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              // Container(
              //   padding: const EdgeInsets.all(8),
              //   child: Text('ログイン情報：${user.email}'),
              // ),
              Expanded(
                // SreamBuilder
                // FireStoreの内容をリアルタイムで更新するWidgetを作れる
                child: StreamBuilder<QuerySnapshot>(
                    // News一覧を取得（非同期処理）
                    // 登録日時でソート
                    stream: FirebaseFirestore.instance
                        .collection('news')
                        .orderBy('date')
                        .snapshots(),
                    builder: (context, snapshot) {
                      // データが取得できた場合
                      if (snapshot.hasData) {
                        final List<DocumentSnapshot> documents =
                            snapshot.data!.docs;
                        // 取得したNews一覧を元にリスト表示
                        return ListView(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          children: documents.map((document) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              // スライドで右に削除と編集ボタンを表示。
                              child: Slidable(
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        // onPressed: null,
                                        onPressed:
                                            (BuildContext context) async {
                                          // Newsの削除
                                          await FirebaseFirestore.instance
                                              .collection('news')
                                              .doc(document.id)
                                              .delete();
                                        },
                                        backgroundColor:
                                            const Color(0xFFFE4A49),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                      ),
                                      const SlidableAction(
                                        onPressed: null,
                                        // onPressed: (BuildContext context) async {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(builder: (context)=> NewsEditPage(user,document),
                                        //   )
                                        // );},
                                        backgroundColor: Color(0xFF21B7CA),
                                        foregroundColor: Colors.white,
                                        icon: Icons.edit,
                                        label: 'Edit',
                                      ),
                                    ],
                                  ),
                                  child: Column(children: <Widget>[
                                    if (document['email'] == user.email)
                                      Column(children: <Widget>[
                                        AnyLinkPreview(
                                          link: document['url'],
                                          errorWidget: const Text('エラー'),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 40),
                                          child: Column(
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  document['comment'],
                                                  style: TextStyle(
                                                      color: kTextColor,
                                                      fontSize: 14),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    // まだハッシュ機能は実装していない。
                                                    Text(
                                                      '#' + document['hash'],
                                                      style: TextStyle(
                                                        backgroundColor:
                                                            kAccentColor,
                                                        color: kBaseColor,
                                                      ),
                                                    ),
                                                  ]),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  document['date'],
                                                  style: TextStyle(
                                                      color: kTextColor,
                                                      fontSize: 14),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                  ])),
                            );
                          }).toList(),
                        );
                      }
                      // データが読込中の場合
                      return const Center(
                        child: Text('読込中...'),
                      );
                    }),
              )
            ],
          ),
        ),

        // 下の＋マークのWidget。
        /*
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // プラスボタンを押すとニュース追加画面へ遷移。
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewsAddPage(user),
                    fullscreenDialog: true));
            /* ボタンがタップされた時の処理 */
          },
          child: const Icon(Icons.add),
        ),
        */
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          child: BottomAppBar(
            color: kMainColor,
            shape: const CircularNotchedRectangle(),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 8,
                left: 20,
                right: 20,
              ),
              child: Row(
                //mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: kBaseColor,
                      size: 40,
                    ),
                    onPressed: () {
                      // タップでDrawerを開くようにする。
                      _scaffoldKey.currentState!.openDrawer();
                    },
                  ),
                  IconButton(
                    padding: EdgeInsets.only(top: 10),
                    icon: const Icon(
                      Icons.numbers,
                      color: kBaseColor,
                      size: 30,
                    ),
                    onPressed: () {/* ボタンがタップされた時の処理 */},
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: TextButton(
                      onPressed: () {/* ボタンがタップされた時の処理 */},
                      child: const Text(
                        'Stats',
                        style: TextStyle(
                          color: kBaseColor,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    backgroundColor: kBaseColor,
                    onPressed: () async {
                      // プラスボタンを押すとニュース追加画面へ遷移。
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewsAddPage(user),
                              fullscreenDialog: true));
                      /* ボタンがタップされた時の処理 */
                    },
                    child: const Icon(
                      Icons.add,
                      color: kMainColor,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Drawerの内容を作成。中身は要確認。
        key: _scaffoldKey,
        drawer: Drawer(
          child: Column(children: [
            const UserAccountsDrawerHeader(
              accountName: Text("User Name"),
              accountEmail: Text("User Email"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: kBaseColor,
                backgroundImage: NetworkImage(
                    "https://pbs.twimg.com/profile_images/885510796691689473/rR9aWvBQ_400x400.jpg"),
              ),
            ),
            ListTile(
              title: const Text('ログアウト'),
              onTap: () async {
                // ログアウト処理
                // 内部で保持しているログイン情報等が初期化される
                await FirebaseAuth.instance.signOut();
                // ログイン画面に遷移＋チャット画面を破棄
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) {
                    return const LoginPage();
                  }),
                );
              },
            ),
          ]),
        ));
  }
}
