import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AppSetting extends StatelessWidget {
  const AppSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 100),
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                Fluttertoast.showToast(msg: '구현 예정입니다');
              },
              child: Text(
                '글자 크기',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                Fluttertoast.showToast(msg: '구현 예정입니다');
              },
              child: Text(
                '폰트 설정',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                Fluttertoast.showToast(msg: '구현 예정입니다');
              },
              child: Text(
                '화면 모드',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                Fluttertoast.showToast(msg: '구현 예정입니다');
              },
              child: Text(
                '잠금 설정',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                Fluttertoast.showToast(msg: '구현 예정입니다');
              },
              child: Text(
                '언어 설정',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                Fluttertoast.showToast(msg: '구현 예정입니다');
              },
              child: Text(
                '세부 설정',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                Fluttertoast.showToast(msg: '구현 예정입니다');
              },
              child: Text(
                '프리미엄',
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
              onTap: (){
                Fluttertoast.showToast(msg: '구현 예정입니다');
              },
              child: Text(
                '동기화',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                Fluttertoast.showToast(msg: '구현 예정입니다');
              },
              child: Text(
                '내보내기',
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
              onTap: (){
                Fluttertoast.showToast(msg: '구현 예정입니다');
              },
              child: Text(
                '자주 묻는 질문',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                Fluttertoast.showToast(msg: '구현 예정입니다');
              },
              child: Text(
                '의견 보내기',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
