import 'package:flutter/material.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          AppBar(
            elevation: 0,
            title: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'WhatsApp Saver',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  letterSpacing: .4,
                ),
              ),
            ),
            automaticallyImplyLeading: false,
            toolbarHeight: 100,
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text(
              'Share App',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text(
              'Rate App',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.policy),
            title: const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.more),
            title: const Text(
              'More Apps',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text(
              'About',
              style: TextStyle(fontSize: 15),
            ),
            onTap: () {},
          ),
          const SizedBox(
            height: 200,
          ),
          const Text(
            'by \nSHOGUNCODER',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 15,
              letterSpacing: .5,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
