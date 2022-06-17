import 'package:flutter/material.dart';
import 'package:any_link_preview/any_link_preview.dart';

// ニュースリスト画面のWidget。
class NewsListPage extends StatefulWidget{
  const NewsListPage({Key? key}) : super(key: key);
  @override 
  // aviud usiung private types in public APIsは何を直せばいいんだ？
  _NewsListPageState createState() => _NewsListPageState();
}



class _NewsListPageState extends State<NewsListPage> {
  // any_link_previewのExampleを参考。一旦、ベタ打ちで日経新聞の記事を参照しています。
  final String _url1 = "https://www.nikkei.com/article/DGXZQOUB1721D0X10C22A6000000/";
  final String _url2 = "https://www.nikkei.com/article/DGXZQOUB170US0X10C22A6000000/";
  final String _url3 = "https://www.nikkei.com/article/DGXZQOUA1706Q0X10C22A6000000/";

  // 残したままだとエラーになったので、コメントアウトしました。
  // @override
  // void initState() {
  //   super.initState();
  //   _getMetadata(_url);
  // }

  // なくても動いたので、コメントアウトしました。
  // void _getMetadata(String url) async {
  //   bool isValid = _getUrlValid(url);
  //   if (isValid) {
  //     Metadata? metadata = await AnyLinkPreview.getMetadata(
  //       link: url,
  //       cache: const Duration(days: 7),
  //       proxyUrl: "https://cors-anywhere.herokuapp.com/", // Needed for web app
  //     );
  //     debugPrint(metadata?.title);
  //     debugPrint(metadata?.desc);
  //   } else {
  //     debugPrint("URL is not valid");
  //   }
  // }

  // なくても動いたので、コメントアウトしました。
  // bool _getUrlValid(String url) {
  //   bool isUrlValid = AnyLinkPreview.isValidLink(
  //     url,
  //     protocols: ['http', 'https'],
  //     hostWhitelist: ['https://youtube.com/'],
  //     hostBlacklist: ['https://facebook.com/'],
  //   );
  //   return isUrlValid;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
              ),
              child:Column(
                children:<Widget>[
                  AnyLinkPreview(
                    link: _url1,
                    errorWidget: const Text('エラー'),
                  ),
                  SizedBox(
                    child:Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsetsDirectional.only(top:10),
                          alignment:const Alignment(-1, 0),                            child:const Text("祗園精舎の鐘の声、諸行無常の響きあり。娑羅双樹の花の色、盛者必衰の理をあらは（わ）す。おごれる人も久しからず、唯春の夜の夢のごとし。たけき者も遂にはほろびぬ、偏に風の前の塵に同じ。"),
                          ),
                        Container(
                          padding: const EdgeInsetsDirectional.only(top:10),
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              // ハッシュ機能を導入する際には必要になる。
                              // 一旦、ベタ打ち。
                              Text('# Sample1'),
                              Text('  '),
                              Text('# Sample2')
                            ]
                          ),
                        ),
                        Container(
                          padding: const EdgeInsetsDirectional.only(top:10),
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              // 一旦、更新日はベタ打ち。
                              children:const [
                              Text('2022.06.15 12:30'),
                            ]
                          ),
                        )
                      ]
                    )
                  ),
                ]
              )
            ),
            const SizedBox(height: 25),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
              ),
              child:Column(
                children:<Widget>[
                  AnyLinkPreview(
                    link: _url2,
                    errorWidget: const Text('エラー'),
                  ),
                  SizedBox(
                    child:Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsetsDirectional.only(top:10),
                          alignment:const Alignment(-1, 0),
                          child:const Text("祗園精舎の鐘の声、諸行無常の響きあり。娑羅双樹の花の色、盛者必衰の理をあらは（わ）す。おごれる人も久しからず、唯春の夜の夢のごとし。たけき者も遂にはほろびぬ、偏に風の前の塵に同じ。"),
                        ),
                        Container(
                          padding: const EdgeInsetsDirectional.only(top:10),
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text('# Sample1'),
                              Text('  '),
                              Text('# Sample2')
                            ]
                          ),
                        ),
                        Container(
                          padding: const EdgeInsetsDirectional.only(top:10),
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              // 一旦、更新日はベタ打ち。
                              children:const [
                              Text('2022.06.16 12:30'),
                            ]
                          ),
                        )
                      ]
                    )
                  ),
                ]
              )
            ),
            const SizedBox(height: 25),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
              ),
              child:Column(
                children:<Widget>[
                  AnyLinkPreview(
                    link: _url3,
                    errorWidget: const Text('エラー'),
                  ),
                  SizedBox(
                    child:Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsetsDirectional.only(top:10),
                          alignment:const Alignment(-1, 0),
                          child:const Text("祗園精舎の鐘の声、諸行無常の響きあり。娑羅双樹の花の色、盛者必衰の理をあらは（わ）す。おごれる人も久しからず、唯春の夜の夢のごとし。たけき者も遂にはほろびぬ、偏に風の前の塵に同じ。"),
                        ),
                        Container(
                          padding: const EdgeInsetsDirectional.only(top:10),
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text('# Sample1'),
                              Text('  '),
                              Text('# Sample2')
                            ]
                          ),
                        ),
                        Container(
                          padding: const EdgeInsetsDirectional.only(top:10),
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              // 一旦、更新日はベタ打ち。
                              children:const [
                              Text('2022.06.15 12:30'),
                            ]
                          ),
                        )
                      ]
                    )
                  ),
                ]
              )
            ),
            const SizedBox(height: 25),
              


          ],
        ),
      ),

      // 下の＋マークのWidget。
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {/* ボタンがタップされた時の処理 */},
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
                    onPressed: () { /* ボタンがタップされた時の処理 */ },
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
    );
  }
}