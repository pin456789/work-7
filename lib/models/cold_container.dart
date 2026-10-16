class ColdContainer {
  String unitId;
  String productType;
  String qaEmail;
  double tempLimit;
  int transitHours;
  String route;

  ColdContainer({
    required this.unitId,
    required this.productType,
    required this.qaEmail,
    required this.tempLimit,
    required this.transitHours,
    this.route = '-',
  });
}
