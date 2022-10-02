import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status_saver/directory_response/check_directory_response.dart';
import 'package:whatsapp_status_saver/providers/get_statuses_provider.dart';
import 'package:whatsapp_status_saver/screens/widgets/image/image_view.dart';

class WhatsappImagePage extends StatelessWidget {
  const WhatsappImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GetStatusProvider>(
        builder: (context, file, child) {
          if (file.itemsData.status == Status.COMPLETED &&
              file.getImages.isNotEmpty) {
            return GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: MediaQuery.of(context).size.width / 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 2.5 / 3,
              ),
              padding: const EdgeInsets.all(8),
              itemCount: file.getImages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => ImageView(
                          imagePath: file.getImages[index].status.path,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(
                          file.getImages[index].status.path,
                        ),
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                          child: Text(
                            'Unavailable, please refresh',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (file.itemsData.status == Status.LOADING) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (file.getImages.isEmpty) {
            return const Center(
              child: Text(
                'No recently viewed status pictures',
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: .5,
                  fontSize: 15,
                ),
              ),
            );
          } else {
            return const Center(
              child: Text(
                'Something went wrong',
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: .5,
                  fontSize: 15,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
