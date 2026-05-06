import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const ZenTimerApp(),
    ),
  );
}

class ZenTimerApp extends StatelessWidget {
  const ZenTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return MaterialApp(
          title: 'Zen Focus Timer',
          theme: ThemeData.dark(
            useMaterial3: true,
          ).copyWith(
            scaffoldBackgroundColor: appState.currentTheme.backgroundColor,
          ),
          home: const HomeScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
