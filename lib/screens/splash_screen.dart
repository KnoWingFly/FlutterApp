import 'package:test_application_with_flutter/screens/login_screen.dart';
import 'package:test_application_with_flutter/screens/profile_screen.dart';
import 'package:flutter/material.dart';

import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Check session inside build so we always get the current value
    final activeSession = Supabase.instance.client.auth.currentSession;
    return Scaffold(
      body: Center(
        child: activeSession == null ? LoginScreen() : ProfileScreen(),
      ),
    );
  }
}
