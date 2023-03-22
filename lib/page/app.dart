import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_pencake_clone/page/note_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../repository/notes_repository.dart';

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final titleController = TextEditingController();
  final subtitleController = TextEditingController();

  final noteTitleController = TextEditingController();
  final contentController = TextEditingController();

  bool _isTitleFocused = false;
  final _titleFocusNode = FocusNode();
  bool _isSubtitleFocused = false;
  final _subtitleFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _titleFocusNode.addListener(() {
      setState(() {
        _isTitleFocused = _titleFocusNode.hasFocus;
      });
    });
    _subtitleFocusNode.addListener(() {
      setState(() {
        _isSubtitleFocused = _subtitleFocusNode.hasFocus;
      });
    });
  }

  @override
  PreferredSizeWidget _appBarWidget() {
    return PreferredSize(
      preferredSize: Size(Get.width, Get.height * 0.3),
      child: SafeArea(
        child: AppBar(
          backgroundColor: Colors.white,
          flexibleSpace: Center(
            child: Column(
              children: [
                SizedBox(
                  height: Get.height * 0.05,
                ),
                TextFormField(
                  controller: titleController,
                  focusNode: _titleFocusNode,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: _isTitleFocused ? '' : '제목을 입력하세요',
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: subtitleController,
                  focusNode: _subtitleFocusNode,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: _isSubtitleFocused ? '' : '부제목을 입력하세요',
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Divider(
                    height: 0.5,
                    color: Colors.black12,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bodyWidget() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Column(
            children: [
              TextField(
                controller: noteTitleController,
                decoration: const InputDecoration(
                  label: Text('노트제목을 입력하세요'),
                ),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  label: Text('노트내용을 입력하세요'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: GestureDetector(
                    onTap: () {
                      final noteTitle = noteTitleController.text;
                      final content = contentController.text;
                      final createdAt = DateTime.now();
                      //create기능을 담당하는 method추가
                      createNote(
                        noteTitle: noteTitle,
                        content: content,
                        createdAt: createdAt,
                      );
                    },
                    child: const Text('저장 버튼')),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<List<Note>>(
              stream: readNotes(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('에러');
                } else if (snapshot.hasData) {
                  final notes = snapshot.data!;
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildNote(notes[index], index);
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildNote(Note note, int index) => GestureDetector(
        onTap: () {
          Get.to(() => NotePage(), arguments: index);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                note.noteTitle!,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              Text(
                timeago.format(note.createdAt!),
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black38,
                ),
              ),
            ],
          ),
        ),
      );

  Future createNote({
    String? noteTitle,
    String? content,
    DateTime? createdAt,
  }) async {
    //name을 입력받아서 들고옴
    //collection의 위치 설정
    //뒤에 .doc('{너의 아이디}')를 붙일 경우 특정 collection내의 특정 document를 지정하는 것
    final docNote = FirebaseFirestore.instance.collection('notes').doc();
    //.doc()안에 아무것도 없을 경우 자동으로 아이디 생성
    final note = Note(
      id: docNote.id,
      noteTitle: noteTitle,
      content: content,
      createdAt: createdAt,
    );
    final json = note.toJson();

    await docNote.set(json); //docUser 위치에 json 내용을 set함
  }

  Stream<List<Note>> readNotes() {
    return FirebaseFirestore.instance
        .collection('notes')
        .orderBy("created_at", descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Note.fromJson(doc.data())).toList());
    //snapshot은 documents의 한 장면을 의미함
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Get.focusScope!.unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: _appBarWidget(),
          body: _bodyWidget(),
        ));
  }
}
