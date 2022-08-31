import 'package:app/screens/calendarpage.dart';
import 'package:app/screens/exercisepage.dart';
import 'package:app/screens/workoutspage.dart';
import 'package:app/screens/progressionpage.dart';
import 'package:app/widgets/my_input_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/screens/homepage.dart';
import 'dbHelper/mongodb.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int currentIndex = 2;
  final screens = [
    const ExercisePage(),
    const WorkoutsPage(),
    const HomePage(),
    const CalendarPage(),
    const ProgressionPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: GoogleFonts.inriaSerifTextTheme(
            Theme.of(context).textTheme,
          ),
        inputDecorationTheme: MyInputTheme().theme(),
      ),
      home: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.white,
          selectedItemColor: const Color(0xFF67DFDD),
          showUnselectedLabels: false,
          elevation: 5,
          backgroundColor: const Color(0xFF404040),
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center, size: 30,),
              label: 'Exercises',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_view_day, size: 30,),
              label: 'Plans',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled, size: 30,),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month, size: 30,),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_graph, size: 30,),
              label: 'Progression',
            ),
          ],
        ),
      ),
    );
  }
}