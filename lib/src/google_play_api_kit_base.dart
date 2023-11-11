import 'dart:io';

import 'package:googleapis/androidpublisher/v3.dart';
import 'package:googleapis_auth/auth_io.dart';

class GooglePlayApiKit {
  Future<AndroidPublisherApi> signInWithServiceAccountJson(
    Object serviceAccountJson,
  ) async {
    final accountCredentials =
        ServiceAccountCredentials.fromJson(serviceAccountJson);
    final scopes = [AndroidPublisherApi.androidpublisherScope];
    final client = await clientViaServiceAccount(
      accountCredentials,
      scopes,
    );

    return AndroidPublisherApi(client);
  }

  Future<Media> _appBundle(File appBundle) async {
    final artifactLength = await appBundle.length();
    final artifactStream = appBundle.openRead();

    return Media(artifactStream, artifactLength,
        contentType: 'application/octet-stream');
  }

  Future<void> uploadArtifact({
    required AndroidPublisherApi publisherApi,
    required String packageName,
    required String appBundlePath,
  }) async {
    _checkAppBundle(appBundlePath);
    final appBundle = File(appBundlePath);
    final media = await _appBundle(appBundle);
    final internalSharingArtifact =
        await publisherApi.internalappsharingartifacts.uploadbundle(
      packageName,
      uploadMedia: media,
    );
    print('AAB was uploaded: ${internalSharingArtifact.toJson()}');
  }

  void _checkAppBundle(String appBundlePath) {
    if (appBundlePath.endsWith('.aab')) {
      print('AAB is valid');
    } else {
      throw Exception('AAB is invalid');
    }
  }
}
