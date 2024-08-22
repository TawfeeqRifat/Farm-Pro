import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  // Google Sign in
  signInWithGoogle() async{
    //begin sign in processs
    GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    //obtain auth details from the requset
    GoogleSignInAuthentication? gAuth = await gUser?.authentication;

    //create a new user credential
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: gAuth?.accessToken,
      idToken:  gAuth?.idToken,
    );

    //sign in
    UserCredential userCredential= await FirebaseAuth.instance.signInWithCredential(credential);

    print(userCredential.user?.displayName);

    return userCredential;
  }
}

