import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthsphere/services/auth/auth_service_locator.dart';
import 'package:healthsphere/services/database/drugs_firestore_service.dart';
import 'package:healthsphere/themes/custom_text_styles.dart';

class ShowDrugDialog extends StatefulWidget {

  final DocumentSnapshot drug;

  const ShowDrugDialog({
    super.key,
    required this.drug
  });

  
  @override
  State<ShowDrugDialog> createState() => _ShowDrugDialogState();
}

class _ShowDrugDialogState extends State<ShowDrugDialog> {

  final DrugsFirestoreService firestoreService = getIt<DrugsFirestoreService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Drug Details")
      ),
      body: _drugInfo(),
    );
  }

  Widget _drugInfo() {
    return StreamBuilder<DocumentSnapshot>(
      stream: firestoreService.getDrugStream(widget.drug.id), 
      builder: (context, snapshot) {

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final drugName = data['genericName'];
        final drugType = data['drugType'] ?? '';
        final drugAdvice = data['drugAdvice'] ?? '';
        final drugDescription = data['drugDescription'] ?? '';
        final drugPurpose = data['drugPurpose'] ?? '';
        final brandNames = (data['genericAndBrandNames'] as List<dynamic>)
          .sublist(1)
          .join(', ');
        final sideEffects = List<String>.from(data['sideEffects'] ?? []);

        return Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Text(drugName, style: CustomTextStyles.title),
              Text(drugType, style: CustomTextStyles.bodyBold, textAlign: TextAlign.justify),

              if(brandNames.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Text("Other Names", style: CustomTextStyles.subHeader),
                Text(brandNames, style: CustomTextStyles.bodyNormal, textAlign: TextAlign.justify),
              ],

              if(drugPurpose.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Text("Purpose", style: CustomTextStyles.subHeader),
                Text(drugPurpose, style: CustomTextStyles.bodyNormal, textAlign: TextAlign.justify)
              ],

              if (drugAdvice.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Text("Advice", style: CustomTextStyles.subHeader),
                Text(drugAdvice, style: CustomTextStyles.bodyNormal, textAlign: TextAlign.justify)
              ],

              if (drugDescription.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Text("Description", style: CustomTextStyles.subHeader),
                Text(drugDescription, style: CustomTextStyles.bodyNormal, textAlign: TextAlign.justify)
              ],

              if (sideEffects.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Text("Side Effects", style: CustomTextStyles.subHeader),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: sideEffects.map((effect) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 7), // Adjust this value to align the bullet
                        child: const Icon(Icons.brightness_1, size: 6),
                      ),
                      const SizedBox(width: 7),
                      Expanded(child: Text(effect, style: CustomTextStyles.bodyNormal, textAlign: TextAlign.justify)),
                    ],
                  )).toList(),
                )
              ]
            ]
          ),
        );
      }
    );
  }
}