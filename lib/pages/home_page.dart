import 'package:flutter/material.dart';
import 'package:frontend/model/User.dart';
import 'package:frontend/pages/calendar_page.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/sharedpreferrences_helper.dart';
import 'package:frontend/widgets/default_appbar.dart';
import 'package:frontend/widgets/navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [CalendarPage()];

  User? user;
  String profilePic = '';

  @override
  void initState() {
    super.initState();
    _loadUser(); // Coba load user ketika halaman dibuka
  }

  // Coba load status user dari SharedPreferences
  void _loadUser() async {
    final profilePicFromPrefs = await SharedPreferencesHelper.getProfilePic();
    final isLoggedIn = await SharedPreferencesHelper.getUserLoginStatus();

    if (isLoggedIn != null && isLoggedIn) {
      setState(() {
        profilePic = profilePicFromPrefs ?? ''; // Atau gambar default
      });
    }
  }

  // Mengubah profilePic dengan yang didapat dari user
  void _setProfilePic(User signedInUser) async {
    setState(() {
      profilePic = signedInUser.profilePicture;
    });

    // Simpan profilePic di SharedPreferences
    await SharedPreferencesHelper.saveProfilePic(signedInUser.profilePicture);
    await SharedPreferencesHelper.saveUserLoginStatus(true); // Set status login true
  }

  // Fungsi untuk mendapatkan user melalui Google Auth
  void _getUser() async {
    final authService = AuthService();
    final signedInUser = await authService.signInWithGoogle();
    if (signedInUser != null) {
      _setProfilePic(signedInUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppbar(
        onLogin: _getUser, // Memanggil fungsi _getUser saat login
        profilePic: profilePic, // Memberikan gambar profil ke appbar
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
