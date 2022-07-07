import 'package:first_project/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:first_project/newsaddpage.dart';
import 'package:first_project/newseditpage.dart';
// Firebase authと連携させるため以下追加。
import 'package:firebase_auth/firebase_auth.dart';
// Firestoreと連携させるため以下追加。
import 'package:cloud_firestore/cloud_firestore.dart';
// newslinkから表示。
import 'package:any_link_preview/any_link_preview.dart';
// flutter_slidableを利用するため以下追加。
import 'package:flutter_slidable/flutter_slidable.dart';

// ニュースリスト画面のWidget。
class NewsListPage extends StatelessWidget{
 
  // 引数からユーザー情報を受け取れるようにする
  NewsListPage(this.user);
  // ユーザー情報
  final User user;

  // Drawerをタップで表示できるようにGlibalKeyを設定。
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              child: Text('ログイン情報：${user.email}'),
            ),
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
                    final List<DocumentSnapshot> documents = snapshot.data!.docs;
                    // 取得したNews一覧を元にリスト表示
                    return ListView(
                      children: documents.map((document) {
                        return Card( 
                          // スライドで右に削除と編集ボタンを表示。
                          child:Slidable(
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  // onPressed: null,
                                  onPressed: (BuildContext context) async {
                                    // Newsの削除
                                    await FirebaseFirestore.instance
                                    .collection('news')
                                    .doc(document.id)
                                    .delete();
                                  },
                                  backgroundColor: const Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                                SlidableAction(
                                  onPressed: (BuildContext context) async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context)=> NewsEditPage(user,document),)
                                    );
                                  },
                                  backgroundColor: const Color(0xFF21B7CA),
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                  label: 'Edit',
                                ),
                              ],
                            ),
                          
                            child: Column(
                              children: <Widget>[
                                if(document['email'] == user.email)
                                Column(
                                  children:<Widget>[
                                    AnyLinkPreview(
                                      link: document['url'],
                                      errorWidget: const Text('エラー'),
                                    ),
                                    SizedBox(
                                      child:Column(
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsetsDirectional.only(top:10),
                                            alignment:const Alignment(-1, 0),  
                                            child:Text(document['comment']),
                                            ),
                                          Container(
                                            padding: const EdgeInsetsDirectional.only(top:10),
                                            child:Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                // まだハッシュ機能は実装していない。
                                                Text('#'+ document['hash']),
                                              ]
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsetsDirectional.only(top:10),
                                              child:Column(
                                                children:[
                                                Text(document['date']),
                                                Text(document['email']),
                                              ]
                                            ),
                                          ),
                                        ]
                                      )
                                    )
                                  ]
                                ),
                              ]
                            )
                          ),
                        );
                      }).toList(),
                    );
                  }
                  // データが読込中の場合
                  return const Center(
                    child: Text('読込中...'),
                  );
                }
              ),
            )
          ],
        ),

      // 下の＋マークのWidget。
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // プラスボタンを押すとニュース追加画面へ遷移。
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context)=> NewsAddPage(user),
                fullscreenDialog: true
              )
            );
          /* ボタンがタップされた時の処理 */},
        child: const Icon(Icons.add),
      ),

      // Under barの追加。
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children:<Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // タップでDrawerを開くようにする。
                      _scaffoldKey.currentState!.openDrawer();
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.numbers,
                      color: Colors.white,
                    ),
                    onPressed: () { /* ボタンがタップされた時の処理 */ },
                  ),
                ]
              ),
              TextButton(
                onPressed: () { /* ボタンがタップされた時の処理 */ },
                child: const Text('Stats',
                  style: TextStyle(
                    color:Colors.white,
                    fontSize: 20,
                  ),
                ),
              )
            ],
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
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage("https://pbs.twimg.com/profile_images/885510796691689473/rR9aWvBQ_400x400.jpg"),
            ),
          ),
          ListTile(
            title: const Text('ログアウト'),
            onTap: () async {
            // ログアウト処理
            // 内部で保持しているログイン情報等が初期化される
            await FirebaseAuth.instance.signOut();
            // ログイン画面に遷移＋チャット画面を破棄
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) {
                return const LoginPage();
              }),
            );
          },
          ),
        ]),
      )
    );
  }
}