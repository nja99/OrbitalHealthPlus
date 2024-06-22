class MedicationConfig {
  // Medication Routes
  static const List<String> routeOptions = [
    "Tablet/Capsule",
    "Liquid",
    "Injection",
    "Topical"
  ];

  // Medication Frequency
  static const List<String> frequencyOptions = [
    "Once Daily",
    "Twice Daily",
    "Three Times Daily",
    "Four Times Daily",
  ];

  static const List<String> instructionOptions = [
    "No Specific Instructions",
    "Taken with Food",
    "Taken on Empty Stomach",
    "In the Morning",
    "Taken at Bedtime",
    "Finish the Entire Course",
    "Sublingual"
  ];


  static String getDosageUnit (String? route) {
    switch (route) {
      case 'Tablet/Capsule':
        return 'tablets';
      case 'Liquid':
      case 'Injection':
        return 'ml';
      default:
        return '';
    }
  }
}
