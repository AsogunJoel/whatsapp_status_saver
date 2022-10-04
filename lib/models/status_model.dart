import 'dart:io';

import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:whatsapp_status_saver/utils/get_thumbails.dart';

class StatusModel {
  final FileSystemEntity status;
  final DateTime time;
  String? thumbnail;

  StatusModel({
    required this.status,
    required this.time,
    this.thumbnail,
  });

  factory StatusModel.fromRTDB(FileSystemEntity data) {
    return StatusModel(
      status: data,
      time: data.statSync().modified,
      // thumbnail: thumbnail(path),
    );
  }
}


// class StatusModel {
//   final FileSystemEntity status;
//   final DateTime time;

//   StatusModel({
//     required this.status,
//     required this.time,
//   });

//   factory StatusModel.fromRTDB(FileSystemEntity data) {
//     return StatusModel(
//       status: data,
//       time: data.statSync().modified,
//     );
//   }
// }
