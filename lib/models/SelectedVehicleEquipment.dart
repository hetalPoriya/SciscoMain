class SelectedVehicleEquipment{
  String id;
  SelectedVehicleEquipment(this.id);

  factory SelectedVehicleEquipment.fromJson(Map<String, dynamic> json) => SelectedVehicleEquipment(json["id"]

  );

  Map<String, dynamic> toJson() => {
    "id": id,
  };

}