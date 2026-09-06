import 'package:flutter/material.dart';
import 'package:todoapp/core/constans/storage_key.dart';
import 'package:todoapp/core/servers/preferences_manager.dart';
import 'package:todoapp/core/widgets/custom_text_form_field.dart';

class UserDetailsScreen extends StatefulWidget {
  const  UserDetailsScreen({super.key,required this.userName,required this.motivationQuote});

  final String userName ;
  final String? motivationQuote ;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {

  // final TextEditingController usernameController = TextEditingController();
  // final TextEditingController motivationController = TextEditingController();

   late final TextEditingController usernameController ;
  late final TextEditingController motivationController ;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

@override
  void initState() {
    super.initState();
    usernameController =  TextEditingController(text:widget.userName);
    motivationController = TextEditingController(text:widget.motivationQuote);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Details")),
      body: Form(
        key: _key,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomTextTormField(
                controller: usernameController,
                hintText: "Usama Elgendy",
                title: "User Name",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return " Enter User Name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CustomTextTormField(
                controller: motivationController,
                hintText: "One task at a time. One step closer.",
                title: "Motivation Quote",
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return " Enter Motivation Quote";
                  }
                  return null;
                },
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () async {
                  if (_key.currentState!.validate()) {
                     PreferencesManager().setString(StorageKey.username, usernameController.value.text);
                     PreferencesManager().setString('motivationQuote',motivationController.value.text);
                    if (mounted) {
        Navigator.pop(context, true);
      }
                  }
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width, 40),
                ),
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
