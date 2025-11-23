import 'package:flutter/material.dart';
import 'screens/landing_screen.dart';
import 'screens/home_screen.dart';
import 'services/api_service.dart';

void main() {
  runApp(const StressDebuggerApp());
}

class StressDebuggerApp extends StatelessWidget {
  const StressDebuggerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StressDebugger',
      theme: ThemeData(
        primaryColor: const Color(0xFF677365),
        scaffoldBackgroundColor: const Color(0xFF262620),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF677365),
          secondary: const Color(0xFF96A694),
          surface: const Color(0xFF50594F),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFB0BFAE), fontFamily: 'TaebaekEunhasu'),
          bodyMedium: TextStyle(color: Color(0xFFB0BFAE), fontFamily: 'TaebaekEunhasu'),
        ),
      ),
      home: FutureBuilder<String?>(
        future: ApiService().getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            return const HomeScreen();
          }
          return const LandingScreen();
        },
      ),
    );
  }
}
