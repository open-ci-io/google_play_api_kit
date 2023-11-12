import 'package:google_play_api_kit/google_play_api_kit.dart';

Object serviceAccountJson = {};
const packageName = 'com.example.app';
const aabFilePath = 'path/to/app.aab';

Future<void> main() async {
  final googlePlayApiKit = GooglePlayApiKit();

  final publisherApi = await googlePlayApiKit.signInWithServiceAccountJson(
    serviceAccountJson,
  );

  await googlePlayApiKit.uploadArtifact(
    androidPublisherApi: publisherApi,
    packageName: packageName,
    appBundlePath: aabFilePath,
  );
}
