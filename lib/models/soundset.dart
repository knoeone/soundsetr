class SoundSet {
  String name;
  String description;
  String repo;
  String download;
  String? path;
  Map? plist;

  SoundSet({
    required this.name,
    required this.description,
    required this.repo,
    required this.download,
    this.path,
    this.plist,
  });
}
