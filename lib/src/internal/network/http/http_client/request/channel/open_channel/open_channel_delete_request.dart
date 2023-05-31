// Copyright (c) 2023 Sendbird, Inc. All rights reserved.

import 'package:sendbird_chat_sdk/src/internal/main/chat/chat.dart';
import 'package:sendbird_chat_sdk/src/internal/network/http/http_client/http_client.dart';
import 'package:sendbird_chat_sdk/src/internal/network/http/http_client/request/api_request.dart';

class OpenChannelDeleteRequest extends ApiRequest {
  @override
  HttpMethod get method => HttpMethod.delete;

  OpenChannelDeleteRequest(
    Chat chat,
    String channelUrl,
  ) : super(chat: chat) {
    url = 'open_channels/$channelUrl';
  }
}
