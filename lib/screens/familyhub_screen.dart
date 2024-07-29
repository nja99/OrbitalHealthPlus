import 'package:flutter/material.dart';
import 'package:healthsphere/components/home/home_drawer.dart';
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
  late Stream<List<Map<String, dynamic>>> _dependentsStream;
  late Stream<List<Map<String, dynamic>>> _caregiversStream;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _initializeStreams();
  }

  void _initializeStreams() {
    if (_currentUser != null) {
      _dependentsStream = _userProfileService.getDependentsStream(_currentUser!);
      _caregiversStream = _userProfileService.getCaregiversStream(_currentUser!);
    }
  }

  Future<void> _fetchUserData() async {
    if (_currentUser != null) {
      _userData = await _userProfileService.getUserProfile(_currentUser!);
      if (mounted) setState(() {});
    }
  }

  Future<void> _addLovedOne() async {
  if (_currentUser == null) return;

  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AddLovedOnePage()),
  );

  if (result != null && result is Map<String, String>) {
    String email = result['email']!;
    
    try {
      await _userProfileService.addDependent(_currentUser!, email);
      await _userProfileService.addCaregiver(email, _currentUser!.email!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Loved one added successfully')),
      );

      _fetchUserData();
      _initializeStreams();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}

  Future<void> _deleteDependent(String email) async {
    try {
      await _userProfileService.removeDependent(_currentUser!, email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dependent removed successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing dependent: ${e.toString()}')),
      );
    }
  }

  Future<void> _switchToAccount(String email) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => Center(child: CircularProgressIndicator()),
      );

      User? newUser = await _userProfileService.switchAccount(email);
      Navigator.of(context).pop();

      if (newUser != null) {
        _fetchUserData();
        _initializeStreams();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully switched to ${newUser.email}')),
        );
      } else {
        throw Exception('Failed to switch account');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
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
                  const SizedBox(height: 10),
                  _buildSectionTitle('My Current Account'),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: _buildProfileCard(_userData),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _fetchUserData,
                      child: ListView(
                        children: [
                          _buildSectionTitle('My caregivers'),
                          _buildStreamBuilder(_caregiversStream, true),
                          _buildSectionTitle('People under my care'),
                          _buildStreamBuilder(_dependentsStream, false),
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

  Widget _buildStreamBuilder(Stream<List<Map<String, dynamic>>> stream, bool isCaregiver) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          return Column(
            children: snapshot.data!.map((data) => _buildProfileCard(data, isCaregiver: isCaregiver, isDependent: !isCaregiver)).toList(),
          );
        }
        return SizedBox();
      },
    );
  }

  Widget _buildProfileCard(Map<String, dynamic>? data, {bool isDependent = false, bool isCaregiver = false}) {
    if (data == null) return SizedBox.shrink();
    
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
            if (isDependent)
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _deleteDependent(email),
              ),
            if (isDependent || isCaregiver)
              Icon(Icons.chevron_right),
          ],
        ),
        onTap: (isDependent || isCaregiver) ? () => _switchToAccount(email) : null,
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
        onPressed: _addLovedOne,
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}