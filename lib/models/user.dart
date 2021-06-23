class TheUser {
  final String uid;
  final String firstName;
  final String lastName;
  String userRole;
  final DateTime? registrationDate;

  TheUser(
      {this.uid = '',
      this.firstName = '',
      this.lastName = '',
      this.userRole = "Customer",
      this.registrationDate});

  @override
  String toString() => '$uid $firstName $lastName $userRole $registrationDate';
  // Future getRole() async {

  // }
}
