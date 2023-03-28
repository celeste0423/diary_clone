import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_pencake_clone/page/note_page.dart';
import 'package:diary_pencake_clone/repository/notepage_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repository/notes_repository.dart';

class NoteEditPage extends StatefulWidget {
  String? defaultValue;
  final Note note;
  final Notepage notepage;
  final bool isTitle;
  NoteEditPage({Key? key, required this.note, required this.notepage,
      required this.isTitle});

  @override
  State<NoteEditPage> createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  TextEditingController? noteTitleController;
  TextEditingController? contentController;

  final notesCollection = FirebaseFirestore.instance.collection('notes');
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? documents;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    noteTitleController = TextEditingController(text: widget.note.noteTitle);
    contentController = TextEditingController(text: widget.note.content);
    setState(() {
      isLoading = false;
    });
  }

  @override
  PreferredSizeWidget _appBarWidget() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leadingWidth: 100,
      leading: GestureDetector(
        onTap: () {
          if (widget.note.noteTitle == '' && widget.note.content == '') {
            Note.delete(widget.note.id!);
          }
          Get.back();
        },
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: SizedBox(
            height: 50,
            width: 50,
            child: Text(
              '취소',
              style: TextStyle(
                  color: Colors.black26,
                  fontWeight: FontWeight.w200,
                  fontSize: 15),
            ),
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Note updateNote = Note(
              id: widget.note.id,
              notePageid: widget.notepage.id,
              noteTitle: noteTitleController!.text,
              content: contentController!.text,
              createdAt: DateTime.now(),
            );
            Note.update(updateNote);
            Get.off(() => NotePage(note: updateNote, notepage: widget.notepage,),
              transition: Transition.fade,);
          },
          child: const Padding(
            padding: EdgeInsets.all(10.0),
            child: SizedBox(
              width: 50,
              height: 50,
              child: Text(
                '완료',
                style: TextStyle(
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.w200,
                    fontSize: 15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bodyWidget() {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          TextField(
            maxLines: null,
            controller: noteTitleController,
            autofocus: widget.isTitle ? true : false,
            onChanged: (value) {
              notesCollection.doc(widget.note.id).update({'note_title': value});
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: '제목을 입력하세요',
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const Divider(
            height: 1,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: TextField(
                maxLines: null,
                controller: contentController,
                autofocus: widget.isTitle ? false : true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: '내용을 입력하세요',
                  hintStyle: TextStyle(
                    fontSize: 15,
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
      appBar: _appBarWidget(),
      body: _bodyWidget(),
    );
  }
}
