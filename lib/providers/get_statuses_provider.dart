import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_api/flutter_native_api.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_status_saver/constants/constants.dart';
import 'package:whatsapp_status_saver/directory_response/check_directory_response.dart';
import 'package:whatsapp_status_saver/models/status_model.dart';

class GetStatusProvider with ChangeNotifier {
  List<StatusModel> _getImages = [];
  List<StatusModel> _getImagesss = [];
  List<StatusModel> _getVideos = [];
  List<StatusModel> _getVideosss = [];
  PermissionStatus? status;
  PermissionStatus? status2;
  List<StatusModel> items = [];

  List<StatusModel> get getImages {
    return _getImages;
  }

  List<StatusModel> get getVideos {
    return _getVideos;
  }

  initializerWhatsapp({ctx}) async {
    status = await Permission.storage.request();
    status2 = await Permission.manageExternalStorage.request();
    getWhatsappStatus(ctx: ctx);
  }

  initializerWABusiness({ctx}) async {
    status = await Permission.storage.request();
    status2 = await Permission.manageExternalStorage.request();
    getWABusinessStatus(ctx: ctx);
  }

  initializerGB({ctx}) async {
    status = await Permission.storage.request();
    status2 = await Permission.manageExternalStorage.request();
    getGBWhatsappStatus(ctx: ctx);
  }

  initializerYowhatsapp({ctx}) async {
    status = await Permission.storage.request();
    status2 = await Permission.manageExternalStorage.request();
    getYoWhatAppStatus(ctx: ctx);
  }

  initializer({ctx}) async {
    status = await Permission.storage.request();
    status2 = await Permission.manageExternalStorage.request();
  }

  clearData() {
    _itemsData = DirectoryResponse.loading('loading... ');
    items.clear();
    _getImagesss.clear();
    _getVideosss.clear();
    _getImages.clear();
    _getVideos.clear();
    notifyListeners();
  }

  late DirectoryResponse<List<StatusModel>> _itemsData =
      DirectoryResponse.loading('');

