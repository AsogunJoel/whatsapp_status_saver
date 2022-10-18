import 'dart:io';

import 'package:flutter/services.dart';
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
    );
  }
}
