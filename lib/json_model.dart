class PracticeTestCategoryModel {
  int? id;
  String? name;
  String? slug;
  int? status;
  String? deletedAt;
  String? createdAt;
  String? dAt;

  PracticeTestCategoryModel(
      {this.id,
      this.name,
      this.slug,
      this.status,
      this.deletedAt,
      this.createdAt,
      this.dAt});

  PracticeTestCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    dAt = json['d_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['status'] = this.status;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['d_at'] = this.dAt;
    return data;
  }
}
