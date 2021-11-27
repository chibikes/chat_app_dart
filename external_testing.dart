class FirstClass {
  final String name;
  final SecondClass secondClass;

  FirstClass(this.name, this.secondClass);
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'secondClass': secondClass.toMap(),

      /// try without to map?
    };
  }

  static FirstClass fromJson(Map<String, dynamic> json) {
    return FirstClass(
        json['name'] as String, SecondClass.fromJson(json['secondClass']));
  }

  @override
  String toString() {
    return 'FirstClass{name: $name\n secondClass: ${secondClass.toString()}}';
  }
}

class SecondClass {
  final String firstName;

  SecondClass(this.firstName);

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
    };
  }

  static SecondClass fromJson(Map<String, dynamic> json) {
    return SecondClass(
      json['firstName'],
    );
  }

  @override
  String toString() {
    return '{firstName: $firstName}';
  }
}

void main() {
  FirstClass? firstClass = FirstClass('okoh', SecondClass('chibuike'));
  Map<String, dynamic> firstClassToMap = firstClass.toMap();
  firstClass = null;
  try {
    firstClass = FirstClass.fromJson(firstClassToMap);
    print(firstClass);
  } catch (e) {
    print('this is the exception: $e');
  }
}
