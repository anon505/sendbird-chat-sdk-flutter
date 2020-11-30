// import 'dart:isolate';
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart';

import '../../constant/error_code.dart';
import '../../models/error.dart';
import '../../services/command/command_manager.dart';
import '../../utils/logger.dart';
import '../../utils/utils.dart';

class SessionManager with SdkAccessor {
  String _sessionKey;
  String _eKey;
  String _userId;
  String _sessionKeyPath = "com.sendbird.sdk.messaging.sessionkey";
  String _userIdKeyPath = "com.sendbird.sdk.messaging.userid";
  int _sessionExpiresIn;
  bool isOpened;

  bool isRefreshingKey = false;

  //temporary
  // String encryptedUserId;
  // String sessionPath;

  // SendbirdSdkInternal sdk;

  // SessionManager(this.sdk);
  // Isolate isolate;

  // static final SessionManager _instance = SessionManager._internal();

  // factory SessionManager() {
  //   return _instance;
  // }

  // SessionManager._internal() {
  //   //TODO: grap http instance or singleton
  //   // HttpClient().errorController.stream.listen(
  //   //   (event) {},
  //   //   onError: (SendbirdError error) {
  //   //     if (error.code == ErrorCode.sessionKeyExpired) {
  //   //       updateSession();
  //   //     }
  //   //   },
  //   // );
  // }

  /// Set a `path` to store session key.
  /// Recommend to set your own path to store this path for security purpose
  void setSessionKeyPath(String path) {
    _sessionKeyPath = path;
  }

  /// Set a `path` to store user id key.
  /// Recommend to set your own path to store this path for security purpose
  void setUserIdKeyPath(String path) {
    _userIdKeyPath = path;
  }

  void setSessionExpiresIn(int timestamp) {
    _sessionExpiresIn = timestamp;
  }

  int get sessionExpiresIn => _sessionExpiresIn;

  /// Set a `sessionKey` that will be used for SDK globally
  ///
  /// This method will also encrypt this key and store in prefs
  Future<void> setSessionKey(String sessionKey) async {
    _sessionKey = sessionKey;
    await _encryptedSessionKey(sessionKey);
  }

  /// Get current `sessionKey` from prefs
  Future<String> getSessionKey() async {
    String decryptedKey = await _decryptedSessionKey();
    if (_sessionKey == null) {
      _sessionKey = decryptedKey;
    }
    return decryptedKey;
  }

  /// Set a `eKey` that will be used to access file url where
  /// authorization is required
  void setEKey(String eKey) {
    _eKey = eKey;
  }

  /// Get current `eKey`
  ///
  /// This is only existed in memory and will not be stored in
  /// persistent storage
  String getEKey() {
    return _eKey;
  }

  /// Set a `userId` associate with this user session
  void setUserId(String userId) {
    _userId = userId;
  }

  /// Get `userId` associate with this user session
  String getUserId() {
    return _userId;
  }

  Future<String> _decryptedSessionKey() async {
    final prefs = await SharedPreferences.getInstance();
    final encryptedUserId = prefs.getString(_userIdKeyPath);

    if (encryptedUserId == null) {
      logger.e("userid is not found in prefs");
      return null;
    }

    final key = Key.fromUtf8(encryptedUserId);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    // final encryptedSessionKey = sessionPath;
    final encryptedSessionKey = prefs.getString(_sessionKeyPath);
    return encrypter.decrypt(Encrypted.fromBase64(encryptedSessionKey), iv: iv);
  }

  Future<void> _encryptedSessionKey(String sessionKey) async {
    final prefs = await SharedPreferences.getInstance();
    if (sessionKey == null) {
      logger.i("Session key is set to null, all paths will be removed");
      prefs.remove(_userIdKeyPath);
      prefs.remove(_sessionKeyPath);
      throw InvalidParameterError();
    }

    if (_userId == null) {
      logger.e("Please set `userId` before you perform session key encryption");
      throw InvalidParameterError();
    }

    var id = '';
    if (_userId.length >= 24) {
      id = _userId.substring(0, 24);
    } else {
      id = _userId + getRandomString(24 - _userId.length);
    }
    final userIdData = utf8.encode(id);
    final base64UserId = base64.encode(userIdData);
    // encryptedUserId = base64UserId;
    prefs.setString(_userIdKeyPath, base64UserId);

    final key = Key.fromUtf8(base64UserId);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    final encryptedData = encrypter.encrypt(sessionKey, iv: iv);
    // sessionPath = encryptedData.base64;
    prefs.setString(_sessionKeyPath, encryptedData.base64);

    logger.i("encryption completed userId: $base64UserId " +
        "sessionKey: $encryptedData");
  }

  //WIP
  Future<void> updateSession() async {
    if (isRefreshingKey) {
      return;
      // throw Error(); //doing refresh atm throw error or do nothing
    }

    final hasCallback =
        false; //CallbackProcessor.shared().sessionHandler != null;
    isRefreshingKey = true;

    try {
      final res = await sdk.api.updateSessionKey(
        appId: '', //get from state
        sessionKey: '', //get from state
        expiringSession: hasCallback,
      );
      isRefreshingKey = false;
      _applyRefreshedSessionKey(res);
    } on SBError catch (err) {
      if (err.code == ErrorCode.accessTokenNotValid) {
        // CallbackProcessor.shared().notifySessionTokenRequired();
      } else {
        // CallbackProcessor.shared().notifySessionError(err);
      }
      isRefreshingKey = false;
    }
    return;
  }

  void _applyRefreshedSessionKey(Map<String, dynamic> payload) {
    if (payload['key'] != null) {
      setSessionKey(payload['key']);
    } else if (payload['new_key'] != null) {
      setSessionKey(payload['new_key']);
    }

    if (payload['expires_in'] != null) {
      setSessionExpiresIn(payload['expires_in']);
    }

    //flush waiting items in queue?
    // CallbackProcessor.shared().notifySessionRefreshed();

    if (_sessionExpiresIn <= 0) {
      //reconnect
    }
  }

  void cleanUp() {
    _sessionExpiresIn = 0;
    _eKey = null;
    _sessionKey = null;
  }
}