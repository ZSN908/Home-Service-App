import 'dart:developer';
import 'dart:io';

import 'package:cloudinary/cloudinary.dart';
import 'package:home_service/constants/secrets.dart';

class CloudinaryService {
  static final cloudinary = Cloudinary.signedConfig(
    apiKey: CloudinaryConfig.apiKey,
    apiSecret: CloudinaryConfig.apiSecret,
    cloudName: CloudinaryConfig.cloudName,
  );

  static Future<String?> uploadImage(File imageFile, String folderName) async {
    try {
      final response = await cloudinary.upload(
        file: imageFile.path,
        resourceType: CloudinaryResourceType.image,
        folder: folderName,
        fileName: 'profile_${DateTime.now().millisecondsSinceEpoch}',
        progressCallback: (count, total) {
          log('Uploading image: $count/$total bytes');
        },
      );

      if (response.isSuccessful) {
        log('Image uploaded successfully: ${response.secureUrl}');
        return response.secureUrl;
      } else {
        log('Failed to upload image: ${response.error}');
        return null;
      }
    } catch (e) {
      log('Error uploading image: $e');
      return null;
    }
  }

  static Future<bool> deleteImage(String imageUrl) async {
    try {
      // Extract the public_id by removing the version segment
      final segments = imageUrl.split('/');
      final folderPath = segments
          .sublist(segments.indexOf('upload') + 1, segments.length - 1)
          .where((segment) => !segment.startsWith('v'))
          .join('/');
      final fileName = segments.last.split('.').first;
      final publicId = '$folderPath/$fileName';

      log('Public ID to delete: $publicId');

      // Perform the deletion
      final response = await cloudinary.destroy(
        publicId,
        resourceType: CloudinaryResourceType.image,
        invalidate: true,
      );

      if (response.isSuccessful) {
        log('Image deleted successfully: $publicId');
        return true;
      } else {
        log('Failed to delete image: ${response.error}');
        return false;
      }
    } catch (e) {
      log('Error deleting image from Cloudinary: $e');
      return false;
    }
  }
}
