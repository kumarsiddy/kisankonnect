enum Gender {
  MALE,
  FEMALE,
  OTHER,
}

extension getName on Gender {
  String get name => this.toString().split('.').last;
}
