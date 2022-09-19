class SmsResponse {
  String? bank;
  String? balance;
  String? time;
  String? content;
  String? error;

  SmsResponse({this.bank, this.balance, this.time, this.content, this.error});

  factory SmsResponse.fromJson(Map<String, dynamic> json) => SmsResponse(
      bank: json['bank'],
      balance: json['balance'],
      time: json['time'],
      content: json['content'],
      error: json['error']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bank'] = this.bank;
    data['balance'] = this.balance;
    data['time'] = this.time;
    data['content'] = this.content;
    data['error'] = this.error;
    return data;
  }
}
