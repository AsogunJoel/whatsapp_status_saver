import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saf/saf.dart';

import '../constants/constants.dart';
import '../directory_response/check_directory_response.dart';
import '../models/status_model.dart';

class BusinessStatusProvider with ChangeNotifier {
  List<StatusModel> _businessgetImages = [];
  List<StatusModel> _businessgetImagesss = [];
  List<StatusModel> _businessgetVideos = [];
  List<StatusModel> _businessgetVideosss = [];
  PermissionStatus? status;
  List<StatusModel> items = [];

  List<StatusModel> get businessgetImages {
    return _businessgetImages;
  }

  List<StatusModel> get businessgetVideos {
    return _businessgetVideos;
  }

  bool? isGranted = false;
  Saf? saf2;
  Directory? directory;
  initializerWABusiness({ctx}) async {
    directory = Directory(AppConstants.BWhatsppPath);
    if (directory!.existsSync()) {
      saf2 = Saf(AppConstants.safBWhatsppPath);
      isGranted = await saf2!.getDirectoryPermission(isDynamic: false);
    }
    status = await Permission.storage.request();
    Future.delayed(
      const Duration(milliseconds: 500),
    ).then(
      (value) {
        getWABusinessStatus(ctx: ctx);
      },
    );
    notifyListeners();
  }

  clearData() {
    _itemsData = DirectoryResponse.loading('loading... ');
    items.clear();
    if (_businessgetImagesss.isNotEmpty) {
      _businessgetImagesss.clear();
    }
    if (_businessgetVideosss.isNotEmpty) {
      _businessgetVideosss.clear();
    }
    if (_businessgetImages.isNotEmpty) {
      _businessgetImages.clear();
    }
    if (_businessgetVideos.isNotEmpty) {
      _businessgetVideos.clear();
    }
  }

  late DirectoryResponse<List<StatusModel>> _itemsData =
      DirectoryResponse.loading('');

  DirectoryResponse<List<StatusModel>> get itemsData => _itemsData;
  Future<void> getWABusinessStatus({ctx}) async {
    _itemsData = DirectoryResponse.loading('loading... ');
    if (directory!.existsSync()) {
      final anodir = Directory(AppConstants.bwhatsappMyStatPath);
      if (status!.isGranted && isGranted != null && isGranted!) {
        try {
          await saf2!.cache().then((value) {
            print(value);
          });
          items = anodir
              .listSync()
              .map(
                (e) => StatusModel.fromRTDB(e),
              )
              .toList();
          _businessgetImagesss = items
              .where(
                (element) => element.status.path.endsWith('.jpg'),
              )
              .toList()
            ..sort(
              (l, r) => l.time.compareTo(r.time),
            );
          _businessgetVideosss = items
              .where(
                (element) => element.status.path.contains('.mp4'),
              )
              .toList()
            ..sort(
              (l, r) => l.time.compareTo(r.time),
            );
          _businessgetVideos = _businessgetVideosss.reversed.toList();
          _businessgetImages = _businessgetImagesss.reversed.toList();
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
                    initializerWABusiness();
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

  Future<int> findPersonUsingIndexWhere(String imageName) async {
    int index = businessgetImages
        .indexWhere((element) => element.status.path == imageName);
    return index;
  }

  bool imageSaved = false;
  resetimageSaved() {
    imageSaved = false;
  }

  Future<void> refreshpaths(context) async {
    getWABusinessStatus().then(
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
    ;
    notifyListeners();
  }
}
