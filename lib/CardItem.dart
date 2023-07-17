class CardItem {
  int state;
  String name;
  String targetName;
  String timeValue;
  String alert;
  String subalert;
  String value;
  String description;
  String label;
  String ip;
  bool isExpanded; // Поле для отслеживания расширения/свертывания карточки

  CardItem({
    required this.state,
    required this.name,
    required this.targetName,
    required this.timeValue,
    required this.alert,
    required this.subalert,
    required this.value,
    required this.ip,
    required this.description,
    required this.label,
    this.isExpanded = false, // Изначально карточка свернута
  });
}
