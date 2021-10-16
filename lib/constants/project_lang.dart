class ProjectLang {
  final String lanaguageCode, title, image;
  ProjectLang({this.title, this.lanaguageCode, this.image});
}

List<ProjectLang> projectLang = [
  new ProjectLang(
      title: 'English', lanaguageCode: 'en', image: 'assets/images/us.jpg'),
  new ProjectLang(
      title: 'मराठी', lanaguageCode: 'mr', image: 'assets/images/india.png'),
];
