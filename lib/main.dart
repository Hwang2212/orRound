import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/config/theme.dart';
import 'app/config/routes.dart';
import 'app/modules/routes/routes.dart';
import 'app/data/providers/notification_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  // Initialize Notifications
  try {
    await NotificationProvider().initialize();
  } catch (e) {
    debugPrint('Notification initialization error: $e');
  }

  runApp(const OrroundApp());
}

class OrroundApp extends StatelessWidget {
  const OrroundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Orround',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: Routes.HOME,
      getPages: AppPages.routes,
    );
  }
}
