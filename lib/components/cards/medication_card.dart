import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";

class MedicationCard extends StatelessWidget {

  final DocumentSnapshot medication;
  final Function(DismissDirection) onDismissed;

  const MedicationCard({
    super.key,
    required this.medication,
    required this.onDismissed
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}