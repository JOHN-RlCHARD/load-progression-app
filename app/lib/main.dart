import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/screens/homepage.dart';
import 'dbHelper/mongodb.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: GoogleFonts.inriaSerifTextTheme(
            Theme.of(context).textTheme,
          )
      ),
      home: HomePage(),
    );
  }
}