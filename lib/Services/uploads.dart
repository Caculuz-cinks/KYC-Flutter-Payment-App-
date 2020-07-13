import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';

class CloudStorageService {
  Future uploadFile({File image, String uploadedFileURL}) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('profile/${Path.basename(image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    print('File Uploaded');

    storageReference.getDownloadURL().then((fileURL) {
      uploadedFileURL = fileURL;
    });
    return uploadFile();
  }
}
