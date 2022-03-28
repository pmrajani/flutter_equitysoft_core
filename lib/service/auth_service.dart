import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../utils/function_utils.dart';
import '../utils/logger_utils.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

// ============================================================================
  /// ======= SIGN IN -- SIGN UP ======= ::
// ============================================================================

  static Future<String> singIn({
    required String email,
    required password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return result.user!.uid;
    } catch (error) {
      errorHandling(error.toString());
      logger.e(error);
      return "";
    }
  }

  static Future<String> singInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();

      return result.user!.uid;
    } catch (error) {
      errorHandling(error.toString());
      logger.e(error);
      return "";
    }
  }

  static Future<UserCredential?> linkAnonymousAcc(
      AuthCredential credential) async {
    try {
      UserCredential? result =
          await _auth.currentUser?.linkWithCredential(credential);

      return result;
    } catch (error) {
      errorHandling(error.toString());
      logger.e(error);
      return null;
    }
  }

  static bool checkUserEmailIsVerified() {
    bool _isEmailV = false;
    try {
      _auth.currentUser?.reload();

      _isEmailV = _auth.currentUser!.emailVerified;
    } on Exception catch (e) {
      logger.e(e);
    }

    return _isEmailV;
  }

  static Future<UserCredential?> singUp({
    required String email,
    required password,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      result.user?.sendEmailVerification();

      return result;
    } catch (error) {
      logger.e(error);
      errorHandling(error.toString());
      return null;
    }
  }

  static Future<bool> forgotPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on Exception catch (e) {
      logger.e(e);
    }
  }

  static signOutGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn(scopes: ["email"]);
    try {
      await googleSignIn.signOut();
    } catch (e) {
      logger.e(e);
    }
  }

  static signOutFaceBook() async {
    try {
      await FacebookAuth.instance.logOut();
    } catch (e) {
      logger.e(e);
    }
  }

// ============================================================================
  /// ======= SOCIAL-MEDIA-SIGN-IN ======= ::
// ============================================================================

  static Future<User?> googleSignIn() async {
    try {
      AuthCredential _authCredential =
          const AuthCredential(providerId: "", signInMethod: "");

      GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
        "email",
      ]);

      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      _authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

      UserCredential userCredential =
          await _auth.signInWithCredential(_authCredential);

      return userCredential.user!;
    } catch (err) {
      logger.e("googleSignIn error is => $err");

      return null;
    }
  }

  static Future<User?> faceBookSignIn() async {
    try {
      AuthCredential _authCredential =
          const AuthCredential(providerId: "", signInMethod: "");

      final LoginResult fbLogin =
          await FacebookAuth.instance.login(permissions: ['email']);

      AccessToken accessToken = fbLogin.accessToken!;
      _authCredential = FacebookAuthProvider.credential(accessToken.token);

      await linkAnonymousAcc(_authCredential);

      UserCredential userCredential =
          await _auth.signInWithCredential(_authCredential);

      return userCredential.user;
    } on Exception catch (e) {
      logger.e(e);
      return null;
    }
  }

  static Future<User?> appleSignIn() async {
    try {
      AuthCredential _authCredential =
          const AuthCredential(providerId: "", signInMethod: "");

      AuthorizationCredentialAppleID appleId =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      OAuthProvider oAuthProvider = OAuthProvider("apple.com");
      _authCredential = oAuthProvider.credential(
        idToken: appleId.identityToken,
        accessToken: appleId.authorizationCode,
      );

      await linkAnonymousAcc(_authCredential);

      UserCredential userCredential =
          await _auth.signInWithCredential(_authCredential);
      return userCredential.user;
    } on Exception catch (e) {
      logger.e(e);
      return null;
    }
  }

// ============================================================================
  /// ======= ERROR HANDLING ======= ::
// ============================================================================
  static void errorHandling(String error) {
    switch (error) {
      case "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.":
        {
          CommonValidate.snackBar(
            title: "Not Match",
            message: "Email and password dose not match",
          );
        }
        break;
      case "invalid-email":
      case "ERROR_INVALID_EMAIL":
        {
          CommonValidate.snackBar(
            title: "Not Match",
            message: "Email and password dose not match",
          );
        }
        break;
      case "wrong-password":
      case "ERROR_WRONG_PASSWORD":
        {
          CommonValidate.snackBar(
            title: "Not Match",
            message: "Email and password dose not match",
          );
        }
        break;
      case "[firebase_auth/email-already-in-use] The email address is already in use by another account.":
        {
          CommonValidate.snackBar(
            title: "Email Already Used",
            message: "Email already use in other account",
          );
        }
        break;
      case "weak-password":
      case "ERROR_WEAK_PASSWORD":
        {
          CommonValidate.snackBar(
              title: "Password Not Strong",
              message: "Please enter your password minimum 6 character");
        }
        break;
      default:
        {
          CommonValidate.snackBar(
            title: "Failed",
            message: "Email and password dose not match",
          );
        }
    }
  }
}
