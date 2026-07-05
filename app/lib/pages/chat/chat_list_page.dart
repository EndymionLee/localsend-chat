import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localsend_app/gen/strings.g.dart';
import 'package:localsend_app/model/chat_conversation.dart';
import 'package:localsend_app/model/chat_group.dart';
import 'package:localsend_app/pages/chat/chat_page.dart';
import 'package:localsend_app/pages/chat/create_group_page.dart';
import 'package:localsend_app/provider/chat_provider.dart';
import 'package:localsend_app/provider/network/nearby_devices_provider.dart';
import 'package:localsend_app/provider/security_provider.dart';
import 'package:refena_flutter/refena_flutter.dart';
import 'package:routerino/routerino.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final conversations = context.ref.watch(chatProvider);
    final groups = context.ref.watch(chatGroupProvider);
    final hasContent = conversations.isNotEmpty || groups.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(t.chatTab.title), actions: const [_PlusMenu()]),
      body: hasContent ? _buildList(context, conversations, groups) : _buildEmpty(context),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.chat_bubble_outline, size: 80, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(t.chatTab.noConversations, textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
        ]),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<ChatConversation> conversations, List<ChatGroup> groups) {
    final items = <Widget>[];
    if (groups.isNotEmpty) {
      items.add(Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Text('Groups', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.primary)),
      ));
      for (final g in groups) {
        final lastMsg = g.messages.isNotEmpty ? g.messages.last : null;
        items.add(_buildTile(context, g.name, lastMsg?.message ?? '', g.lastActivity, Icons.group, 'g-${g.id}',
          () => context.push(() => ChatPage(group: g)),
          () => context.ref.redux(chatGroupProvider).dispatchAsync(DeleteGroupAction(g.id)),
        ));
      }
    }
    if (conversations.isNotEmpty) {
      items.add(Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Text('Direct Messages', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.primary)),
      ));
      final sorted = List<ChatConversation>.from(conversations)..sort((a, b) => b.lastActivity.compareTo(a.lastActivity));
      for (final conv in sorted) {
        final lastMsg = conv.lastMessage;
        items.add(_buildTile(context, conv.deviceAlias, lastMsg?.message ?? '', conv.lastActivity, Icons.devices, 'c-${conv.deviceFingerprint}',
          () => context.push(() => ChatPage(fingerprint: conv.deviceFingerprint, alias: conv.deviceAlias, ip: conv.deviceIp, port: conv.devicePort, https: conv.deviceHttps)),
          () => context.ref.redux(chatProvider).dispatchAsync(DeleteConversationAction(conv.deviceFingerprint)),
        ));
      }
    }
    return ListView(children: items);
  }

  Widget _buildTile(BuildContext context, String title, String subtitle, DateTime time, IconData icon, String key, VoidCallback onTap, VoidCallback onDelete) {
    return Dismissible(
      key: Key(key),
      direction: DismissDirection.endToStart,
      background: Container(alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), color: Theme.of(context).colorScheme.error, child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onError)),
      confirmDismiss: (_) async => await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
        title: Text(t.chatTab.deleteConversation), content: Text(t.general.confirm),
        actions: [
          TextButton(onPressed: () => ctx.pop(false), child: Text(t.general.cancel)),
          TextButton(onPressed: () => ctx.pop(true), child: Text(t.general.delete)),
        ],
      )).then((v) => v ?? false),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(subtitle.length > 50 ? '${subtitle.substring(0, 50)}...' : subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Text(_formatTime(time), style: Theme.of(context).textTheme.bodySmall),
        onTap: onTap,
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return DateFormat.Hm().format(time.toLocal());
    return DateFormat.MMMd().format(time.toLocal());
  }
}

class _PlusMenu extends StatelessWidget {
  const _PlusMenu();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuAction>(
      icon: const Icon(Icons.add),
      onSelected: (action) {
        switch (action) {
          case _MenuAction.createGroup:
            context.push(() => const CreateGroupPage());
          case _MenuAction.newChat:
            _showDevicePicker(context);
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: _MenuAction.createGroup, child: ListTile(leading: Icon(Icons.group_add), title: Text('Create Group'), contentPadding: EdgeInsets.zero)),
        PopupMenuItem(value: _MenuAction.newChat, child: ListTile(leading: Icon(Icons.person_add), title: Text('New Chat'), contentPadding: EdgeInsets.zero)),
      ],
    );
  }

  void _showDevicePicker(BuildContext context) {
    final myFingerprint = context.ref.read(securityProvider).certificateHash;
    showDialog(
      context: context,
      builder: (ctx) {
        final devices = ctx.ref.watch(nearbyDevicesProvider);
        final allDevices = devices.allDevices.values
            .where((d) => d.fingerprint != myFingerprint)
            .toList();
        return AlertDialog(
          title: const Text('Select Device'),
          content: SizedBox(
            width: 300,
            child: allDevices.isEmpty
                ? const Text('No devices nearby.')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: allDevices.length,
                    itemBuilder: (_, i) {
                      final d = allDevices[i];
                      return ListTile(
                        leading: const Icon(Icons.devices),
                        title: Text(d.alias),
                        subtitle: Text(d.ip ?? ''),
                        onTap: () {
                          ctx.pop();
                          context.push(() => ChatPage(fingerprint: d.fingerprint, alias: d.alias, ip: d.ip!, port: d.port, https: d.https));
                        },
                      );
                    },
                  ),
          ),
          actions: [TextButton(onPressed: () => ctx.pop(), child: Text(t.general.cancel))],
        );
      },
    );
  }
}

enum _MenuAction { createGroup, newChat }
