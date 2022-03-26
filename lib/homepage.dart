import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imhere/postservice.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'here_service.dart';
import 'loginpage.dart';
import 'onboarding.dart';

class HomeZeroPage extends StatefulWidget {
  const HomeZeroPage({Key? key}) : super(key: key);

  @override
  _HomeZeroPage createState() => _HomeZeroPage();
}

class _HomeZeroPage extends State<HomeZeroPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex, // index 순서에 해당하는 child를 맨 위에 보여줌
        children: [
          HomeFirstPage(),
          HomeSecondPage(
            post: null,
          ),
          // HomeThirdPage(),
          // Center(child: Text("네 번째 페이지")),
          // Center(child: Text("다섯 번째 페이지")),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex, // 현재 보여주는 탭
        onTap: (newIndex) {
          print("selected newIndex : $newIndex");
          // 다른 페이지로 이동
          setState(() {
            currentIndex = newIndex;
          });
        },
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey, // 선택되지 않은 아이콘 색상
        showSelectedLabels: false, // 선택된 항목 label 숨기기
        showUnselectedLabels: false, // 선택되지 않은 항목 label 숨기기
        type: BottomNavigationBarType.fixed, // 선택시 아이콘 움직이지 않기
        backgroundColor: Colors.white.withOpacity(0.8),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: ""),
          // BottomNavigationBarItem(icon: Icon(Icons.free_breakfast), label: ""),
          // BottomNavigationBarItem(icon: Icon(Icons.redeem), label: ""),
          // BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: ""),
        ],
      ),
    );
  }
}

/// 홈페이지
class HomeFirstPage extends StatefulWidget {
  const HomeFirstPage({Key? key}) : super(key: key);

  @override
  State<HomeFirstPage> createState() => _HomeFirstPageState();
}

class _HomeFirstPageState extends State<HomeFirstPage> {
  TextEditingController jobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    return Consumer<HereService>(
      builder: (context, bucketService, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Center(
                child: Text(
              "I'm Here",
              style: TextStyle(
                color: Colors.black,
              ),
            )),
            leading: // 삭제 버튼
                IconButton(
              color: Colors.black,
              onPressed: () {
                // SharedPreferences에 저장된 모든 데이터 삭제
                prefs.clear();
              },
              icon: Icon(Icons.delete),
            ),
            actions: [
              IconButton(
                  color: Colors.black,
                  onPressed: () {
                    // 로그아웃
                    context.read<AuthService>().signOut();

                    // 로그인 페이지로 이동
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  icon: Icon(Icons.logout_rounded)),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                          "https://t1.daumcdn.net/cfile/tistory/9994C1455B750A511D"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(45.0),
                      child: Center(
                        child: Text(
                          "${user.email}님 안녕하세요 👋",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 홈페이지
class HomeThirdPage extends StatefulWidget {
  const HomeThirdPage({Key? key}) : super(key: key);

  @override
  _HomeThirdPage createState() => _HomeThirdPage();
}

class _HomeThirdPage extends State<HomeThirdPage> {
  TextEditingController jobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    return Consumer<HereService>(
      builder: (context, bucketService, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Center(
                child: Text(
              "I'm Here",
              style: TextStyle(
                color: Colors.black,
              ),
            )),
            leading: // 삭제 버튼
                IconButton(
              color: Colors.black,
              onPressed: () {
                // SharedPreferences에 저장된 모든 데이터 삭제
                prefs.clear();
              },
              icon: Icon(Icons.delete),
            ),
            actions: [
              IconButton(
                  color: Colors.black,
                  onPressed: () {
                    // 로그아웃
                    context.read<AuthService>().signOut();

                    // 로그인 페이지로 이동
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  icon: Icon(Icons.logout_rounded)),
            ],
          ),
          body: Column(
            children: [
              Container(
                height: 400,
                width: 600,
                child: Image.network(
                  "https://blog.kakaocdn.net/dn/Wugda/btqZ6i73vbI/20negvkKKaNlr6lQkNVkuK/img.jpg",
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
