import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
// import 'package:test_application_with_flutter/main.dart';
// import 'package:test_application_with_flutter/screens/login_screen.dart';

final supabase = Supabase.instance.client;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState(){
    super.initState();
    // Check session dynamically
    if (supabase.auth.currentSession == null){
      Navigator.pushNamed(context, '/auth');
    }
  }

  @override
  Widget build(BuildContext context){
    // Get current session inside build for up-to-date value
    final session = supabase.auth.currentSession;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You are in profile - ${session?.user.id}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async{
                  final navigator = Navigator.of(context);
                  await GoogleSignIn().signOut();
                  await supabase.auth.signOut();
                  if (!mounted) return;
                  navigator.pushNamed('/');
                },
              child: const Text('Logout'),
            )
          ],
        ))
      );
  }
}