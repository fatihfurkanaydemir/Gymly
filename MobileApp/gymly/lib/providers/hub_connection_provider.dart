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

  const HubConnectionProviderState({this.connection});

  HubConnectionProviderState copyWith({HubConnection? connection}) {
    return HubConnectionProviderState(
      connection: connection ?? this.connection,
    );
  }
}

class HubConnectionProviderStateNotifier
    extends StateNotifier<HubConnectionProviderState> {
  final chatHubUrl = dotenv.env['CHAT_HUB_URL'];

  final hubProtLogger = Logger("SignalR - hub");
  final transportProtLogger = Logger("SignalR - transport");

  HubConnectionProviderStateNotifier()
      : super(const HubConnectionProviderState());

  Future<void> connect() async {
    try {
      print("RECONNECT");
      final httpOptions = HttpConnectionOptions(
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
    if (state.connection == null ||
        state.connection!.state != HubConnectionState.Connected) {
      await connect();
    }

    state.connection!.on("ChatChannel", (List<Object?>? parameters) {
      print(ChatMessage.fromJson(parameters![0] as Map<String, dynamic>)
          .senderId);
      callback(ChatMessage.fromJson(parameters![0] as Map<String, dynamic>));
    });
  }

  Future<void> sendMessage(
      String message, String subjectId, String receiverId) async {
    if (state.connection == null ||
        state.connection!.state != HubConnectionState.Connected) {
      await connect();
    }
    final result = await state.connection!
        .invoke("SendMessage", args: <Object>[message, subjectId, receiverId]);
    hubProtLogger.log(Level.SEVERE, "Result: '$result");
  }

  Future<void> joinChat(String subjectId) async {
    if (state.connection == null ||
        state.connection!.state != HubConnectionState.Connected) {
      await connect();
    }
    final result =
        await state.connection!.invoke("JoinChat", args: <Object>[subjectId]);
    hubProtLogger.log(Level.SEVERE, "Result: '$result");
  }

  Future<void> leaveChat(String subjectId) async {
    if (state.connection == null ||
        state.connection!.state != HubConnectionState.Connected) {
      await connect();
    }
    final result =
        await state.connection!.invoke("LeaveChat", args: <Object>[subjectId]);
    hubProtLogger.log(Level.SEVERE, "Result: '$result");
  }
}

final hubConnectionProvider = StateNotifierProvider<
    HubConnectionProviderStateNotifier, HubConnectionProviderState>(
  (ref) => HubConnectionProviderStateNotifier(),
);
