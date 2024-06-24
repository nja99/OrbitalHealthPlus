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
    "No Instructions",
    "With Food",
    "Empty Stomach",
    "Morning",
    "Bedtime",
    "Finish Course",
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
