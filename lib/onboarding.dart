import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginpage.dart';

// SharedPreferences 인스턴스를 어디서든 접근 가능하도록 전역 변수로 선언
late SharedPreferences prefs;

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: [
          // 첫 번째 페이지
          PageViewModel(
            title: "아직도!",
            body: "평소 이웃과 인사는 하고 살고 계신가요?",
            image: Image(
              image: AssetImage("lib/assets/onboarding1.jpeg"),
              width: 600,
              height: 400,
              fit: BoxFit.fill,
            ),
            decoration: PageDecoration(
              titleTextStyle: TextStyle(
                color: Colors.blueAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              bodyTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          // 두 번째 페이지
          PageViewModel(
            title: "이제는!",
            body: "I'm Here로 이웃과 소통해보세요!",
            image: Image(
              image: AssetImage("lib/assets/onboarding2.jpeg"),
              width: 600,
              height: 400,
              fit: BoxFit.fill,
            ),
            decoration: PageDecoration(
              titleTextStyle: TextStyle(
                color: Colors.lime,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              bodyTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          //세번째 페이지
          PageViewModel(
            title: "Stay Home",
            body: "더이상 혼자가 아니에요!",
            image: Image(
              image: AssetImage("lib/assets/onboarding3.jpeg"),
              width: 600,
              height: 400,
              fit: BoxFit.fill,
            ),
            decoration: PageDecoration(
              titleTextStyle: TextStyle(
                color: Colors.redAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              bodyTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
        ],
        next: Text("Next", style: TextStyle(fontWeight: FontWeight.w600)),
        done: Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
        onDone: () {
          // Done 클릭시 isOnboarded = true로 저장
          prefs.setBool("isOnboarded", true);

          // Done 클릭시 페이지 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
      ),
    );
  }
}
