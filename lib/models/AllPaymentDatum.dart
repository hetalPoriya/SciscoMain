class AllPaymentDatum{
  String id;
  String req_amount;
  String created_at;
  String release_date;
  String release_amt;
  String job_num;
  String status;




  AllPaymentDatum(this.id
      , this.req_amount
      , this.created_at
      , this.release_date
      , this.release_amt
      , this.job_num
      , this.status
   );
  factory AllPaymentDatum.fromJson(Map<String, dynamic> json) => AllPaymentDatum(json["id"]
      ,json["req_amount"]
      ,json["created_at"]
      ,json["release_date"]
      ,json["release_amt"]
      ,json["job_num"]
      ,json["status"]
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "req_amount": req_amount,
    "created_at": created_at,
    "release_date": release_date,
    "release_amt": release_amt,
    "job_num": job_num,
    "status": status,

  };



}