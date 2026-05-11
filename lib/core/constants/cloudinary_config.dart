/// Cloudinary Configuration
///
/// Get these from your Cloudinary Dashboard:
/// 1. Go to https://cloudinary.com/console
/// 2. Copy your Cloud Name
/// 3. Create an Upload Preset (Signing mode: **Unsigned**)
///
/// Prefer build-time overrides so you are not tied to a template cloud:
/// `flutter run --dart-define=CLOUDINARY_CLOUD_NAME=xxx --dart-define=CLOUDINARY_UPLOAD_PRESET=yyy`
class CloudinaryConfig {
  static const String cloudName = String.fromEnvironment(
    'CLOUDINARY_CLOUD_NAME',
    defaultValue: 'daoa8xc8t',
  );

  /// Preset name; must exist on your cloud and allow **unsigned** uploads.
  static const String uploadPreset = String.fromEnvironment(
    'CLOUDINARY_UPLOAD_PRESET',
    defaultValue: 'ProfileImages',
  );

  static String get uploadUrl =>
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
}
