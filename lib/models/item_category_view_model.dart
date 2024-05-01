class ItemCategoryViewModel {
  final int id;
  final String name;

  ItemCategoryViewModel(this.id, this.name);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }
}
