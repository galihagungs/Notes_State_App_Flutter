import 'package:flutter/material.dart';
import 'package:notesstatemanagemen/provider/notes.dart';
import 'package:notesstatemanagemen/screens/add_or_detail_note_screen.dart';
import 'package:notesstatemanagemen/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Notes(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        home: HomeScreen(),
        routes: {AddOrDetailScreen.routeName: (context) => AddOrDetailScreen(),},
      ),
    );
  }
}
