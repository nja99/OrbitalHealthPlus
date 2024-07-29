class Category {
  String thumbnail;
  String name;
  String info;
  Category({
    required this.name,
    required this.info,
    required this.thumbnail,
  });
}


  final List<Category> categoryList = [
    Category(
      name: 'Family',
      info: 'Search all profiles',
      thumbnail:  'lib/assets/images/family.png'
    ),
    Category(
      name: 'Blood Donation',
      info: 'Donate blood today',
      thumbnail:  'lib/assets/images/blood.png'
    ),
    Category(
      name: 'Medication',
      info: ' All you need to know',
      thumbnail:  'lib/assets/images/medicine.png'
    ),
    Category(
      name: 'Appointment',
      info: 'Book yours today',
      thumbnail: 'lib/assets/images/schedule.png'
    ),
    Category(
      name: 'Database',
      info: 'More information',
      thumbnail:  'lib/assets/images/particulars.png'
    ),
    Category(
      name: 'Settings',
      info: 'More information',
      thumbnail:  'lib/assets/images/settings.png'
    ),

  ];
