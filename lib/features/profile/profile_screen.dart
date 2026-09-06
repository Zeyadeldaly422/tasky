import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todoapp/core/constans/storage_key.dart';
import 'package:todoapp/core/servers/preferences_manager.dart';
import 'package:todoapp/core/theme/theme_controller.dart';
import 'package:todoapp/core/widgets/custom_svg_picture.dart';
import 'package:todoapp/features/profile/user_details_screen.dart';
import 'package:todoapp/features/welcome/welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String usernamePath;
  late String motivationQuote;
  String? userImage = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() {
      usernamePath = PreferencesManager().getString(StorageKey.username) ?? '';
      motivationQuote =
          PreferencesManager().getString('motivationQuote') ??
          "One task at a time. One step closer.";
      isLoading = false;
      userImage = PreferencesManager().getString('user_image') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'My Profile',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            backgroundImage: userImage == null
                                ? AssetImage('assets/images/person.png')
                                : FileImage(File(userImage!)),
                            radius: 60,
                            backgroundColor: Colors.transparent,
                          ),
                          GestureDetector(
                            onTap: () async {
                              showImageSourceDialog(context, (XFile file) {
                                _saveImage(file);
                                setState(() {
                                  userImage = file.path;
                                });
                              });
                            },
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                              ),
                              child: const Icon(Icons.camera_alt, size: 26),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        usernamePath,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      Text(
                        motivationQuote,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                Text(
                  'Profile Info',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 16),
                ListTile(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return UserDetailsScreen(
                            userName: usernamePath,
                            motivationQuote: motivationQuote,
                          );
                        },
                      ),
                    );
                    if (result != null && result) {
                      _loadData();
                    }
                  },
                  contentPadding: EdgeInsets.zero,
                  title: Text("User Details"),
                  leading: CustomSvgPicture(path: "assets/images/user.svg"),
                  trailing: CustomSvgPicture(path: "assets/images/arrow.svg"),
                ),
                const Divider(thickness: 1),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Dark Mode"),
                  leading: CustomSvgPicture(path: "assets/images/dark.svg"),
                  trailing: ValueListenableBuilder(
                    valueListenable: ThemeController.themeNotifier,
                    builder: (BuildContext context, value, Widget? child) {
                      return Switch(
                        value: value == ThemeMode.dark,
                        onChanged: (bool value) async {
                          ThemeController.toggleTheme();
                        },
                      );
                    },
                  ),
                ),
                const Divider(thickness: 1),
                ListTile(
                  onTap: () async {
                    PreferencesManager().remove(StorageKey.username);
                    PreferencesManager().remove("motivationQuote");
                    PreferencesManager().remove("tasks");
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return WelcomeScreen();
                        },
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Log Out"),
                  leading: CustomSvgPicture(path: "assets/images/logout.svg"),
                  trailing: CustomSvgPicture(path: "assets/images/arrow.svg"),
                ),
              ],
            ),
          );
  }

  void _saveImage(XFile file) async {
    final appDir = await getApplicationDocumentsDirectory();
    final newFile = await File(file.path).copy('${appDir.path}/${file.name}');
    PreferencesManager().setString('user_image', newFile.path);
  }

  void showImageSourceDialog(
    BuildContext context,
    Function(XFile) selectedfile,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            "Select Image Source",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          children: [
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
                XFile? image = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                );
                if (image != null) {
                  selectedfile(image);
                }
              },
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.camera_alt),
                  const SizedBox(width: 8),
                  const Text("Camera"),
                ],
              ),
            ),

            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
                XFile? image = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  selectedfile(image);
                }
              },
              child: Row(
                children: [
                  Icon(Icons.photo_library),
                  const SizedBox(width: 8),
                  const Text("Gallery"),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
