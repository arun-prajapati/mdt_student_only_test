class AIDataModel {
  String? categoryName;
  List<String>? ytLinks;
  List<String>? readingLinks;
  bool isSelected = false;

  AIDataModel(
      {this.categoryName,
      this.ytLinks,
      this.readingLinks,
      this.isSelected = false});

  AIDataModel.fromJson(Map<String, dynamic> json) {
    categoryName = json['category_name'];
    ytLinks = json['yt_links'].cast<String>();
    readingLinks = json['reading_links'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_name'] = this.categoryName;
    data['yt_links'] = this.ytLinks;
    data['reading_links'] = this.readingLinks;
    return data;
  }
}
