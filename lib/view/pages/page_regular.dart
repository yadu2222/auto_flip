import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../data/regular_manager.dart';

class PageRegular extends StatefulWidget {
  @override
  _PageRegular createState() => _PageRegular();
}

class _PageRegular extends State<PageRegular> {
  // コントローラー
  final _storeNameController = TextEditingController();
  final _magazineController = TextEditingController();
  final _magazineNameController = TextEditingController();

  // どちらで検索しているかを判別する変数
  // 0で店舗名検索、1で雑誌コード検索
  int searchType = 0;

  @override
  Widget build(BuildContext context) {
    //画面サイズ
    var screenSizeWidth = MediaQuery.of(context).size.width;
    var screenSizeHeight = MediaQuery.of(context).size.height;

    // 基本的な数字
    double widthData = 0.6;
    double heightData = 0.1;

    // 表示用のリスト
    List regularList = [];

    Widget searchButton(String searchRoom, int dispType) {
      return IconButton(
          icon: Icon(Icons.send), // Replace 'some_icon' with the desired icon
          onPressed: () async {
            FocusScope.of(context).unfocus(); //キーボードを閉じる

            // List newList = await RegulerManager.getsearchData(searchRoom);

            setState(() {
              // 切り替え
              if (dispType == 0) {
                searchType = 0;
                debugPrint(searchType.toString());
              } else if (dispType == 1) {
                searchType = 1;
                debugPrint(searchType.toString());
              } else {
                searchType = 2;
                debugPrint(searchType.toString());
              }
            });
          });
    }

    // 検索バー
    Widget searchBar(IconData icon, String hintText, TextEditingController controller, int addType) {
      return // 検索バー
          Container(
              width: screenSizeWidth * widthData,
              //height: screenSizeHeight * 0.067,
              decoration: BoxDecoration(color: Color.fromARGB(255, 239, 238, 238), borderRadius: BorderRadius.circular(50)),
              margin: EdgeInsets.all(screenSizeWidth * 0.02),
              child: Column(children: [
                Row(
                  children: [
                    // 検索アイコン
                    Container(
                        margin: EdgeInsets.only(right: screenSizeWidth * 0.02, left: screenSizeWidth * 0.02),
                        child: Icon(
                          icon,
                          size: 30,
                          // color: Colors.grey,
                        )),

                    Container(
                        width: screenSizeWidth * 0.4,
                        height: screenSizeHeight * 0.04,
                        alignment: const Alignment(0.0, 0.0),
                        // テキストフィールド
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: hintText,
                          ),
                          textInputAction: TextInputAction.search,
                        )),
                    SizedBox(
                      width: screenSizeWidth * 0.01,
                    ),
                    // やじるし 検索ボタン
                    searchButton(controller.text, addType),
                  ],
                )
              ]));
    }

    // 雑誌優先表示カード
    Widget magazinesCard(int index) {
      return ListTile(
          title: InkWell(
              onTap: () {
                // 編集画面に遷移
              },
              child: Container(
                width: screenSizeWidth * 0.6,
                // height: screenSizeHeight * 0.1,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    // 一番最初である、または
                    // 一つ前のデータと雑誌コードが同一かを判別
                    index == 0 || regularList[index]["magazine_code"] != regularList[index - 1]["magazine_code"]
                        ? Container(
                            width: screenSizeWidth * 0.6,
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(width: 1, color: Colors.black)),
                            ),
                            child: Container(
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    Text(regularList[index]["magazine_code"].toString()),
                                    SizedBox(width: screenSizeWidth * 0.02),
                                    Text(regularList[index]["magazine_name"]),
                                    // SizedBox(width: screenSizeWidth * 0.02),
                                    // Text(regularList[index]["quantity_in_stock"].toString()),
                                  ],
                                )))
                        : const SizedBox.shrink(),

                    Container(
                        alignment: Alignment.center,
                        child: Row(children: [
                          Text(regularList[index]["store_name"]),
                          SizedBox(width: screenSizeWidth * 0.02),
                          Text(regularList[index]["quantity"].toString()),
                        ]))
                  ],
                ),
              )));
    }

    // 店舗名優先表示カード
    Widget storeListCard(int index) {
      return ListTile(
          // 押されたときの動作
          // TODO:DB検索と表示
          onTap: () async {
            // 編集画面に遷移
          },
          title: Container(
            width: screenSizeWidth * widthData,
            alignment: Alignment.center,
            child: Column(
              children: [
                index == 0
                    ? Container(
                        width: screenSizeWidth * widthData * 0.8,
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(width: 1, color: Colors.black)),
                        ),
                        child: Text(
                          regularList[index]["store_name"],
                        ),
                      )
                    : regularList[index]["store_name"] == regularList[index - 1]["store_name"]
                        ? const SizedBox.shrink()
                        : Container(
                            width: screenSizeWidth * widthData * 0.8,
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(width: 1, color: Colors.black)),
                            ),
                            child: Text(
                              regularList[index]["store_name"],
                            ),
                          ),
                Container(
                    alignment: Alignment.center,
                    child: Row(children: [Text(regularList[index]["magazine_code"].toString()), SizedBox(width: screenSizeWidth * 0.02), Text(regularList[index]["magazine_name"])]))
              ],
            ),
          ));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('定期一覧'),
        ),
        // DBの読み込みを待ってから表示
        body: Center(
            child: Container(
                child: Column(children: [
          searchBar(Icons.store, "店舗名で検索", _storeNameController, 0),
          searchBar(Icons.local_offer, "雑誌コードで検索", _magazineController, 1),
          searchBar(Icons.import_contacts, "誌名で検索", _magazineNameController, 2),
          FutureBuilder(
            future: RegulerManager.getRegularList(
                searchType == 0
                    ? _storeNameController.text
                    : searchType == 1
                        ? _magazineController.text
                        : _magazineNameController.text,
                searchType),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  // futureから帰ってきたデータを挿入
                  // Widgetを表示
                  debugPrint(searchType.toString());
                  debugPrint("なにがはいってるのかというと[${searchType == 0 ? _storeNameController.text : _magazineController.text}]");
                  regularList = snapshot.data;
                  return Container(
                      width: screenSizeWidth * widthData * 0.8,
                      height: screenSizeHeight * heightData * 5,
                      alignment: Alignment.topCenter,
                      child: ListView.builder(
                        itemCount: regularList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return searchType == 0 ? storeListCard(index) : magazinesCard(index);
                        },
                      ));
                }
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ]))));
  }

  @override
  void dispose() {
    // Stateがdisposeされる際に、TextEditingControllerも破棄する
    _storeNameController.dispose();

    super.dispose();
  }
}
