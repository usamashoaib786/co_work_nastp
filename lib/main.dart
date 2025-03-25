import 'package:calendar_view/calendar_view.dart';
import 'package:co_work_nastp/Helpers/app_theme.dart';
import 'package:co_work_nastp/Views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  // Set status bar color and icon brightness
SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  statusBarColor: Colors.white, // Match background color
  statusBarIconBrightness: Brightness.dark, // Dark icons for better visibility
));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppTheme.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent, // Keep it uniform across screens
            elevation: 0,
          ),
        ),
        title: 'NASTP',
        home: const SplashScreen(),
      ),
    );
  }
}
