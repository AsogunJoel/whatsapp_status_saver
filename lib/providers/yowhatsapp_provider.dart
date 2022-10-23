import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saf/saf.dart';

import '../constants/constants.dart';
import '../directory_response/check_directory_response.dart';
import '../models/status_model.dart';

class GetYoStatusProvider with ChangeNotifier {
  List<StatusModel> _yogetImages = [];
  List<StatusModel> _yogetImagesss = [];
  List<StatusModel> _yogetVideos = [];
  List<StatusModel> _yogetVideosss = [];
  PermissionStatus? status;
  List<StatusModel> items = [];

  List<StatusModel> get yogetImages {
    return _yogetImages;
  }

  List<StatusModel> get yogetVideos {
    return _yogetVideos;
  }

  bool? isGranted;
  Saf? saf;
  Directory? directory;

  initializerYowhatsapp({ctx}) async {
    directory = Directory(AppConstants.YowhatsppPath);
    if (directory!.existsSync()) {
      saf = Saf(AppConstants.safYowhatsappconst);
      isGranted = await saf!.getDirectoryPermission(isDynamic: false);
    }
    status = await Permission.storage.request();
    Future.delayed(
      const Duration(milliseconds: 500),
    ).then(
      (value) {
        getYoWhatAppStatus(ctx: ctx);
      },
    );
    notifyListeners();
  }

  clearData() {
    _itemsData = DirectoryResponse.loading('loading... ');
    items.clear();
    if (_yogetImagesss.isNotEmpty) {
      _yogetImagesss.clear();
    }
    if (_yogetVideosss.isNotEmpty) {
      _yogetVideosss.clear();
    }
    if (_yogetImages.isNotEmpty) {
      _yogetImages.clear();
    }
    if (_yogetVideos.isNotEmpty) {
      _yogetVideos.clear();
    }
  }

  late DirectoryResponse<List<StatusModel>> _itemsData =
      DirectoryResponse.loading('');

  DirectoryResponse<List<StatusModel>> get itemsData => _itemsData;

  // var cachedFilesPath =
  // if (cachedFilesPath != null) {
  //   loadImage(cachedFilesPath);
  // }
  // var _paths = [];
  // loadImage(paths, {String k = ""}) {
  //   var tempPaths = [];
  //   for (String path in paths) {
  //     if (path.endsWith(".jpg")) {
  //       tempPaths.add(path);
  //     }
  //   }
  //   if (k.isNotEmpty) tempPaths.add(k);
  //   _paths = tempPaths;
  //   notifyListeners();
  // }

  Future<void> getYoWhatAppStatus({ctx}) async {
    _itemsData = DirectoryResponse.loading('loading... ');
    if (directory!.existsSync()) {
      final anodir = Directory(AppConstants.yoMyStatPath);
      if (status!.isGranted && isGranted != null && isGranted!) {
        await saf!.cache();
        try {
          items = anodir
              .listSync()
              .map(
                (e) => StatusModel.fromRTDB(e),
              )
              .toList();
          _yogetImagesss = items
              .where(
                (element) => element.status.path.endsWith('.jpg'),
              )
              .toList()
            ..sort(
              (l, r) => l.time.compareTo(r.time),
            );
          _yogetVideosss = items.where((element) {
            return element.status.path.contains('.mp4');
          }).toList()
            ..sort(
              (l, r) => l.time.compareTo(r.time),
            );
          _yogetVideos = _yogetVideosss.reversed.toList();
          _yogetImages = _yogetImagesss.reversed.toList();
          _itemsData = DirectoryResponse.completed(items);
          notifyListeners();
        } catch (e) {
          _itemsData = DirectoryResponse.error(
            e.toString(),
          );
        }
      } else if (isGranted != null && !isGranted!) {
        _itemsData = DirectoryResponse.error(
          'Allow permissions to view statuses',
        );
        showDialog(
          context: ctx,
          builder: (context) {
            return AlertDialog(
              title: const Text('Permissions manager'),
              content: const Text(
                'Allow WhatsApp Status Saver to access statuses.',
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    initializerYowhatsapp();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Allow'),
                )
              ],
            );
          },
        );
        notifyListeners();
      } else if (status!.isDenied) {
        initializerYowhatsapp();
      } else if (status!.isRestricted) {
      } else if (status!.isPermanentlyDenied) {
        openAppSettings();
      }
    } else {
      _itemsData = DirectoryResponse.error(
        'Something went wrong,\nYoWhatsapp not installed',
      );
      notifyListeners();
      showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: const Text('YoWhatsapp not installed'),
            content: const Text(
              'YoWhatsapp doesn\'t seem to be installed on your device.',
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('ok'),
              )
            ],
          );
        },
      );
    }
  }

  Future<int> findPersonUsingIndexWhere(String imageName) async {
    int index =
        yogetImages.indexWhere((element) => element.status.path == imageName);
    return index;
  }

  bool imageSaved = false;
  resetimageSaved() {
    imageSaved = false;
  }

  Future<void> refreshpaths(context) async {
    getYoWhatAppStatus().then(
      (value) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            backgroundColor: Colors.green,
            content: Text('Statuses refreshed'),
          ),
        );
      },
    );
    notifyListeners();
  }
}

// Future<void> getYoWhatAppStatus({ctx}) async {
//     if (status!.isDenied && status2!.isDenied) {
//       initializer();
//     }
//     if (status!.isGranted || status2!.isGranted) {
//       _itemsData = DirectoryResponse.loading('loading... ');
//       final directory = Directory(AppConstants.YowhatsppPath);
//       if (directory.existsSync()) {
//         try {
//           clearData();
//           items = directory
//               .listSync()
//               .map(
//                 (e) => StatusModel.fromRTDB(e),
//               )
//               .toList();
//           _yogetImagesss = items
//               .where(
//                 (element) => element.status.path.endsWith('.jpg'),
//               )
//               .toList()
//             ..sort(
//               (l, r) => l.time.compareTo(r.time),
//             );
//           _yogetVideosss = items
//               .where(
//                 (element) => element.status.path.contains('.mp4'),
//               )
//               .toList()
//             ..sort(
//               (l, r) => l.time.compareTo(r.time),
//             );
//           _yogetVideos = _yogetVideosss.reversed.toList();
//           _yogetImages = _yogetImagesss.reversed.toList();
//           _itemsData = DirectoryResponse.completed(items);
//           notifyListeners();
//         } catch (e) {
//           _itemsData = DirectoryResponse.error(
//             e.toString(),
//           );
//         }
//       } else {
//         _itemsData = DirectoryResponse.error(
//           'Something went wrong,\nYoWhatsapp not installed',
//         );
//         notifyListeners();
//         showDialog(
//           context: ctx,
//           builder: (context) {
//             return AlertDialog(
//               title: const Text('YoWhatsapp not installed'),
//               content: const Text(
//                 'YoWhatsapp doesn\'t seem to be installed on your device.',
//               ),
//               actions: [
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('ok'),
//                 )
//               ],
//             );
//           },
//         );
//       }
//     }
//   }
