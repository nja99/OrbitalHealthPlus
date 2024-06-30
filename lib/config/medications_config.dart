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
    "With Food",
    "On Empty Stomach",
    "In the Morning",
    "Before Bedtime",
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

  static String getRouteImage (String route) {
    switch(route) {
      case 'Tablet/Capsule':
        return "lib/assets/images/placeholders/tablet.png";
      case "Liquid":
        return "lib/assets/images/placeholders/liquid.png";
      case "Injection":
        return "lib/assets/images/placeholders/injection.png";
      case "Topical":
        return "lib/assets/images/placeholders/topical.png";
      default:
        return "lib/assets/images/placeholders/default.png";
    }
  }

  static String getRouteIcon (String route) {
    switch (route) {
      case 'Tablet/Capsule':
        return "lib/assets/images/icons/icon_tablet.png";
      case "Liquid":
        return "lib/assets/images/icons/icon_liquid.png";
      case "Injection":
        return "lib/assets/images/icons/icon_injection.png";
      case "Topical":
        return "lib/assets/images/icons/icon_topical.png";
      default:
        return "lib/assets/images/icons/icon_tablet.png";
    }
  }
}
