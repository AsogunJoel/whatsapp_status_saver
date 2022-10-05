import 'dart:io';

import 'package:flutter/services.dart';

class StatusModel {
  final FileSystemEntity status;
  final DateTime time;
  Uint8List? thumbnail;

  StatusModel({
    required this.status,
    required this.time,
    this.thumbnail,
  });

  factory StatusModel.fromRTDB(FileSystemEntity data) {
    return StatusModel(
      status: data,
      time: data.statSync().modified,
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
