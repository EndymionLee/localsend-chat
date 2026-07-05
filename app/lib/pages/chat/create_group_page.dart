import 'package:flutter/material.dart';
import 'package:localsend_app/model/chat_group.dart';
import 'package:localsend_app/provider/chat_provider.dart';
import 'package:localsend_app/provider/network/nearby_devices_provider.dart';
import 'package:localsend_app/provider/security_provider.dart';
import 'package:localsend_app/provider/settings_provider.dart';
import 'package:refena_flutter/refena_flutter.dart';
import 'package:routerino/routerino.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> with Refena {
  final _nameController = TextEditingController();
  final Set<String> _selectedFingerprints = {};

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myFingerprint = ref.read(securityProvider).certificateHash;
    final devices = ref.watch(nearbyDevicesProvider);
    final allDevices = devices.allDevices.values
        .where((d) => d.fingerprint != myFingerprint)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
        actions: [
          TextButton(
            onPressed: _selectedFingerprints.isEmpty ? null : _createGroup,
            child: const Text('Create'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.group),
              ),
              autofocus: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('Select Members', style: Theme.of(context).textTheme.titleSmall),
                const Spacer(),
                Text('${_selectedFingerprints.length} selected'),
              ],
            ),
          ),
          Expanded(
            child: allDevices.isEmpty
                ? const Center(child: Text('No devices nearby. Make sure other devices are on the same network.'))
                : ListView.builder(
                    itemCount: allDevices.length,
                    itemBuilder: (_, i) {
                      final d = allDevices[i];
                      final selected = _selectedFingerprints.contains(d.fingerprint);
                      return CheckboxListTile(
                        title: Text(d.alias),
                        subtitle: Text(d.ip ?? ''),
                        value: selected,
                        onChanged: (v) {
                          setState(() {
                            if (v == true) {
                              _selectedFingerprints.add(d.fingerprint);
                            } else {
                              _selectedFingerprints.remove(d.fingerprint);
                            }
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _createGroup() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final fingerprint = ref.read(securityProvider).certificateHash;
    final settings = ref.read(settingsProvider);
    final devices = ref.read(nearbyDevicesProvider);

    final members = <ChatGroupMember>[];
    // Add selected members (self is already the admin, not a member target)
    for (final d in devices.allDevices.values) {
      if (_selectedFingerprints.contains(d.fingerprint) && d.ip != null) {
        members.add(ChatGroupMember(
          fingerprint: d.fingerprint, alias: d.alias,
          ip: d.ip!, port: d.port, https: d.https,
        ));
      }
    }

    ref.redux(chatGroupProvider).dispatchAsync(CreateGroupAction(
      name: name, adminFingerprint: fingerprint, adminAlias: settings.alias,
      adminIp: '127.0.0.1', adminPort: settings.port, adminHttps: settings.https,
      members: members,
    ));

    context.pop();
  }
}
