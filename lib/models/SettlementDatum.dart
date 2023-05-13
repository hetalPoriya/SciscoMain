class SettlementDatum{
String id;
String req_amount;
String created_at;
String release_date;
String release_amt;



SettlementDatum(this.id
, this.req_amount
, this.created_at
, this.release_date
, this.release_amt
    );

factory SettlementDatum.fromJson(Map<String, dynamic> json) => SettlementDatum(json["id"]
,json["req_amount"]
,json["created_at"]
,json["release_date"]
,json["release_amt"]);

Map<String, dynamic> toJson() => {
  "id": id,
  "req_amount": req_amount,
  "created_at": created_at,
  "release_date": release_date,
  "release_amt": release_amt,
};



}