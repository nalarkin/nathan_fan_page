class TheUser {
  final String uid;
  final String firstName;
  final String lastName;
  final String userRole;
  final DateTime? registrationDate;

  TheUser(
      {this.uid = '',
      this.firstName = '',
      this.lastName = '',
      this.userRole = "Customer",
      this.registrationDate});
}
