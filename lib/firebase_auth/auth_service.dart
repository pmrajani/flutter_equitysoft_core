import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../utils/function_utils.dart';
import '../utils/logger_utils.dart';
import 'frb_col.dart';

class AuthService {
  static const String errWrongOTP =
      "[firebase_auth/invalid-verification-code] The sms verification code used to create the phone auth credential is invalid. Please resend the verification code sms and be sure use the verification code provided by the user.";

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static final _databaseReference = FirebaseFirestore.instance;

  static final CollectionReference userCol =
      FirebaseFirestore.instance.collection(FrbCollection.fcUser);

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

  static Future<User?> singInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();

      return result.user;
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

  static Future<UserCredential?> signUp({
    required String email,
    required password,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

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

      UserCredential userCredential =
          await _auth.signInWithCredential(_authCredential);
      return userCredential.user;
    } on Exception catch (e) {
      logger.e(e);
      return null;
    }
  }

// ============================================================================
  /// ======= FIRE STORE ======= ::
// ============================================================================

  /// SET DATA :

  static Future<bool> setData() async {
    try {
      await userCol.doc("doc_id").set({});
      return true;
    } on Exception catch (e) {
      logger.e(e);
      return false;
    }
  }

  /// ADD DATA :

  static Future<bool> addUserInFireBase() async {
    try {
      await userCol.add({});
      return true;
    } on Exception catch (e) {
      logger.e(e);
      return false;
    }
  }

  /// UPDATE DATA :

  static Future<bool> updateData() async {
    try {
      await userCol.doc("doc_id").update({});
      return true;
    } on Exception catch (e) {
      logger.e(e);
      return false;
    }
  }

  /// GET PARTICULAR DATA :

  static Future<DocumentSnapshot?> getParticularData({
    required String collection,
    required String docId,
  }) async {
    try {
      return await _databaseReference.collection(collection).doc(docId).get();
    } catch (e) {
      logger.e(e);
    }
    return null;
  }

  /// ORDER_BY AND WHERE :

  static Future<QuerySnapshot?> orderWhereQuery() async {
    try {
      return await userCol
          .orderBy("", descending: true)
          .where("", isEqualTo: "")
          .where("", isEqualTo: true)
          .get();
    } on Exception catch (e) {
      logger.e(e);
      return null;
    }
  }

  /// STREAM :

  static Stream<QuerySnapshot>? stream({
    required int role,
  }) {
    try {
      return userCol
          .orderBy("", descending: true)
          .where("", isEqualTo: "")
          .where("", isEqualTo: true)
          .snapshots();
    } catch (e) {
      logger.e(e);
    }
    return null;
  }

  /// COLLECTION GROUP (FOR GET DATA FROM SUB COLLECTIONS) :

  static Future<QuerySnapshot?> getCollectionGroupData() async {
    try {
      return await _databaseReference
          .collectionGroup("sub_col_name")
          .where("", isEqualTo: "")
          .orderBy("", descending: true)
          .get();
    } catch (e) {
      logger.e(e);
      return null;
    }
  }

  /// STREAM LISTENER :

  static void streamListener({
    required String userId,
  }) {
    try {
      userCol
          .where("", isEqualTo: "")
          .where("", isEqualTo: true)
          .snapshots()
          .listen((event) async {
        /// RECEIVE UPDATED DATA WHEN SOME CHANGES IN COLLECTION
      });
    } catch (e) {
      logger.e(e);
    }
  }

// ============================================================================
  /// ======= UPLOAD MEDIA FIRE STORE ======= ::
// ============================================================================

  /// CONTENT TYPES ::
  /// IMAGE : "image/png"
  /// PDF DOC : "application/pdf"

  static Future<String> uploadMediaAndGetUrl({
    required File? file,
    required String fileName,
    required String conType,
  }) async {
    try {
      if (file != null) {
        Reference storageReference = FirebaseStorage.instance.ref().child(
              "users/${"user_id"}/${DateFormat("yyyy_MM_dd_hh_mm_ss").format(
                DateTime.now(),
              )}$fileName",
            );
        UploadTask uploadTask = storageReference.putData(
          file.readAsBytesSync(),
          SettableMetadata(contentType: conType),
        );
        await uploadTask;

        return await storageReference.getDownloadURL();
      } else {
        return "";
      }
    } on Exception catch (e) {
      logger.e(e);
      return "";
    }
  }

  static Future<String> uploadMediaAndGetUrlForWeb({
    required Uint8List? unitData,
    required String fileName,
    required String conType,
  }) async {
    try {
      if (unitData != null) {
        Reference storageReference = FirebaseStorage.instance.ref().child(
              "users/${"user_id"}/${DateFormat("yyyy_MM_dd_hh_mm_ss").format(
                DateTime.now(),
              )}$fileName",
            );
        UploadTask uploadTask = storageReference.putData(
          unitData,
          SettableMetadata(contentType: conType),
        );
        await uploadTask;

        return await storageReference.getDownloadURL();
      } else {
        return "";
      }
    } on Exception catch (e) {
      logger.e(e);
      return "";
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
