import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_pencake_clone/page/menu/menu_app_setting.dart';
import 'package:diary_pencake_clone/page/menu/menu_page_management.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:search_page/search_page.dart';

import '../repository/notepage_repository.dart';
import '../repository/notes_repository.dart';
import 'note_edit_page.dart';

class MenuPage extends StatelessWidget {
  MenuPage({Key? key}) : super(key: key);
  Notepage _notepage = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 100),
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Get.to(() => AppSetting());
              },
              child: Text(
                '앱 설정',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
            Text(
              '이 페이지 설정',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
            Container(
              height: 1,
              width: 50,
              color: Colors.black.withOpacity(0.1),
            ),
            GestureDetector(
              onTap: () {
                Get.to(MenuPageManagement(), transition: Transition.fade);
              },
              child: Text(
                '모든 페이지',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
            Container(
              height: 1,
              width: 50,
              color: Colors.black.withOpacity(0.1),
            ),
            GestureDetector(
              onTap: () async {
                // Get.to(()=>Search());
                //.get과 .snapshot을 구분할 것
                //.get은 future로 document를 받아옴 => 따라서 .then함수를 통해 비동기적으로 정보를 처리할 것
                //.snapshot은 stream으로 값을 받아옴 => map함수를 통해 변환 가능
                showSearch(
                  context: context,
                  delegate: SearchPage<Note>(
                    barTheme: ThemeData(
                      appBarTheme: AppBarTheme(
                        elevation: 0,
                      ),
                      canvasColor: Colors.white,
                      primarySwatch:
                          const MaterialColor(0xFFFFFFFF, <int, Color>{
                        50: Color(0xFFFFFFFF),
                        100: Color(0xFFFFFFFF),
                        200: Color(0xFFFFFFFF),
                        300: Color(0xFFFFFFFF),
                        400: Color(0xFFFFFFFF),
                        500: Color(0xFFFFFFFF),
                        600: Color(0xFFFFFFFF),
                        700: Color(0xFFFFFFFF),
                        800: Color(0xFFFFFFFF),
                        900: Color(0xFFFFFFFF),
                      }),
                      inputDecorationTheme: InputDecorationTheme(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        disabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.07),
                      ),
                    ),
                    items: await FirebaseFirestore.instance
                        .collection('notes')
                        .get()
                        .then((snapshot) => snapshot.docs
                            .map((doc) => Note.fromJson(doc.data()))
                            .toList()),
                    searchLabel: '노트 검색',
                    suggestion: Center(
                      child: Text(
                        '검색어를 입력하세요',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ),
                    failure: Center(
                      child: Text(
                        '해당 노트가 없습니다',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ),
                    filter: (notes) => [
                      notes.noteTitle,
                      notes.content,
                    ],
                    builder: (notes) => ListTile(
                      title: Text(
                        notes.noteTitle!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        notes.content!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: Text(
                '검색',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                Note note = await Note.add(_notepage);
                Get.to(() => NoteEditPage(),
                    transition: Transition.zoom,
                    arguments: {'note': note, 'isTitle': true});
              },
              child: Text(
                '노트 추가',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.blueAccent.withOpacity(0.6),
                ),
              ),
            )
          ],
        ),
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
