import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/auth/login_screen.dart'; // Eita add korechi: Login screen ke app e niye ashar jonno

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://lsysvdsfknssritvrhqz.supabase.co',
    anonKey: 'sb_publishable_4pqwm8qZTT375arKo-b49Q_hIBY9o__',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LuCollab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // EIKHANE CHANGE HOYECHE: Purano Scaffold/Text kete amra LoginScreen bosiye diyechi
      home: const LoginScreen(), 
    );
  }
}