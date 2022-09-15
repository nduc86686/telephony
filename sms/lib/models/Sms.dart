class SmsResponse {
  String? bank;
  String? balance;
  String? time;
  String? content;

  SmsResponse({this.bank, this.balance, this.time, this.content});

  SmsResponse.fromJson(Map<String, dynamic> json) {
    bank = json['bank'];
    balance = json['balance'];
    time = json['time'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bank'] = this.bank;
    data['balance'] = this.balance;
    data['time'] = this.time;
    data['content'] = this.content;
    return data;
  }
}
