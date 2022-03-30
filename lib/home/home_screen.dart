import 'package:flutter/material.dart';
import 'package:flutter_equitysoft_core/utils/color_utils.dart';
import 'package:get/get.dart';

import '../sign_in/view/sign_in_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Equitysoft Core"),
      ),
      body: _bodyWidget(context),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _cardView(
              title: "Sign In",
              auther: "Rajan Rajani",
              onTap: () {
                Get.to(() => const SignInDetailsScreen());
              },
            ),
            _cardView(
              title: "Firebase Auth Service",
              auther: "Rajan Rajani",
              onTap: () {},
            ),
            _cardView(
              title: "Node Functions (Notifications)",
              auther: "Rajan Rajani",
              onTap: () {},
            ),
            _cardView(
              title: "Notification Service (App Side)",
              auther: "Rajan Rajani",
              onTap: () {},
            ),
            _cardView(
              title: "Get X",
              auther: "Lakhan Purohit",
              onTap: () {},
            ),
            _cardView(
              title: "App theme",
              auther: "Pankaj Khasiya",
              onTap: () {},
            ),
            _cardView(
              title: "File picker",
              auther: "Pankaj Khasiya",
              onTap: () {},
            ),
            _cardView(
              title: "File compress",
              auther: "Pankaj Khasiya",
              onTap: () {},
            ),
            _cardView(
              title: "File upload",
              auther: "Pankaj Khasiya",
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardView({
    required String title,
    required String auther,
    required Function onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 17.0,
            color: AppColors.blueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 7.0),
          child: Text(
            "Auther : $auther",
            style: TextStyle(
              fontSize: 15.0,
              color: AppColors.blackColor.withOpacity(0.75),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        iconColor: AppColors.appColorBlue,
        trailing: const Icon(Icons.keyboard_arrow_right),
        onTap: () {
          onTap();
        },
      ),
    );
  }
}
