import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NoteEditPage extends StatefulWidget {
  String? defaultValue;

  @override
  State<NoteEditPage> createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  TextEditingController? noteTitleController;
  TextEditingController? contentController;

  int? index = Get.arguments;

  final notesCollection = FirebaseFirestore.instance.collection('notes');
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? documents;
  var note;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    notesCollection.get().then((querySnapshot) {
      documents = querySnapshot.docs;
      note = documents![index!];
      noteTitleController = TextEditingController(text: note['note_title']);
      contentController = TextEditingController(text: note['content']);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  PreferredSizeWidget _appBarWidget() {
    return AppBar(
      backgroundColor: Colors.white,
      leadingWidth: 100,
      leading: GestureDetector(
        onTap: () {
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
            Get.back();
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
        : Column(
            children: [
              TextField(
                controller: noteTitleController,
                onChanged: (value) {
                  notesCollection.doc(note.id).update({'note_title': value});
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
              TextFormField(
                controller: contentController,
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
            ],
          );
  }

  Widget _noteWidget() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('notes')
          .orderBy("created_at", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        final documents = snapshot.data!.docs;
        final note = documents[index!];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  note['note_title'],
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  DateFormat('yyyy년 m월 dd일 (E) ah:mm')
                      .format(note['created_at'].toDate()),
                  style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                      color: Colors.black38),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SingleChildScrollView(
                  child: Text(
                    note['content'].toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: Colors.black54),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
