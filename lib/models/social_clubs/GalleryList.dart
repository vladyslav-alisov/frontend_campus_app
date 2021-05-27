class GalleryList {
  String sTypename;
  List<Gallery> gallery;

  GalleryList({this.sTypename, this.gallery});

  GalleryList.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    if (json['gallery'] != null) {
      gallery = new List<Gallery>();
      json['gallery'].forEach((v) {
        gallery.add(new Gallery.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    if (this.gallery != null) {
      data['gallery'] = this.gallery.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Gallery {
  String sTypename;
  String postID;
  String imageUrl;
  String description;
  String createdAt;

  Gallery(
      {this.sTypename,
        this.postID,
        this.imageUrl,
        this.description,
        this.createdAt});

  Gallery.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    postID = json['postID'];
    imageUrl = json['imageUrl'];
    description = json['description'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    data['postID'] = this.postID;
    data['imageUrl'] = this.imageUrl;
    data['description'] = this.description;
    data['createdAt'] = this.createdAt;
    return data;
  }
}