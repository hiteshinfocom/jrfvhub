import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/routes.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final TextEditingController userController =
      TextEditingController();

  final TextEditingController passController =
      TextEditingController();

  bool loading = false;
  bool hidePassword = true;

  // ================= LOGIN FUNCTION =================

  Future<void> login() async { if (userController.text.trim().isEmpty) { Get.snackbar( "Error", "Please Enter Vendor ID", backgroundColor: Colors.red, colorText: Colors.white, ); return; } if (passController.text.trim().isEmpty) { Get.snackbar( "Error", "Please Enter Password", backgroundColor: Colors.red, colorText: Colors.white, ); return; } setState(() { loading = true; }); try { final response = await AuthService.login( vendorCode: userController.text.trim(), password: passController.text.trim(), ); if (!mounted) return; if (response != null && response["status"] == true) { Get.snackbar( "Success", response["message"] ?? "Login Successful", backgroundColor: Colors.green, colorText: Colors.white, ); Get.offAllNamed( Routes.dashboard, ); } else { Get.snackbar( "Login Failed", response["message"] ?? "Invalid Credentials", backgroundColor: Colors.red, colorText: Colors.white, ); } } catch (e) { if (!mounted) return; Get.snackbar( "Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white, ); } finally { if (mounted) { setState(() { loading = false; }); } } }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xfff5f7fb),

      body: SafeArea(

        child: SingleChildScrollView(

          child: SizedBox(

            height:
                MediaQuery.of(context)
                    .size
                    .height,

            child: Column(

              children: [

                // ================= TOP DESIGN =================

                Container(

                  width: double.infinity,

                  padding:
                      const EdgeInsets.only(
                    top: 50,
                    bottom: 40,
                  ),

                  decoration:
                      const BoxDecoration(

                    gradient: LinearGradient(

                      begin: Alignment.topLeft,
                      end:
                          Alignment.bottomRight,

                      colors: [
                        Color(0xff4f46e5),
                        Color(0xff6366f1),
                      ],
                    ),

                    borderRadius:
                        BorderRadius.only(

                      bottomLeft:
                          Radius.circular(40),

                      bottomRight:
                          Radius.circular(40),
                    ),
                  ),

                  child: Column(

                    children: [

                      // ================= LOGO =================

                      Container(

                        padding:
                            const EdgeInsets.all(
                          18,
                        ),

                        decoration:
                            BoxDecoration(

                          color: Colors.white,

                          borderRadius:
                              BorderRadius.circular(
                            25,
                          ),
                        ),

                        child: Image.asset(

                          "assets/images/jrfpvhub.png",

                          width: 90,
                          height: 90,

                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // ================= TITLE =================

                      const Text(

                        "Vendor Portal",

                        style: TextStyle(

                          color: Colors.white,

                          fontSize: 30,

                          fontWeight:
                              FontWeight.bold,

                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      const Text(

                        "Welcome back to JRF V-HUB",

                        style: TextStyle(

                          color: Colors.white70,

                          fontSize: 15,

                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // ================= LOGIN FORM =================

                Expanded(

                  child: Padding(

                    padding:
                        const EdgeInsets.all(
                      25,
                    ),

                    child: Column(

                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,

                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        const Text(

                          "Login",

                          style: TextStyle(

                            fontSize: 28,

                            fontWeight:
                                FontWeight.bold,

                            color:
                                Color(0xff1e293b),
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        const Text(

                          "Enter your vendor credentials",

                          style: TextStyle(

                            fontSize: 15,

                            color: Colors.grey,

                            height: 1.5,
                          ),
                        ),

                        const SizedBox(
                          height: 35,
                        ),

                        // ================= USER ID =================

                        const Text(

                          "Vendor ID",

                          style: TextStyle(

                            fontWeight:
                                FontWeight.w600,

                            fontSize: 15,

                            color:
                                Color(0xff334155),
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        TextField(

                          controller:
                              userController,

                          decoration:
                              InputDecoration(

                            hintText:
                                "Enter Vendor ID",

                            prefixIcon:
                                const Icon(
                              Icons
                                  .person_outline,
                            ),

                            filled: true,

                            fillColor:
                                Colors.white,

                            border:
                                OutlineInputBorder(

                              borderRadius:
                                  BorderRadius.circular(
                                18,
                              ),

                              borderSide:
                                  BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 22,
                        ),

                        // ================= PASSWORD =================

                        const Text(

                          "Password",

                          style: TextStyle(

                            fontWeight:
                                FontWeight.w600,

                            fontSize: 15,

                            color:
                                Color(0xff334155),
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        TextField(

                          controller:
                              passController,

                          obscureText:
                              hidePassword,

                          decoration:
                              InputDecoration(

                            hintText:
                                "Enter Password",

                            prefixIcon:
                                const Icon(
                              Icons.lock_outline,
                            ),

                            suffixIcon:
                                IconButton(

                              onPressed: () {

                                setState(() {

                                  hidePassword =
                                      !hidePassword;
                                });
                              },

                              icon: Icon(

                                hidePassword

                                    ? Icons
                                        .visibility_off_outlined

                                    : Icons
                                        .visibility_outlined,
                              ),
                            ),

                            filled: true,

                            fillColor:
                                Colors.white,

                            border:
                                OutlineInputBorder(

                              borderRadius:
                                  BorderRadius.circular(
                                18,
                              ),

                              borderSide:
                                  BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        // ================= LOGIN BUTTON =================

                        SizedBox(

                          width:
                              double.infinity,

                          height: 58,

                          child:
                              ElevatedButton(

                            onPressed:
                                loading
                                    ? null
                                    : login,

                            style:
                                ElevatedButton.styleFrom(

                              backgroundColor:
                                  const Color(
                                0xff4f46e5,
                              ),

                              shape:
                                  RoundedRectangleBorder(

                                borderRadius:
                                    BorderRadius.circular(
                                  18,
                                ),
                              ),
                            ),

                            child: loading

                                ? const SizedBox(

                                    width: 24,
                                    height: 24,

                                    child:
                                        CircularProgressIndicator(

                                      color:
                                          Colors.white,

                                      strokeWidth:
                                          2.5,
                                    ),
                                  )

                                : const Text(

                                    "LOGIN",

                                    style:
                                        TextStyle(

                                      color:
                                          Colors.white,

                                      fontSize: 17,

                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        // ================= FOOTER =================

                        const Center(

                          child: Text(

                            "Powered By Jupiter Roll Forming Pvt Ltd",

                            textAlign:
                                TextAlign.center,

                            style: TextStyle(

                              color: Colors.grey,

                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}