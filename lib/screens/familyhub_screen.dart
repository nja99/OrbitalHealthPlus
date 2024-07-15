import 'package:flutter/material.dart';
import 'package:healthsphere/components/home/home_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthsphere/services/service_locator.dart';
import 'package:healthsphere/services/user/user_profile_service.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  final UserProfileService _userProfileService = getIt<UserProfileService>();
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? _userData;

  Future<void> _fetchUserData() async {
    if (_currentUser != null) {
      _userData = await _userProfileService.getUserProfile(_currentUser!);
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _refreshProfile() async {
  await _fetchUserData();
  setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      drawer: const HomeDrawer(),
      body: Column(
        children: [
          const SizedBox(height: 50),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Health Profiles',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _refreshProfile,
                      child: ListView(
                      children: [
                        _buildProfileCard(),
                        _buildSectionTitle('My caregivers (1)'),
                        _buildAddButton('Add caregivers'),
                        _buildSectionTitle('People under my care'),
                        _buildAddButton('Add loved ones'),
                        _buildSectionTitle('Family & friends'),
                      ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildProfileCard() {
  if (_userData == null) {
    return const Center(child: CircularProgressIndicator());
  }

  String fullName = "${_userData!['firstName']} ${_userData!['lastName']}";

  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Text(
          fullName.isNotEmpty ? fullName[0].toUpperCase() : '?',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      title: Text(fullName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sex: ${_userData!['sex'] ?? 'N/A'}'),
          Text('Blood Type: ${_userData!['bloodType'] ?? 'N/A'}'),
          Text('Height: ${_userData!['height']?.toString() ?? 'N/A'} cm'),
          Text('Weight: ${_userData!['weight']?.toString() ?? 'N/A'} kg'),
        ],
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Handle profile tap - maybe navigate to a detailed profile view
      },
    ),
  );
}





  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildAddButton(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: Text(label),
        onPressed: () {
          // Handle add button tap
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}