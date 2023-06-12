import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/chat_message.dart';
import 'package:gymly/providers/auth_provider.dart';
import 'package:gymly/providers/storage_provider.dart';
import 'package:gymly/services/post_service.dart';
import 'package:signalr_netcore/hub_connection.dart';

import '../models/post.dart';
import '../services/chat_service.dart';
import 'hub_connection_provider.dart';

class ChatState {
  static const int pageSize = 20;

  final List<ChatMessage>? messages;
  final String? lastOtherUserId;
  final bool? isFirstFetch;
  final int? pageNumber;
  final bool? canFetchMore;

  const ChatState({
    this.messages,
    this.lastOtherUserId,
    this.pageNumber = 1,
    this.isFirstFetch = true,
    this.canFetchMore = true,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    String? lastOtherUserId,
    int? pageNumber,
    bool? isFirstFetch,
    bool? canFetchMore,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      lastOtherUserId: lastOtherUserId ?? this.lastOtherUserId,
      pageNumber: pageNumber ?? this.pageNumber,
      isFirstFetch: isFirstFetch ?? this.isFirstFetch,
      canFetchMore: canFetchMore ?? this.canFetchMore,
    );
  }
}

class ChatStateNotifier extends StateNotifier<ChatState> {
  ChatService chatService;
  HubConnectionProviderStateNotifier hubConnection;

  ChatStateNotifier(this.chatService, this.hubConnection)
      : super(const ChatState());

  Future<void> getChatHistory(String otherUserId) async {
    List<ChatMessage> messages = await chatService.getChatHistory(
      otherUserId: otherUserId,
      pageNumber: state.pageNumber!,
      pageSize: ChatState.pageSize,
    );

    state = state.copyWith(
      messages: [...state.messages ?? [], ...messages],
      pageNumber: state.pageNumber! + 1,
      lastOtherUserId: otherUserId,
      isFirstFetch: false,
      canFetchMore: messages.length >= ChatState.pageSize,
    );
  }

  Future<void> refreshChatHistory(String otherUserId) async {
    state = const ChatState(messages: [], isFirstFetch: false);

    await getChatHistory(otherUserId);
  }

  Future<void> sendMessage(
    String message,
    String subjectId,
    String receiverId,
  ) async {
    await hubConnection.sendMessage(message, subjectId, receiverId);

    state = state.copyWith(messages: [
      ChatMessage(DateTime.now().toString(), subjectId, receiverId, message,
          DateTime.now()),
      ...state.messages ?? [],
    ]);
  }

  getMessage(ChatMessage message) {
    if (state.lastOtherUserId != null &&
        state.lastOtherUserId != message.senderId) {
      return;
    }

    state = state.copyWith(messages: [
      message,
      ...state.messages ?? [],
    ]);
  }
}

final chatProvider = StateNotifierProvider<ChatStateNotifier, ChatState>(
    (ref) => ChatStateNotifier(
          ChatService(
            ref.watch(authProvider),
            ref.watch(authProvider.notifier),
            ref.watch(storageProvider),
          ),
          ref.watch(hubConnectionProvider.notifier),
        ));
