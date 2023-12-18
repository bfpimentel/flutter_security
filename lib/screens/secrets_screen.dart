import 'package:flutter/material.dart';
import 'package:flutter_security/components/fullscreen_loading.dart';
import 'package:flutter_security/models/secret.dart';
import 'package:flutter_security/screens/add_secret_screen.dart';
import 'package:security/security_client.dart';

class SecretsScreen extends StatefulWidget {
  final String username;
  final SecurityClient userSecurityClient;

  const SecretsScreen({
    super.key,
    required this.username,
    required this.userSecurityClient,
  });

  @override
  State<SecretsScreen> createState() => _SecretsScreenState();
}

class _SecretsScreenState extends State<SecretsScreen> {
  addSecret(final BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSecretScreen(
          userSecurityClient: widget.userSecurityClient,
        ),
      ),
    ).then((value) => null);
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Secrets for ${widget.username}"),
      ),
      body: FutureBuilder(
        future: widget.userSecurityClient.getAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<Secret> secrets = snapshot.data!.entries.map(
              (element) {
                return Secret(
                  key: element.key,
                  value: element.value,
                );
              },
            ).toList();

            return ListView.builder(
              itemCount: secrets.length,
              itemBuilder: (context, index) {
                final Secret user = secrets[index];
                return secretItem(context, user);
              },
            );
          } else {
            return const FullScreenLoading();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addSecret(context),
        tooltip: "Add",
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget secretItem(final BuildContext context, final Secret secret) {
    return InkWell(
      onTap: () => print(secret.key),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "Name: ${secret.key}",
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal),
            ),
            Text(
              "Value: ${secret.value}",
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
