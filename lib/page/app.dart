import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_pencake_clone/page/menu_page.dart';
import 'package:diary_pencake_clone/page/note_edit_page.dart';
import 'package:diary_pencake_clone/page/note_page.dart';
import 'package:diary_pencake_clone/repository/notepage_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../repository/notes_repository.dart';

class App extends StatefulWidget {
  final Notepage baseNotePage;

  const App({super.key, required this.baseNotePage});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  TextEditingController? titleController;
  TextEditingController? subtitleController;

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
    titleController =
        TextEditingController(text: widget.baseNotePage.pageTitle);
    subtitleController =
        TextEditingController(text: widget.baseNotePage.pageSubtitle);
  }

  PreferredSizeWidget _appBarWidget() {
    return PreferredSize(
      preferredSize: Size(Get.width, Get.height * 0.3),
      child: SafeArea(
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          flexibleSpace: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  '제목과 부제목을 클릭하여 수정 가능',
                  style: TextStyle(color: Colors.black45, fontSize: 12),
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                TextField(
                  controller: titleController,
                  focusNode: _titleFocusNode,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: _isTitleFocused ? '' : '페이지 제목을 입력하세요',
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  onChanged: (value) {
                    Notepage updateNotepage = Notepage(
                      id: widget.baseNotePage.id,
                      pageTitle: titleController!.text,
                      pageSubtitle: subtitleController!.text,
                      pageCreatedAt: widget.baseNotePage.pageCreatedAt,
                    );
                    Notepage.update(updateNotepage);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: subtitleController,
                  focusNode: _subtitleFocusNode,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: _isSubtitleFocused ? '' : '부제목을 입력하세요',
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 15,
                    ),
                  ),
                  onChanged: (value) {
                    Notepage updateNotepage = Notepage(
                      id: widget.baseNotePage.id,
                      pageTitle: titleController!.text,
                      pageSubtitle: subtitleController!.text,
                      pageCreatedAt: widget.baseNotePage.pageCreatedAt,
                    );
                    Notepage.update(updateNotepage);
                  },
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
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: GestureDetector(
                    onTap: () async {
                      Note note = await Note.add(widget.baseNotePage);
                      Get.to(() => NoteEditPage(),
                          transition: Transition.zoom,
                          arguments: {
                            'note': note,
                            'note_page': widget.baseNotePage,
                            'isTitle': true
                          });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '노트 추가',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Icon(Icons.add),
                      ],
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                '옆으로 슬라이드하면 데이터 삭제',
                style: TextStyle(color: Colors.black45, fontSize: 12),
              )
            ],
          ),
          Expanded(
            child: StreamBuilder<List<Note>>(
              stream: readNotes(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error.toString());
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

  Widget buildNote(Note note, int index) => Dismissible(
        key: UniqueKey(),
        background: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.red.withOpacity(0.8),
              Colors.white,
              Colors.red.withOpacity(0.8)
            ],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        onDismissed: (direction) {
          Note.delete(note.id!);
        },
        child: GestureDetector(
          onTap: () {
            Get.to(() => NotePage(),
                arguments: {'note': note, 'note_page': widget.baseNotePage},
                transition: Transition.leftToRightWithFade);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 7,
                  child: Text(
                    note.noteTitle!,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                    maxLines: 1,
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Text(
                    timeago.format(note.createdAt!),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.black38,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Stream<List<Note>> readNotes() {
    return FirebaseFirestore.instance
        .collection('notes')
        .orderBy("created_at", descending: true)
        .where('note_page_id', isEqualTo: widget.baseNotePage.id as String)
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
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(() => MenuPage(),
                  transition: Transition.fadeIn,
                  arguments: widget.baseNotePage);
            },
            tooltip: '메뉴에요',
            shape: RoundedRectangleBorder(
              side:
                  BorderSide(width: 1.2, color: Colors.black.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(50),
            ),
            foregroundColor: Colors.grey,
            elevation: 0,
            highlightElevation: 12.0,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.more_horiz,
              size: 30,
              color: Colors.black.withOpacity(0.2),
            ),
          ),
        ));
  }
}
