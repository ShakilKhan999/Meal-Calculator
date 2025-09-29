class Member {
  String name;
  int meals;
  int paid;
  Member({
    required this.name,
    required this.meals,
    required this.paid,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'meals': meals,
      'paid': paid,
    };
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      name: map['name'],
      meals: map['meals'],
      paid: map['paid'],
    );
  }
}
