
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService{
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  get currentUser => null;

  registerUser(
    {required 
    String name, 
    required String email, 
    required String password}) async {
      try{
     UserCredential credential = await _firebaseAuth
     .createUserWithEmailAndPassword(email: email, password: password);
     
    await credential.user!.updateDisplayName(name);
  } on FirebaseException catch (e) {
    print(e.code);
    if(e.code == 'email-already-in-use'){
      return "Email já cadastrado.";
    }
  }
 }

 loginUser ({required String email, required String password}) async{
  try{
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email, password: password);
    return null;
  }on FirebaseAuthException catch (e){
    return e.message;
  }
 }

 logoutUser(){
  return _firebaseAuth.signOut();
 }
  
}