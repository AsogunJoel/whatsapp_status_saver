import 'dart:io';

class StatusModel {
  final FileSystemEntity status;
  final DateTime time;
  String fileName;
  String? thumbnail;

  StatusModel({
    required this.status,
    required this.time,
    required this.fileName,
    this.thumbnail,
  });

  factory StatusModel.fromRTDB(
    FileSystemEntity data,
  ) {
    return StatusModel(
      status: data,
      time: data.statSync().modified,
      fileName: data.path.split("/").last,
    );
  }
}

// class OriginalList {
//   final String? file;
//   int fileIndex;

//   OriginalList({
//     required this.file,
//     required this.fileIndex,
//   });
//   factory OriginalList.fromRTDB(
//     data,
//     List<StatusModel> list,
//   ) {
//     final index1 = list.indexWhere(
//       (element) => element.fileName == data.split("/").last,
//     );
//     return OriginalList(
//       file: data.split("/").last,
//       fileIndex: index1,
//     );
//   }
// }
