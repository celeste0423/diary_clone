import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoteEditPage extends StatelessWidget {
  const NoteEditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              '취소',
              style: TextStyle(
                  color: Colors.black26,
                  fontWeight: FontWeight.w200,
                  fontSize: 15),
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
              child: Text(
                '완료',
                style: TextStyle(
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.w200,
                    fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
