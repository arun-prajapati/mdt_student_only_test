class TheoryContentModel {
  int? id;
  String? topicName;
  String? topicDescription;
  String? isFree;
  bool isExpand = false;
  bool isSelected = false;

  TheoryContentModel(
      {this.id,
      this.topicName,
      this.topicDescription,
      this.isFree,
      this.isExpand = false});

  TheoryContentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    topicName = json['topic_name'];
    topicDescription = json['topic_description'];
    isFree = json['isFree'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['topic_name'] = this.topicName;
    data['topic_description'] = this.topicDescription;
    data['isFree'] = this.isFree;
    return data;
  }
}
