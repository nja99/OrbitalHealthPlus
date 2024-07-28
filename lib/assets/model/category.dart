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
      name: 'Family',
      info: 'Search all profiles',
      thumbnail: 'lib/assets/images/family.png'),

    /*
    Category(
      name: 'Particulars',
      info: 'More information',
      thumbnail:  'lib/assets/images/particulars.png'
    ),
    Category(
      name: 'Lab Report',
      info: 'More information',
      thumbnail:  'lib/assets/images/labreport.png'
    ),
    Category(
      name: 'Donate',
      info: 'Donate blood today',
      thumbnail: 'lib/assets/images/blood.png'),
    */
  ];



