import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'theme/app_theme.dart';

import 'screens/login_screen.dart';
import 'screens/biometric_auth_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/registration_step1_screen.dart';
import 'screens/registration_step2_screen.dart';
import 'screens/registration_step3_screen.dart';
import 'screens/registration_step4_screen.dart';
import 'screens/application_submitted_screen.dart';
import 'screens/secure_chat_screen.dart';
import 'screens/groups_screen.dart';
import 'screens/voice_call_screen.dart';
import 'screens/video_call_screen.dart';
import 'screens/contacts_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/change_password_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print(Firebase.apps.length);

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  print(Firebase.apps.length);

  runApp(const DefenceSecureApp());
}

class DefenceSecureApp extends StatefulWidget {
  const DefenceSecureApp({super.key});

  @override
  State<DefenceSecureApp> createState() => _DefenceSecureAppState();
}

class _DefenceSecureAppState extends State<DefenceSecureApp> {
  final AppThemeController _themeController = AppThemeController();

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      controller: _themeController,
      child: AnimatedBuilder(
        animation: _themeController,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Secure Defence Network',
            theme: _themeController.materialTheme,
            initialRoute: '/',
            routes: {
              '/': (context) => const LoginScreen(),
              '/biometric': (context) => const BiometricAuthScreen(),
              '/dashboard': (context) => const DashboardScreen(),
              '/step1': (context) => const RegistrationStep1Screen(),
              '/step2': (context) => const RegistrationStep2Screen(),
              '/step3': (context) => const RegistrationStep3Screen(),
              '/step4': (context) => const RegistrationStep4Screen(),
              '/submitted': (context) => const ApplicationSubmittedScreen(),
              '/chat': (context) => const SecureChatScreen(),
              '/groups': (context) => const GroupsScreen(),
              '/voice': (context) => const VoiceCallScreen(),
              '/video': (context) => const VideoCallScreen(),
              '/contacts': (context) => const ContactsScreen(),
              '/notes': (context) => const NotesScreen(),
              '/settings': (context) => const SettingsScreen(),
              '/change-password': (context) => const ChangePasswordScreen(),
            },
          );
        },
      ),
    );
  }
}