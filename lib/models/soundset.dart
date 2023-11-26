class SoundSet {
  String name;
  String description;
  String repo;
  String? download;
  String? path;
  Map? plist;
  bool tmp;

  SoundSet({
    required this.name,
    required this.description,
    required this.repo,
    this.download,
    this.path,
    this.plist,
    this.tmp = false,
  });
}
