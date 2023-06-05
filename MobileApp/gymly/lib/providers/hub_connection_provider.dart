import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/chat_message.dart';
import 'package:gymly/models/trainer.dart';
import 'package:signalr_netcore/ihub_protocol.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'auth_provider.dart';
import 'package:logging/logging.dart';

class HubConnectionProviderState {
  final HubConnection? connection;
  final bool? joinedChat;

  const HubConnectionProviderState({this.connection, this.joinedChat});

  HubConnectionProviderState copyWith({
    HubConnection? connection,
    bool? joinedChat,
  }) {
    print("Connection: ${this.connection}");
    return HubConnectionProviderState(
      connection: connection ?? this.connection,
      joinedChat: joinedChat ?? this.joinedChat,
    );
  }
}

class HubConnectionProviderStateNotifier
    extends StateNotifier<HubConnectionProviderState> {
  final chatHubUrl = dotenv.env['CHAT_HUB_URL'];

  final hubProtLogger = Logger("SignalR - hub");
  final transportProtLogger = Logger("SignalR - transport");

  HubConnectionProviderStateNotifier()
      : super(const HubConnectionProviderState(joinedChat: false));

  Future<void> connect() async {
    try {
      if (state.connection != null) {
        return;
      }

      final httpOptions = HttpConnectionOptions(
        logMessageContent: true,
        logger: transportProtLogger,
      );

      var connection = HubConnectionBuilder()
          .withUrl(chatHubUrl!, options: httpOptions)
          .configureLogging(hubProtLogger)
          .build();

      connection.onclose(({Exception? error}) => print("Connection Closed"));

      await connection.start();

      state = state.copyWith(connection: connection);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> assignChatChannelFunction(Function(ChatMessage) callback) async {
    state.connection!.off("ChatChannel");
    state.connection!.on("ChatChannel", (List<Object?>? parameters) {
      callback(ChatMessage.fromJson(parameters![0] as Map<String, dynamic>));
    });
  }

  Future<void> sendMessage(
    String message,
    String subjectId,
    String receiverId,
  ) async {
    print("SendConnection: ${state.connection}");
    if (state.connection == null ||
        state.connection!.state != HubConnectionState.Connected) {
      await connect();
    }
    final result = await state.connection!
        .invoke("SendMessage", args: <Object>[message, subjectId, receiverId]);
  }

  Future<void> joinChat(String subjectId) async {
    if (state.joinedChat!) return;

    print("JOIN");
    final result =
        await state.connection!.invoke("JoinChat", args: <Object>[subjectId]);

    state = state.copyWith(joinedChat: true);
  }

  Future<void> leaveChat(String subjectId) async {
    if (state.connection == null ||
        state.connection!.state != HubConnectionState.Connected) {
      await connect();
    }

    final result =
        await state.connection!.invoke("LeaveChat", args: <Object>[subjectId]);

    state = state.copyWith(joinedChat: false);
  }
}

final hubConnectionProvider = StateNotifierProvider<
    HubConnectionProviderStateNotifier, HubConnectionProviderState>(
  (ref) => HubConnectionProviderStateNotifier(),
);