  DirectoryResponse<List<StatusModel>> get itemsData => _itemsData;
  Future<void> getYoWhatAppStatus({ctx}) async {
    if (status!.isDenied && status2!.isDenied) {
      initializer();
    }
    if (status!.isGranted || status2!.isGranted) {
      _itemsData = DirectoryResponse.loading('loading... ');
      final directory = Directory(AppConstants.YowhatsppPath);
      if (directory.existsSync()) {
        try {
          clearData();
          items = directory
              .listSync()
              .map(
                (e) => StatusModel.fromRTDB(e),
              )
              .toList();
          _getImagesss = items
              .where(
                (element) => element.status.path.endsWith('.jpg'),
              )
              .toList()
            ..sort(
              (l, r) => l.time.compareTo(r.time),
            );
          _getVideosss = items
              .where(
                (element) => element.status.path.contains('.mp4'),
              )
              .toList()
            ..sort(
              (l, r) => l.time.compareTo(r.time),
            );
          _getVideos = _getVideosss.reversed.toList();
          _getImages = _getImagesss.reversed.toList();
          _itemsData = DirectoryResponse.completed(items);
          notifyListeners();
        } catch (e) {
          _itemsData = DirectoryResponse.error(
            e.toString(),
          );
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
  }

  void getWhatsappStatus({ctx}) async {
    if (status!.isDenied || status2!.isDenied) {
      initializer();
    }
    if (status!.isGranted || status2!.isGranted) {
      _itemsData = DirectoryResponse.loading('loading... ');
      final directory = Directory(AppConstants.WhatsppPath);
      if (directory.existsSync()) {
        try {
          clearData();
          items = directory
              .listSync()
              .map(
                (e) => StatusModel.fromRTDB(e),
              )
              .toList();
          _getImagesss = items
              .where(
                (element) => element.status.path.endsWith('.jpg'),
              )
              .toList()
            ..sort(
              (l, r) => l.time.compareTo(r.time),
            );
          _getVideosss = items
              .where(
                (element) => element.status.path.contains('.mp4'),
              )
              .toList()
            ..sort(
              (l, r) => l.time.compareTo(r.time),
            );
          _getVideos = _getVideosss.reversed.toList();
          _getImages = _getImagesss.reversed.toList();
          _itemsData = DirectoryResponse.completed(items);
          notifyListeners();
        } catch (e) {
          _itemsData = DirectoryResponse.error(
            e.toString(),
          );
        }
      } else {
        _itemsData = DirectoryResponse.error(
          'Something went wrong,\nWhatsapp not installed',
        );
        notifyListeners();
        showDialog(
          context: ctx,
          builder: (context) {
            return AlertDialog(
              title: const Text('WhatsApp not installed'),
              content: const Text(
                'WhatsApp doesn\'t seem to be installed on your device.',
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
  }

  void getWABusinessStatus({ctx}) async {
    _itemsData = DirectoryResponse.loading('loading... ');
    if (status!.isDenied || status2!.isDenied) {
      initializerWABusiness();
    }
    if (status!.isGranted || status2!.isGranted) {
      final directory = Directory(AppConstants.BWhatsppPath);
      if (directory.existsSync()) {
        try {
          clearData();
          items = directory
              .listSync()
              .map(
                (e) => StatusModel.fromRTDB(e),
              )
              .toList();
          _getImagesss = items
              .where(
                (element) => element.status.path.endsWith('.jpg'),
              )
              .toList()
            ..sort(
              (l, r) => l.time.compareTo(r.time),
            );
          _getVideosss = items
              .where(
                (element) => element.status.path.contains('.mp4'),
              )
              .toList()
            ..sort(
              (l, r) => l.time.compareTo(r.time),
            );
          _getVideos = _getVideosss.reversed.toList();
          _getImages = _getImagesss.reversed.toList();
          _itemsData = DirectoryResponse.completed(items);
          notifyListeners();
        } catch (e) {
          _itemsData = DirectoryResponse.error(
            e.toString(),
          );
        }
      } else {
        _itemsData = DirectoryResponse.error(
          'Something went wrong,\nBusiness Whatsapp not installed',
        );
        notifyListeners();
        showDialog(
          context: ctx,
          builder: (context) {
            return AlertDialog(
              title: const Text('Business WhatsApp not installed'),
              content: const Text(
                'Business WhatsApp doesn\'t seem to be installed on your device.',
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
  }

  void getGBWhatsappStatus({ctx}) async {
    _itemsData = DirectoryResponse.loading('loading... ');
    if (status!.isDenied || status2!.isDenied) {
      initializerWABusiness();
    }
    if (status!.isGranted || status2!.isGranted) {
      final directory = Directory(AppConstants.GBWhatsppPath);
      if (directory.existsSync()) {
        try {
          clearData();
          items = directory
              .listSync()
              .map(
                (e) => StatusModel.fromRTDB(e),
              )
              .toList();
          _getImagesss = items
              .where(
                (element) => element.status.path.endsWith('.jpg'),
              )
              .toList()
            ..sort(
              (l, r) => l.time.compareTo(r.time),
            );
          _getVideosss = items
              .where(
                (element) => element.status.path.contains('.mp4'),
              )
              .toList()
            ..sort(
              (l, r) => l.time.compareTo(r.time),
            );
          _getVideos = _getVideosss.reversed.toList();
          _getImages = _getImagesss.reversed.toList();
          _itemsData = DirectoryResponse.completed(items);
          notifyListeners();
        } catch (e) {
          _itemsData = DirectoryResponse.error(
            e.toString(),
          );
        }
      } else {
        _itemsData = DirectoryResponse.error(
          'Something went wrong,\nGB whatsApp not installed',
        );
        notifyListeners();
        showDialog(
          context: ctx,
          builder: (context) {
            return AlertDialog(
              title: const Text('GB whatsApp not installed'),
              content: const Text(
                'GB whatsApp doesn\'t seem to be installed on your device.',
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
  }

  bool imageSaved = false;
  Future<dynamic> saveImagetoGallery(imagePath) async {
    await ImageGallerySaver.saveFile(imagePath);
    imageSaved = true;
    notifyListeners();
  }

  bool shareloading = false;
  Future<dynamic> shareImage(imagePath) async {
    shareloading = true;
    await FlutterNativeApi.shareImage(imagePath);
    shareloading = false;
    notifyListeners();
  }

  Future<dynamic> printImage(imagePath, imagePathTitle) async {
    await FlutterNativeApi.printImage(imagePath, imagePathTitle);
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
//           _getImagesss = items
//               .where(
//                 (element) => element.status.path.endsWith('.jpg'),
//               )
//               .toList()
//             ..sort(
//               (l, r) => l.time.compareTo(r.time),
//             );
//           _getVideosss = items
//               .where(
//                 (element) => element.status.path.contains('.mp4'),
//               )
//               .toList()
//             ..sort(
//               (l, r) => l.time.compareTo(r.time),
//             );
//           _getVideos = _getVideosss.reversed.toList();
//           _getImages = _getImagesss.reversed.toList();
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