import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  Map<String,dynamic>? user;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    user =
        await AuthService.getUser();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Vendor Profile",
        ),
      ),

      body: user == null
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : Padding(
              padding:
                  const EdgeInsets.all(20),
              child: Column(
                children: [

                  const CircleAvatar(
                    radius: 50,
                    child: Icon(
                      Icons.person,
                      size: 50,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ListTile(
                    title: const Text("Vendor Name"),
                    subtitle: Text(
                      user!["company_name"].toString(),
                    ),
                  ),

                  ListTile(
                    title: const Text("Vendor Code"),
                    subtitle: Text(
                      user!["partycode"].toString(),
                    ),
                  ),

                  ListTile(
                    title: const Text("Contact Person"),
                    subtitle: Text(
                      user!["contact_person"].toString(),
                    ),
                  ),

                  ListTile(
                    title: const Text("Mobile"),
                    subtitle: Text(
                      user!["mobileno"].toString(),
                    ),
                  ),

                  ListTile(
                    title: const Text("Email"),
                    subtitle: Text(
                      user!["email"].toString(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}