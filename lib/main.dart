import 'package:flutter/material.dart';

import 'pages/main_page.dart';

void main() {
  runApp(const Xleb());
}

class Xleb extends StatelessWidget {
  const Xleb({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: MainPage());
  }
}
