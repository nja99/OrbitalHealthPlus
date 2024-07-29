import 'package:flutter/material.dart';
import 'package:healthsphere/components/home/home_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthsphere/screens/addloved.dart';
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

  List<Map<String, dynamic>> _dependents = [];
  List<Map<String, dynamic>> _caregivers = [];
  Map<String, String>? _lastAddedLovedOne;










Future<void> _fetchUserData() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    _userData = await _userProfileService.getUserProfile(currentUser);
    if (mounted) {
      setState(() {});
    }
  }
}

Future<void> _fetchDependents() async {
  if (_currentUser != null) {
    List<Map<String, dynamic>> fetchedDependents = await _userProfileService.getDependents(_currentUser!);
    print("Fetched dependents: $fetchedDependents");
    if (mounted) {
      setState(() {
        _dependents = fetchedDependents;
      });
    }
  }
}

Future<void> _fetchCaregivers() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    List<Map<String, dynamic>> fetchedCaregivers = await _userProfileService.getCaregivers(currentUser);
    print("Fetched caregivers: $fetchedCaregivers");
    if (mounted) {
      setState(() {
        _caregivers = fetchedCaregivers;
      });
    }
  }
}


  Future<void> _addLovedOne() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AddLovedOnePage()),
  );
  if (result != null && result is Map<String, String>) {
    setState(() {
      _lastAddedLovedOne = result;
    });
    await _fetchDependents();
    print("Added loved one: ${_lastAddedLovedOne!['email']}");
  }
} 

  Future<void> _deleteCaregiver(String caregiverEmail) async {
  try {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await _userProfileService.removeCaregiver(currentUser, caregiverEmail);

      // Immediately remove the caregiver from the local list
      setState(() {
        _dependents.removeWhere((dependent) => dependent['email'] == caregiverEmail);
      });

      // Refresh the data from Firestore
      await _fetchDependents();
      await _fetchCaregivers();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Caregiver removed successfully')),
      );
    }
  } catch (e) {
    print('Error in _deleteCaregiver: ${e.toString()}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error deleting caregiver: ${e.toString()}')),
    );
  }
}

  Future<void> _refreshProfile() async {
    await _fetchUserData();
    setState(() {});
  }

  Future<void> _switchToAccount(String email) async {
  try {
    // Show a loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    // Attempt to switch the account
    User? newUser = await _userProfileService.switchAccount(email);

    // Close the loading indicator
    Navigator.of(context).pop();

    if (newUser != null) {
      // Refresh the screen with the new user's data
      await _fetchUserData();
      await _fetchDependents();
      await _fetchCaregivers();
      setState(() {});

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully switched to ${newUser.email}')),
      );
    } else {
      throw Exception('Failed to switch account');
    }
  } catch (e) {
    // Show an error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
}
























  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchDependents();
    _fetchCaregivers();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      extendBody: true,
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
                  const SizedBox(height: 10),
                  _buildSectionTitle('My Current Account'),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: _buildProfileCard(_userData),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _refreshProfile,
                      child: ListView(
                        children: [
                          // ... existing code ...
                          _buildSectionTitle('My caregivers'),
                          ..._caregivers.map((caregiver) => _buildProfileCard(caregiver, isCaregiver: true)),
                          _buildSectionTitle('People under my care'),
                          ..._dependents.map((dependent) => _buildProfileCard(dependent, isDependent: true)),
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
Widget _buildProfileCard(Map<String, dynamic>? data, {bool isDependent = false, bool isCaregiver = false}) {
  if (data == null) {
    return SizedBox.shrink();
  }

  String fullName = "${data['firstName'] ?? ''} ${data['lastName'] ?? ''}".trim();
  String email = data['email'] as String;

  return Card(
    child: ListTile(
      leading: CircleAvatar(
        child: Text(fullName.isNotEmpty ? fullName[0].toUpperCase() : '?'),
      ),
      title: Text(fullName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Height: ${data['height']?.toString() ?? 'N/A'} cm'),
          Text('Weight: ${data['weight']?.toString() ?? 'N/A'} kg'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isDependent && email != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteCaregiver(email),
            ),
          if (isDependent || isCaregiver)
            Icon(Icons.chevron_right),
        ],
      ),
      onTap: (isDependent || isCaregiver) ? () => _switchToAccount(email) : null,
    ),
  );
}


Future<void> _deleteDependent(String? email) async {
  if (email == null) return;

  try {
    await _userProfileService.removeDependent(_currentUser!, email);
    await _fetchDependents();
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Dependent removed successfully')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error removing dependent: ${e.toString()}')),
    );
  }
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
      onPressed: _addLovedOne,  // Change this line
      style: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}
}