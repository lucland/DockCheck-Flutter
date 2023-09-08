class Company {
  final String companyName;
  final String companyLogo;
  final List<String> users;
  final List<String> vessels;
  final List<String> locations;
  final int onBoarded;

  Company({
    required this.companyName,
    required this.companyLogo,
    required this.users,
    required this.vessels,
    required this.locations,
    required this.onBoarded,
  });

  Map<String, dynamic> toMap() {
    return {
      'companyName': companyName,
      'companyLogo': companyLogo,
      'users': users,
      'vessels': vessels,
      'locations': locations,
      'onBoarded': onBoarded,
    };
  }

  static Company fromMap(Map<String, dynamic> map) {
    return Company(
      companyName: map['companyName'],
      companyLogo: map['companyLogo'],
      users: List<String>.from(map['users']),
      vessels: List<String>.from(map['vessels']),
      locations: List<String>.from(map['locations']),
      onBoarded: map['onBoarded'],
    );
  }
}
