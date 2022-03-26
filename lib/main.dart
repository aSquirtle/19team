import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:imhere/postservice.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';
import 'commentservice.dart';
import 'here_service.dart';
import 'homepage.dart';
import 'loginpage.dart';
import 'onboarding.dart';

void main() async {
  // main() 함수에서 async를 쓰려면 필요
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // shared_preferences 인스턴스 생성

  prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => HereService()),
        ChangeNotifierProvider(create: (context) => PostService()),
        ChangeNotifierProvider(create: (context) => CommentService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = context.read<AuthService>().currentUser();
    // SharedPreferences에서 온보딩 완료 여부 조회
    // isOnboarded에 해당하는 값어서 null을 반환하는 경우 false 할당
    // bool isOnboarded = prefs.getBool("isOnboarded") ?? false;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: isOnboarded ? LoginPage() : OnboardingPage(),

      home: user == null ? OnboardingPage() : HomeZeroPage(),
    );
  }
}

//   Widget build(BuildContext context) {
//     User? user = context.read<AuthService>().currentUser();
//     // SharedPreferences에서 온보딩 완료 여부 조회
//     // isOnboarded에 해당하는 값어서 null을 반환하는 경우 false 할당
//     // bool isOnboarded = prefs.getBool("isOnboarded") ?? false;
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       // home: isOnboarded ? HomePage() : OnboardingPage(),
//       home: user == null ? LoginPage() : HomePage(),
//     );
//   }
// }
