class StepModel {
  final int id;
  final String text;
  final String image;

  StepModel({this.id, this.text, this.image});

  static List<StepModel> list = [
    StepModel(
        id: 1,
        text:
            "Browse the menu\nand order directly from\nthe application",
        image: 'assets/images/1.png'),
    StepModel(
        id: 2,
        text:
            "Your order will be\nimmediately collected and\nsent by our courier",
        image: 'assets/images/2.png'),
    StepModel(
        id: 3,
        text:
            "Pick update delivery\nat your door and enjoy\ngroceries",
        image: 'assets/images/3.png'),
  ];
}
