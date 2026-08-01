class PlanningModel {
  final int id;

  final String drawingNo;
  final String drawingVersion;
  final String itemDesc;
  final String vendorName;
  final String pCode;

  final String monthOfPlanning;
  final String weekOfPlanning;
  final DateTime? weekStartDate;
  final DateTime? weekEndDate;

  final double departmentQty;
  final double remainStock;

  final String priorityStatus;
  final String currentStatus;

  final String vendorStatus;
  final DateTime? vendorDate;

  final String drawingPdf;

  PlanningModel({
    required this.id,
    required this.drawingNo,
    required this.drawingVersion,
    required this.itemDesc,
    required this.vendorName,
    required this.pCode,
    required this.monthOfPlanning,
    required this.weekOfPlanning,
    required this.weekStartDate,
    required this.weekEndDate,
    required this.departmentQty,
    required this.remainStock,
    required this.priorityStatus,
    required this.currentStatus,
    required this.vendorStatus,
    required this.vendorDate,
    required this.drawingPdf,
  });

  factory PlanningModel.fromJson(Map<String, dynamic> json) {
    return PlanningModel(
      id: int.tryParse(json["id"].toString()) ?? 0,

      drawingNo: json["DrawingNo"] ?? "",
      drawingVersion: json["DrawingVersion"] ?? "",

      itemDesc: json["ItemDesc"] ?? "",

      vendorName: json["VendorName"] ?? "",

      pCode: json["PCode"] ?? "",

      monthOfPlanning: json["MonthOfPlaning"] ?? "",

      weekOfPlanning: json["WeekOfPlanning"] ?? "",

      weekStartDate: json["WeekStartDate"] == null
          ? null
          : DateTime.parse(json["WeekStartDate"]),
      weekEndDate: json["WeekEndDate"] == null
          ? null
          : DateTime.parse(json["WeekEndDate"]),

      departmentQty:
          double.tryParse(json["DepartmentQty"].toString()) ?? 0,

      remainStock:
          double.tryParse(json["RemainStock"].toString()) ?? 0,

      priorityStatus:
          json["PriorityStatus"] ?? "Planned",

      currentStatus:
          json["CurrentStatus"] ?? "Pending",

      vendorStatus:
          json["VendorStatus"] ?? "Pending",

      vendorDate: json["VendorDate"] == null
          ? null
          : DateTime.parse(json["VendorDate"]),

      drawingPdf: json["DrawingPdf"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "DrawingNo": drawingNo,
      "DrawingVersion": drawingVersion,
      "ItemDesc": itemDesc,
      "VendorName": vendorName,
      "PCode": pCode,
      "MonthOfPlaning": monthOfPlanning,
      "WeekOfPlanning": weekOfPlanning,
      "WeekStartDate":weekStartDate?.toIso8601String(),
      "WeekEndDate": weekEndDate?.toIso8601String(),
      "DepartmentQty": departmentQty,
      "RemainStock": remainStock,
      "PriorityStatus": priorityStatus,
      "CurrentStatus": currentStatus,
      "VendorStatus": vendorStatus,
      "VendorDate":
          vendorDate?.toIso8601String(),
          "DrawingPdf": drawingPdf,
    };
  }

  /// Pending
  bool get isPending => vendorStatus == "Pending";

  /// Accepted
  bool get isAccepted => vendorStatus == "Accept";

  /// Rejected
  bool get isRejected => vendorStatus == "Reject";

  /// Progress %
}