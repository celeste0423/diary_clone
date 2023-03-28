import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../repository/notepage_repository.dart';
import '../app.dart';

class MenuPageManagement extends StatefulWidget {
  MenuPageManagement({Key? key}) : super(key: key);

  @override
  State<MenuPageManagement> createState() => _MenuPageManagementState();
}

class _MenuPageManagementState extends State<MenuPageManagement> {
  final pageCollection = FirebaseFirestore.instance.collection('notepages');
  List<Notepage> notepages = [];

  @override
  void initState() {
    super.initState();
    getPageData();
  }

  Future<void> getPageData() async {
    try {
      var querySnapshot = await pageCollection.get();
      var length = querySnapshot.size;
      for (var i = 0; i < length; i++) {
        var data = querySnapshot.docs[i].data();
        var notepage = Notepage.fromJson(data);
        notepages.add(notepage);
      }
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () async {
            Notepage notepage = await Notepage.create();
            Get.off(() => App(baseNotePage: notepage));
          },
          child: Icon(
            Icons.add,
            color: Colors.black.withOpacity(0.2),
            size: 35,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              '추가하려면 왼쪽 위 버튼을 누르세요',
              style:
                  TextStyle(fontSize: 10, color: Colors.black.withOpacity(0.3)),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.3),
            height: 1,
            width: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              '삭제하려면 길게 누르세요',
              style:
                  TextStyle(fontSize: 10, color: Colors.black.withOpacity(0.3)),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 100),
              width: Get.width,
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(
                      notepages.length,
                      (index) => Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onTap: () {
                            Get.off(() => App(baseNotePage: notepages[index]));
                          },
                          onLongPress: () {
                            showAlertDialog(BuildContext context) {
                              showDialog(
                                useRootNavigator: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('경고', style: TextStyle(fontSize: 15),),
                                    content: const Text('정말로 삭제하시겠습니까?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('아니요', style: TextStyle(color: Colors.black.withOpacity(0.3)),),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('예', style: TextStyle(color: Colors.blue.withOpacity(0.3)),),
                                        onPressed: () {
                                          Notepage.delete(notepages[index].id!);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                            showModal(BuildContext context) {
                              showModalBottomSheet(
                                useRootNavigator: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const Text('경고',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            )),
                                        SizedBox(height: 16.0),
                                        Text('정말로 삭제하시겠습니까?'),
                                        SizedBox(height: 16.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            TextButton(
                                              child: Text('아니요'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text('예'),
                                              onPressed: () {
                                                Notepage.delete(notepages[index].id!);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                            return kIsWeb
                                ? showModal(context)
                                : showAlertDialog(context);
                          },
                          child: Text(
                            notepages[index].pageTitle == ''
                                ? '제목 없음'
                                : notepages[index].pageTitle!,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ),
                    )),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.back();
        },
        tooltip: '뒤로가기',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        elevation: 0,
        highlightElevation: 12.0,
        backgroundColor: Colors.white,
        child: Icon(
          Icons.close,
          size: 30,
          color: Colors.black.withOpacity(0.2),
        ),
      ),
    );
  }
}
