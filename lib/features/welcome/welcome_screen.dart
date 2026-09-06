import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todoapp/core/constans/storage_key.dart';
import 'package:todoapp/core/servers/preferences_manager.dart';
import 'package:todoapp/core/widgets/custom_svg_picture.dart';
import 'package:todoapp/core/widgets/custom_text_form_field.dart';
import 'package:todoapp/features/navigation/main_screen.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final TextEditingController usernameController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomSvgPicture.withoutcolor(
                        path: "assets/images/Vector.svg",
                        height: 42,
                        width: 42,
                      ),
                      SizedBox(width: 16),
                      Text(
                        "tasky",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: 66),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Welcome To Tasky ",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          CustomSvgPicture.withoutcolor(
                            path: "assets/images/wavinghand.svg",
                            // height: 215,
                            // width: 200,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Your productivity journey starts here.",
                    style: Theme.of(
                      context,
                    ).textTheme.displaySmall!.copyWith(fontSize: 16),
                  ),
                  SizedBox(height: 24),
                  SvgPicture.asset(
                    "assets/images/pana.svg",
                    height: 215,
                    width: 200,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24),
                        CustomTextTormField(
                          controller: usernameController,
                          hintText: "e.g. Sarah Khalid",
                          title: "Full Name",
                          validator: (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return "please Enter Your full Name";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(
                              MediaQuery.of(context).size.width,
                              40,
                            ),
                          ),
                          onPressed: () async {
                            if (_key.currentState?.validate() ?? false) {
                            await  PreferencesManager().setString(StorageKey.username, usernameController.value.text);
                             
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return MainScreen();
                                  },
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("please Enter Your full Name"),
                                ),
                              );
                            }
                          },
                          child: Text("Let’s Get Started"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
