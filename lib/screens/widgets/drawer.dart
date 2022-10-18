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
          Padding(
            padding: const EdgeInsets.only(
              top: 25.0,
              // left: 20,
              // right: 10,
              bottom: 5,
            ),
            child: Container(
              margin: const EdgeInsets.only(top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Expanded(
                        child: Text(
                          'Whatsapp Status Saver',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            letterSpacing: .4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.green,
                    endIndent: 20,
                    indent: 20,
                    thickness: 2,
                  ),
                ],
              ),
            ),
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
