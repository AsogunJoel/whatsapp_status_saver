import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_api/flutter_native_api.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saf/saf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/constants.dart';
import '../directory_response/check_directory_response.dart';
import '../models/status_model.dart';

class GetStatusProvider with ChangeNotifier {
  List<StatusModel> _getImages = [];
  List<StatusModel> _getImagesss = [];
  List<StatusModel> _getVideos = [];
  List<StatusModel> _getVideosss = [];
  PermissionStatus? status;
  List<StatusModel> items = [];

  List<StatusModel> get getImages {
    return _getImages;
  }

  List<StatusModel> get getVideos {
    return _getVideos;
  }

  bool? isGranted;
  Saf? saf;
  Directory? directory;
  Directory? directory2;
  Directory? anodir;

  initializerWhatsapp({ctx}) async {
    clearData();
    Future.delayed(
      const Duration(milliseconds: 1000),
    ).then(
      (value) async {
        directory = Directory(AppConstants.WhatsppPath);
        directory2 = Directory(AppConstants.WhatsppAlternativePath);
        if (directory!.existsSync()) {
          saf = Saf(AppConstants.safWhatsppPath);
          isGranted = await saf!.getDirectoryPermission(isDynamic: false);
        } else if (directory2!.existsSync()) {
          saf = Saf(AppConstants.safWhatsppAlternativePath);
          isGranted = await saf!.getDirectoryPermission(isDynamic: false);
        }
        status = await Permission.storage.request();
      },
    ).then((value) {
      getWhatsappStatus(ctx: ctx);
    });
    notifyListeners();
  }

  initializer({ctx}) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    print(statuses[Permission.storage]);
  }

  clearData() {
    _itemsData = DirectoryResponse.loading('loading... ');
    items.clear();
    if (_getImagesss.isNotEmpty) {
      _getImagesss.clear();
    }
    if (_getVideosss.isNotEmpty) {
      _getVideosss.clear();
    }
    if (_getImages.isNotEmpty) {
      _getImages.clear();
    }
    if (_getVideos.isNotEmpty) {
      _getVideos.clear();
    }
  }

  late DirectoryResponse<List<StatusModel>> _itemsData =
      DirectoryResponse.loading('');

  DirectoryResponse<List<StatusModel>> get itemsData => _itemsData;
  Future<void> getWhatsappStatus({ctx}) async {
    if (directory!.existsSync()) {
      if (directory!.existsSync()) {
        anodir = Directory(AppConstants.whatsappMyStatPath);
      } else {
        anodir = Directory(AppConstants.whatsappMyStatAlternativePath);
      }
      if (status!.isGranted && isGranted != null && isGranted!) {
        try {
          _itemsData =
              DirectoryResponse.loading('Please wait, getting statuses');

          if (anodir!.existsSync()) {
            await saf!.cache();
            await saf!.sync();
          }
          if (!anodir!.existsSync()) {
            await saf!.cache();
          }
          items = anodir!
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
                    initializerWhatsapp();
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
        _itemsData = DirectoryResponse.error(
          'Acccept permissions to view statuses',
        );
        status = await Permission.storage.request();
        notifyListeners();
      } else if (status!.isRestricted) {
      } else if (status!.isPermanentlyDenied) {
        openAppSettings();
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

  Future<int> findPersonUsingIndexWhere(String imageName) async {
    int index =
        getImages.indexWhere((element) => element.status.path == imageName);
    return index;
  }

  bool imageSaved = false;
  resetimageSaved() {
    if (imageSaved) {
      imageSaved = false;
      notifyListeners();
    }
  }

  Future<void> refreshpaths(context) async {
    clearData();
    getWhatsappStatus().then(
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

  Future<dynamic> saveImagetoGallery(imagePath) async {
    loading = true;
    await ImageGallerySaver.saveFile(imagePath).then((value) {
      print(value);
    });
    imageSaved = true;
    loading = false;
    notifyListeners();
  }

  bool loading = false;
  Future<dynamic> shareImage(imagePath) async {
    loading = true;
    await Share.shareFiles([imagePath]);
    loading = false;
    notifyListeners();
  }

  Future<dynamic> shareVideo(videoPath) async {
    loading = true;
    await Share.shareFiles([videoPath]);
    loading = false;
    notifyListeners();
  }

  Future<dynamic> shareLink(videoPath) async {
    loading = true;
    await Share.share(videoPath);
    loading = false;
    notifyListeners();
  }

  Future<dynamic> printImage(imagePath, imagePathTitle) async {
    loading = true;
    await FlutterNativeApi.printImage(imagePath, imagePathTitle);
    loading = false;
    notifyListeners();
  }

  Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    super.dispose();
    clearData();
  }
}
