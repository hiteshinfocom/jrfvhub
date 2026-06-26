import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/auth_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({
    super.key,
  });

  @override
  State<ChangePasswordScreen>
      createState() =>
          _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends State<ChangePasswordScreen> {

  final oldController =
      TextEditingController();

  final newController =
      TextEditingController();

  final confirmController =
      TextEditingController();

  bool isLoading = false;

  bool oldHide = true;
  bool newHide = true;
  bool confirmHide = true;

  Future<void> updatePassword() async {

    if (oldController.text.isEmpty) {
      Get.snackbar(
        "Validation",
        "Enter old password",
      );
      return;
    }

    if (newController.text.length < 6) {
      Get.snackbar(
        "Validation",
        "Password must be minimum 6 characters",
      );
      return;
    }

    if (newController.text !=
        confirmController.text) {
      Get.snackbar(
        "Validation",
        "Password not matched",
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final result =
        await AuthService.changePassword(
      oldPassword:
          oldController.text.trim(),
      newPassword:
          newController.text.trim(),
    );

    setState(() {
      isLoading = false;
    });

    if (result["success"] == true ||
        result["status"] == true) {

      oldController.clear();
      newController.clear();
      confirmController.clear();

      Get.snackbar(
        "Success",
        result["message"] ??
            "Password Updated Successfully",
        backgroundColor:
            Colors.green,
        colorText: Colors.white,
      );
    } else {

      Get.snackbar(
        "Error",
        result["message"] ??
            "Password Update Failed",
        backgroundColor:
            Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xffF5F7FB),

      appBar: AppBar(
        title: const Text(
          "Change Password",
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          children: [

            const SizedBox(height: 20),

            Container(
              height: 90,
              width: 90,

              decoration: BoxDecoration(
                color: Colors.blue
                    .withOpacity(.1),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.lock_reset,
                color: Colors.blue,
                size: 45,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller:
                  oldController,

              obscureText: oldHide,

              decoration:
                  InputDecoration(
                labelText:
                    "Old Password",

                prefixIcon:
                    const Icon(
                  Icons.lock,
                ),

                suffixIcon:
                    IconButton(
                  icon: Icon(
                    oldHide
                        ? Icons.visibility
                        : Icons
                            .visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      oldHide =
                          !oldHide;
                    });
                  },
                ),

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius
                          .circular(
                    15,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller:
                  newController,

              obscureText: newHide,

              decoration:
                  InputDecoration(
                labelText:
                    "New Password",

                prefixIcon:
                    const Icon(
                  Icons.password,
                ),

                suffixIcon:
                    IconButton(
                  icon: Icon(
                    newHide
                        ? Icons.visibility
                        : Icons
                            .visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      newHide =
                          !newHide;
                    });
                  },
                ),

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius
                          .circular(
                    15,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller:
                  confirmController,

              obscureText:
                  confirmHide,

              decoration:
                  InputDecoration(
                labelText:
                    "Confirm Password",

                prefixIcon:
                    const Icon(
                  Icons.check_circle,
                ),

                suffixIcon:
                    IconButton(
                  icon: Icon(
                    confirmHide
                        ? Icons.visibility
                        : Icons
                            .visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      confirmHide =
                          !confirmHide;
                    });
                  },
                ),

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius
                          .circular(
                    15,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(

                onPressed:
                    isLoading
                        ? null
                        : updatePassword,

                icon: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child:
                            CircularProgressIndicator(
                          color:
                              Colors.white,
                          strokeWidth:
                              2,
                        ),
                      )
                    : const Icon(
                        Icons.save,
                      ),

                label: Text(
                  isLoading
                      ? "Updating..."
                      : "Update Password",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}