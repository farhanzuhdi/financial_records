class ItemDropdown {
  String id;
  String name;

  ItemDropdown({
    required this.id,
    required this.name,
  });

  factory ItemDropdown.fromJson(Map<String, dynamic> json) {
    return ItemDropdown(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
