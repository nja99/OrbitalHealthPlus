import 'package:flutter/material.dart';
import 'package:healthsphere/components/buttons/user_button.dart';
import 'package:healthsphere/components/dialogs/custom_alert_dialog.dart';
import 'package:healthsphere/components/forms/user_dropdown.dart';
import 'package:healthsphere/components/forms/user_textfield.dart';
import 'package:healthsphere/config/user_profile_config.dart';
import 'package:healthsphere/pages/home_page.dart';
import 'package:healthsphere/services/auth/auth_provider.dart';
import 'package:healthsphere/services/auth/auth_service_locator.dart';
import 'package:healthsphere/services/user/user_profile_service.dart';
import 'package:healthsphere/utils/loading_overlay.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as dtpicker;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileCollectionPage extends StatefulWidget {

  const ProfileCollectionPage({super.key});

  @override
  State<ProfileCollectionPage> createState() => _ProfileCollectionPageState();
}

class _ProfileCollectionPageState extends State<ProfileCollectionPage> {

  final userProfileService = getIt<UserProfileService>();

  final GlobalKey<FormState> _formKey = GlobalKey();
  
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final dateController = TextEditingController();

  DateTime? _selectedDate;
  String? _sex;
  String? _bloodType;

  // Loading State
  bool _isLoading = false;
  
  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    heightController.dispose();
    weightController.dispose();
    dateController.dispose();
    super.dispose();
  }

  String? _validNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final number = num.tryParse(value);
    if(number == null) {
      return "Invalid Input";
    }

    return null;
  }

  void saveUserProfile () async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen:false);
        final user = authProvider.user;

        if (user == null) {
          throw Exception("No authenticated user found");
        }

        final userData = userProfileService.constructUserData(
          firstName: firstNameController.text,
          lastName: lastNameController.text, 
          dateOfBirth: _selectedDate!,
          height: heightController.text.isNotEmpty ? double.parse(heightController.text) : 0.0, 
          weight: weightController.text.isNotEmpty ? double.parse(weightController.text) : 0.0,
          sex: _sex ?? '', 
          bloodType: _bloodType ?? ''
        );

        await userProfileService.storeUserProfile(user, userData);

        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }

        if (!mounted) return;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));

      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        showCustomDialog(context, e.toString(), "Please try again.");
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return loadingOverlay(
      _isLoading, 
      Scaffold(
        body: SafeArea(
          child: Center(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                children: [
                  
                  // Logo
                  const SizedBox(height: 60),
                    Image.asset("lib/assets/images/logo_light.png", height: 160),
              
                  // About You!
                  const SizedBox(height: 20),
                  Text(
                    "Let us learn more about you!",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  // First Name Field
                  const SizedBox(height: 40),
                  UserTextField(
                    controller: firstNameController, 
                    labelText: "First Name",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "First Name is required";
                      } else if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
                        return "First Name must contain only letters";
                      }
              
                      return null;
                    },
                  ),
              
                  // Last Name Field
                  UserTextField(
                    controller: lastNameController, 
                    labelText: "Last Name"
                  ),
                  
                  // Date of Birth Field
                  UserTextField(
                    controller: dateController, 
                    labelText: "Date of Birth",
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Date of Birth is required";
                      }
                      if (_selectedDate == null) {
                        return "Please select a valid date";
                      }
                      return null;
                    },
                    onTap: () {
                      dtpicker.DatePicker.showDatePicker(
                        context,
                        minTime: DateTime(1920),
                        currentTime: DateTime(2000),
                        maxTime: DateTime.now(),
                        showTitleActions: true,
                        theme: const dtpicker.DatePickerTheme(
                          containerHeight: 400,
                        ),
                        onChanged: (date) {
                          setState(() {
                            _selectedDate = date;
                            dateController.text = DateFormat("dd-MMM-yyyy").format(_selectedDate!);
                          });
                        }
                      );
                    },
                  ),
              
                  // Height / Weight Field
                  Row(
                    children: [
                      // Height Field
                      Expanded(
                        child: UserTextField(
                          controller: heightController,
                          labelText: "Height (cm)",
                          validator: _validNumber,
                        )
                      ),
              
                      // Weight Field
                      const SizedBox (width: 50),
                      Expanded(
                        child: UserTextField(
                          controller: weightController,
                          labelText: "Weight (kg)",
                          validator: _validNumber,
                      )),
                    ]
                  ),
              
                  Row(
                    children: [
                      Expanded(
                        child: UserDropdown(
                          label: "Sex",
                          items: UserProfileConfig.sexTypes, 
                          onSelected: (value) {
                            _sex = value;
                          }
                        ),
                      ),
                      const SizedBox(width: 50),
                      Expanded(
                        child: UserDropdown(
                          label: "Blood Type",
                          items: UserProfileConfig.bloodTypes,
                          onSelected: (value) {
                            _bloodType = value;
                          }
                        )
                      )
                    ],
                  ),
                  const SizedBox(height: 50),
                  UserButton(
                    buttonText: "Save Profile", 
                    onPressed: saveUserProfile
                  )
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}