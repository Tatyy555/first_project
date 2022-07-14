// Material Components widgetsを利用。
import 'package:flutter/material.dart';
// 他ファイルのプログラムを利用。
import 'package:first_project/view/login_page.dart';
import 'package:first_project/model/item_model.dart';
import 'package:first_project/repository/auth_repository.dart';
import 'package:first_project/view/news_add_page.dart';
import 'package:first_project/view_model/item_list_view_model.dart';
import 'package:first_project/constants.dart';
// Firebaseと連携させるため以下追加。
import 'package:firebase_auth/firebase_auth.dart';
// 状態管理を追加。
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
// newslinkから表示。
import 'package:any_link_preview/any_link_preview.dart';
// flutter_slidableを利用するため以下追加。
import 'package:flutter_slidable/flutter_slidable.dart';
// 左から終えるように変更。
import 'package:page_transition/page_transition.dart';

class ItemListPage extends HookConsumerWidget {
  const ItemListPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Providerから値を受け取る
    final User user = ref.watch(userProvider)!;
    // state（状態）
    final itemList = ref.watch(itemListProvider);
    // provider（状態の操作）
    final itemListNotifier = ref.watch(itemListProvider.notifier);
    return Scaffold(
      // itemList = AsyncValue
      // AsyncValueのwhenメソッドを使用することで、データの取得時、ローディング時、エラー時の3つの処理を書くことができます
      body: itemList.when(
        data: (items) => items.isEmpty ? const Center(
          child: Text(
            'ニュース記事がありません',
            style: TextStyle(fontSize: 20.0),
          ),
        )
        : ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            final item = items[index]; String getTodayDate() {
              initializeDateFormatting('ja');
              return DateFormat('yyyy/MM/dd HH:mm', "ja").format(item.createdAt);
            }
            return ProviderScope(
              // スライドで右に削除と編集ボタンを表示。
              child:SafeArea(
                bottom: false,               
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  // スライドで右に削除と編集ボタンを表示。                
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (BuildContext context) async {
                            // データの削除
                            itemListNotifier.deleteItem(
                              itemId: item.id!, //削除するidの指定
                            );
                          },
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                        SlidableAction(
                          // onPressed:null, 
                          // タスク作成ダイアログを表示する（更新）
                          onPressed: (BuildContext context) async {
                            NewsAddPage.show(context, item);
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
                        if(item.email == user.email)
                        Column(
                          children:<Widget>[
                            AnyLinkPreview(
                              link: item.url,
                              errorWidget: const Text('エラー'),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40),
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      item.comment,
                                      style: const TextStyle(
                                          color: kTextColor,
                                          fontSize: 14),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        // まだハッシュ機能は実装していない。
                                        Text(
                                          '#${item.hash}',
                                          style: const TextStyle(
                                            backgroundColor:
                                                kAccentColor,
                                            color: kBaseColor,
                                          ),
                                        ),
                                      ]),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      getTodayDate(),
                                      style: const TextStyle(
                                          color: kTextColor,
                                          fontSize: 14),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ]
                        ),
                      ]
                    ),
                  ),
                )
              )
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()), //ローディング時
        error: (error, _) => Text(error.toString()), //エラー時
      ),

      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
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
                  onPressed: () async {
                    var result = await showModalBottomSheet<int>(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: const Icon(Icons.logout),
                              title: const Text('ログアウト'),
                              onTap: () async { 
                                // ログアウト処理
                                // 内部で保持しているログイン情報等が初期化される
                                await FirebaseAuth.instance.signOut();
                                // ログイン画面に遷移＋チャット画面を破棄
                                Navigator.of(context).pushReplacement(
                                  PageTransition(child:LoginPage(), type: PageTransitionType.leftToRight)
                                );
                              },
                            ),
                            const ListTile(
                              leading: Icon(Icons.videocam),
                              title: Text('Sample'),
                              onTap: null,
                            ),
                            const ListTile(
                              leading: Icon(Icons.camera),
                              title: Text('Sample'),
                              onTap: null,
                            ),
                          ],
                        );
                      }
                    );
                  },
                ),
                IconButton(
                  padding: const EdgeInsets.only(top: 10),
                  icon: const Icon(
                    Icons.numbers,
                    color: kBaseColor,
                    size: 30,
                  ),
                  onPressed: () {/* ボタンがタップされた時の処理 */},
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
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
                  onPressed: () => NewsAddPage.show(context, Item.empty()),
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

    );
  }
}
