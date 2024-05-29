import 'dart:io';

import 'package:image_picker/image_picker.dart';

class MediaService {
  final ImagePicker _picker = ImagePicker();

  MediaService() {}

  Future<File?> getImageFromGallery({int? maxWidth, int? maxHeight}) async {
  final XFile? _file = await _picker.pickImage(
    source: ImageSource.gallery,
    maxWidth: maxWidth != null ? maxWidth.toDouble() : null,
    maxHeight: maxHeight != null ? maxHeight.toDouble() : null,
  );
  if (_file != null) {
    return File(_file.path);
  }
  return null;
}


}
