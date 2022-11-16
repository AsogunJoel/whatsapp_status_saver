import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saf/saf.dart';

import '../constants/constants.dart';
import '../directory_response/check_directory_response.dart';
import '../models/status_model.dart';

class GBStatusProvider with ChangeNotifier {
  List<StatusModel> _gbgetImages = [];
  List<StatusModel> _gbgetImagesss = [];
  List<StatusModel> _gbgetVideos = [];
  List<StatusModel> _gbgetVideosss = [];
  PermissionStatus? status;
  List<StatusModel> items = [];

  List<StatusModel> get gbgetImages {
    return _gbgetImages;
  }

  List<StatusModel> get gbgetVideos {
    return _gbgetVideos;
  }

  bool? isGranted = false;
  Saf? saf1;
  Directory? directory;
  Directory? directory2;
  Directory? anodir;

  initializerGB({ctx}) async {
    _itemsData = DirectoryResponse.loading('loading... ');
    clearData();
    Future.delayed(
      const Duration(milliseconds: 1000),
    ).then(
      (value) async {
        directory = Directory(AppConstants.GBWhatsppPath);
        directory2 = Directory(AppConstants.GBWhatsppAlternatePath);
        if (directory!.existsSync()) {
          saf1 = Saf(AppConstants.safGBWhatsppPath);
          isGranted = await saf1!.getDirectoryPermission(isDynamic: false);
        } else if (directory2!.existsSync()) {
          saf1 = Saf(AppConstants.safGBWhatsppAlternativePath);
          isGranted = await saf1!.getDirectoryPermission(isDynamic: false);
        }
        status = await Permission.storage.request();
      },
    ).then((value) {
      getGBWhatsappStatus(ctx: ctx);
    });
  }

  clearData() {
    _itemsData = DirectoryResponse.loading('loading... ');
    items.clear();
    if (_gbgetImagesss.isNotEmpty) {
      _gbgetImagesss.clear();
    }
    if (_gbgetVideosss.isNotEmpty) {
      _gbgetVideosss.clear();
    }
    if (_gbgetImages.isNotEmpty) {
      _gbgetImages.clear();
    }
    if (_gbgetVideos.isNotEmpty) {
      _gbgetVideos.clear();
    }
  }

  late DirectoryResponse<List<StatusModel>> _itemsData =
      DirectoryResponse.loading('');

  DirectoryResponse<List<StatusModel>> get itemsData => _itemsData;
  Future<void> getGBWhatsappStatus({ctx}) async {
    _itemsData = DirectoryResponse.loading('loading... ');
    if (directory!.existsSync() || directory2!.existsSync()) {
      if (directory!.existsSync()) {
        anodir = Directory(AppConstants.gbwhatsappMyStatPath);
      } else {
        anodir = Directory(AppConstants.gbwhatsappMyStatAlternativePath);
      }
      if (status!.isGranted && isGranted != null && isGranted!) {
        try {
          _itemsData =
              DirectoryResponse.loading('Please wait, getting statuses');
          if (anodir!.existsSync()) {
            await saf1!.cache();
            await saf1!.sync();
          }
          if (!anodir!.existsSync()) {
            await saf1!.cache();
          }
          items = anodir!
              .listSync()
              .map(
                (e) => StatusModel.fromRTDB(e),
              )
              .toList();
          _gbgetImagesss = items
              .where(
                (element) => element.status.path.endsWith('.jpg'),
              )
              .toList()
            ..sort(
              (l, r) => l.time.compareTo(r.time),
            );
          _gbgetVideosss = items
              .where(
                (element) => element.status.path.contains('.mp4'),
              )
              .toList()
            ..sort(
              (l, r) => l.time.compareTo(r.time),
            );
          _gbgetVideos = _gbgetVideosss.reversed.toList();
          _gbgetImages = _gbgetImagesss.reversed.toList();
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
                    initializerGB();
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
        'Something went wrong,\nGB WhatsApp not installed',
      );
      notifyListeners();
      showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: const Text('GB WhatsApp not installed'),
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

  Future<int> findPersonUsingIndexWhere(String imageName) async {
    int index =
        gbgetImages.indexWhere((element) => element.status.path == imageName);
    return index;
  }

  bool imageSaved = false;
  resetimageSaved() {
    imageSaved = false;
  }

  Future<void> refreshpaths(context) async {
    clearData();
    getGBWhatsappStatus().then(
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

  @override
  void dispose() {
    super.dispose();
    clearData();
  }
}
