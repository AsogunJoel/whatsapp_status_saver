import 'dart:io';

class StatusModel {
  final FileSystemEntity status;
  final DateTime time;

  StatusModel({
    required this.status,
    required this.time,
  });

  factory StatusModel.fromRTDB(FileSystemEntity data) {
    return StatusModel(
      status: data,
      time: data.statSync().modified,
    );
  }
}
