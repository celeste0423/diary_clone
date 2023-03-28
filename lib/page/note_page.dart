import 'package:diary_pencake_clone/page/note_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../repository/notes_repository.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {

  Note note = Get.arguments;

  Widget _noteWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                Get.to(() => NoteEditPage(),
                    arguments: {'note': note, 'isTitle': true}, transition: Transition.fade);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    note.noteTitle!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    DateFormat('yyyy년 m월 dd일 (E) ah:mm')
                        .format(note.createdAt as DateTime),
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  Get.to(() => NoteEditPage(),
                      arguments: {'note': note, 'isTitle': false}, transition: Transition.fade);
                },
                child: Text(
                  note.content.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black26,
          ),
        ),
      ),
      body: _noteWidget(),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 0,

        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.image_outlined, size: 20, color: Colors.black.withOpacity(0.2),),
              onPressed: () {
              },
            ),
            IconButton(
              icon: Icon(Icons.share, size: 20, color: Colors.black.withOpacity(0.2),),
              onPressed: () {
              },
            ),
            IconButton(
              icon: Icon(Icons.more_vert, size: 20, color: Colors.black.withOpacity(0.2),),
              onPressed: () {
              },
            ),
          ],
        ),
      ),
    );
  }
}
