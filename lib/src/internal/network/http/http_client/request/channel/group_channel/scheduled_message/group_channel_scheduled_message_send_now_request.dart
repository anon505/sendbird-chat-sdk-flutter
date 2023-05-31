// Copyright (c) 2023 Sendbird, Inc. All rights reserved.

import 'package:sendbird_chat_sdk/src/internal/main/chat/chat.dart';
import 'package:sendbird_chat_sdk/src/internal/main/extensions/extensions.dart';
import 'package:sendbird_chat_sdk/src/internal/network/http/http_client/http_client.dart';
import 'package:sendbird_chat_sdk/src/internal/network/http/http_client/request/api_request.dart';
import 'package:sendbird_chat_sdk/src/public/main/define/enums.dart';

class GroupChannelScheduledMessageSendNowRequest extends ApiRequest {
  @override
  HttpMethod get method => HttpMethod.post;

  GroupChannelScheduledMessageSendNowRequest(
    Chat chat, {
    required ChannelType channelType,
    required String channelUrl,
    required int scheduledMessageId,
  }) : super(chat: chat) {
    url =
        '${channelType.urlString}/$channelUrl/scheduled_messages/$scheduledMessageId/send_now';
  }
}
