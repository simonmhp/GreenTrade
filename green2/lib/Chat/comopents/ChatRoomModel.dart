class ChatRoomModel {
  String? chatroomid;
  String? productid;
  Map<String, dynamic>? participants;
  String? lastMessage;

  ChatRoomModel(
      {this.chatroomid, this.participants, this.lastMessage, this.productid});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    participants = map["participants"];
    lastMessage = map["lastmessage"];
    productid = map["productid"];
  }

  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "participants": participants,
      "lastmessage": lastMessage,
      "productid": productid,
    };
  }
}
