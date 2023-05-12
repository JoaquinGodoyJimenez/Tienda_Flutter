import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:github_sign_in_plus/github_sign_in_plus.dart';

class FirebaseGithubAuth { 
  final GitHubSignIn gitHubSignIn = GitHubSignIn(
      clientId: '4758e64cdab4c9144113',
      clientSecret: '1dba6cd354a0e68f3adab8e7a8d7b955fd723112',
      redirectUrl: 'https://mrjc-tienda.firebaseapp.com/__/auth/handler'
  );

  gitHubSign(BuildContext context) async {
    var result = await gitHubSignIn.signIn(context);
    switch (result.status) {
      case GitHubSignInResultStatus.ok:
        var authResult = await FirebaseAuth.instance.signInWithCredential(
          GithubAuthProvider.credential(result.token.toString()),
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ingresando. Espere un momento por favor.')));
        break;
      case GitHubSignInResultStatus.cancelled:
      case GitHubSignInResultStatus.failed:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error. ${result.errorMessage}')));
        break;
    }
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

}
