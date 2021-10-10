class JsonUser {
  String email;
  String access_token;
  String client;
  String uuid;
  JsonUser({
    required this.email,
    required this.access_token,
    required this.client,
    required this.uuid,
  });
  factory JsonUser.fromJson(Map<String, dynamic> parsedJson) {
    Map json = parsedJson ;
    return JsonUser(
      email: json['email'],
      access_token: json['access-token'],
      client: json['client'],
      uuid: json['uuid'],
    );
  }
}