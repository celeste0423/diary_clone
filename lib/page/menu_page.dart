import 'package:diary_pencake_clone/page/menu/menu_page_management.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            Text(
              '앱 설정',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.black.withOpacity(0.6),
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
              onTap: (){
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
            Text(
              '검색',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.black.withOpacity(0.6),
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
        child: Icon(Icons.close, size: 30, color: Colors.black.withOpacity(0.2),),
      ),
    );
  }
}
