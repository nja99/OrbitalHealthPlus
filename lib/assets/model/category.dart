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
      name: 'Family Members',
      info: 'Search all profiles',
      thumbnail:  'assets/images/family.png'
    ),
    Category(
      name: 'Blood Donation',
      info: 'Donate blood today',
      thumbnail:  'assets/images/blood.png'
    ),
    Category(
      name: 'Medication Tracker',
      info: ' All you need to know',
      thumbnail:  'assets/images/medicine.png'
    ),
    Category(
      name: 'Appointment',
      info: 'Book yours today',
      thumbnail:  'assets/images/schedule.png'
    ),
    Category(
      name: 'Particulars',
      info: 'More information',
      thumbnail:  'assets/images/logo.png'
    ),
  ];



