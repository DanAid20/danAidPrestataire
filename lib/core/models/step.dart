class StepModel {
  final int? id;
  final String? text;
  final String? image;
  final String? title;

  StepModel({this.id, this.text, this.image, this.title});

  static List<StepModel> list = [
    StepModel(
        id: 1,
        title: "La Mutuelle Santé 100% Mobile !",
        text:
            "Avec votre famille, bénéficiez d’une couverture en 1 heure, de 70% des dépenses santé : consultation, pharmacie, laboratoire et hospitalisation partout au Cameroun.",
        image: 'assets/images/money.png'),
    StepModel(
        id: 2,
        text:
            "Consultez en temps réel la prise en charge des dépenses santé de votre famille à partir de votre mobile.",
        title: "Suivez vos prises en charge...",
        image: 'assets/images/doctor-examine-patient.png'),
    StepModel(
        id: 3,
        title: "Votre carte d’adhérent numérique.",
        text:
            " Votre mobile vous accompagne partout? Avec DanAid il est aussi votre carte d’adhérent et le porte-monnaie digital qui vous ouvre accès aux soins de santé. ",
        image: 'assets/images/mobile-card.png'),
  ];
}
