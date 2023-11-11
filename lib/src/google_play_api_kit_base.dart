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
    await _checkAppBundleExits(appBundle);
    final artifactLength = await appBundle.length();
    final artifactStream = appBundle.openRead();

    return Media(artifactStream, artifactLength,
        contentType: 'application/octet-stream');
  }

  Future<void> _checkAppBundleExits(File appBundle) async {
    final isExist = await appBundle.exists();
    if (isExist) {
      print('AAB is exist');
    } else {
      throw Exception('AAB is not exist');
    }
  }

  Future<void> uploadArtifact({
    required AndroidPublisherApi publisherApi,
    required String packageName,
    required String appBundlePath,
  }) async {
    _checkAppBundlePath(appBundlePath);
    final appBundle = File(appBundlePath);
    final media = await _appBundle(appBundle);

    // editId

    final response = await publisherApi.edits.insert(
      AppEdit(),
      packageName,
    );
    final editId = response.id;

    final result = await publisherApi.edits.bundles.upload(
      packageName,
      editId!,
      uploadMedia: media,
    );

    // final internalSharingArtifact =
    //     await publisherApi.internalappsharingartifacts.uploadbundle(
    //   packageName,
    //   uploadMedia: media,
    // );
    print('AAB was uploaded: ${result.toJson()}');
  }

  void _checkAppBundlePath(String appBundlePath) {
    if (appBundlePath.endsWith('.aab')) {
      print('AAB is valid');
    } else {
      throw Exception('AAB is invalid');
    }
  }
}
