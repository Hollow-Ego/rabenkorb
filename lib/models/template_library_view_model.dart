class TemplateLibraryViewModel {
  final int id;
  final String name;

  TemplateLibraryViewModel(this.id, this.name);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }
}
