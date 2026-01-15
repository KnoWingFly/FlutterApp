import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:test_application_with_flutter/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<void> _googleSignIn() async {
    final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID']!;
    final iosClientId = dotenv.env['GOOGLE_IOS_CLIENT_ID']!;

final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: iosClientId,
    serverClientId: webClientId,
  );
  
  try {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return; // User cancelled
    
    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;
    if (accessToken == null) throw 'No Access Token found.';
    if (idToken == null) throw 'No ID Token found.';
    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 96, 24, 24),
        children: [
          Column(children: [
            const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            const SizedBox(height:24),

            // Magic Link Auth
            // SupaMagicAuth(
            //   redirectUrl: kIsWeb ? null : "profile",
            //   onSuccess: (session) => Navigator.pushNamed(context, 'home',),
            //   onError: (e) => SnackBar(content: Text(e.toString())),
            // ),

            // Email Auth
            SupaEmailAuth(
              redirectTo: kIsWeb ? null : "io.supabase.flutterapp://login-callback",
              onSignInComplete:(res) => Navigator.pushNamed(context, '/profile'),
              onSignUpComplete:(res) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Check your email to confirm your account!'),
                    duration: Duration(seconds: 5),
                  ),
                );
              },
              onError: (e) {  
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              },
            ),
          
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _googleSignIn,
            child: const Text('Sign in with Google'),
          ),

          // SupaSocialAuth
          // SupaSocialsAuth(
          //   socialProviders: const [
          //     OAuthProvider.google,
          //   ],
          //   redirectUrl: kIsWeb ? null : "io.supabase.flutterapp://login-callback",

          //   onSuccess: (session) => Navigator.pushNamed(context, '/profile'),
          //   onError: (e) {
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       SnackBar(content: Text(e.toString())),
          //     );
          //   },
          // ),
          ],)
        ]
      )
    );
  }
}

