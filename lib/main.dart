import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  // Ensure Flutter is fully initialized before connecting to the database
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the Supabase connection
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
      home: const Scaffold(
        body: Center(
          child: Text(
            'Supabase Connected Successfully! 🚀',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}