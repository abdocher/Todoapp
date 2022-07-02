class Category {
  final String name;
  final String description;
  final int id;
  Category(this.id ,this.name, this.description,);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'Category{name : $name , description : $description}';
  }
}
