import 'dart:convert';

import 'package:dart_amqp/dart_amqp.dart';

Future<void> publishQueuedMessages(
  ConnectionSettings settings, {
  int numberOfMessages = 10,
}) async {
  final client = Client(settings: settings);

  final channel = await client.channel();

  const queueName = 'myqueue';
  final queue = await channel.queue(queueName, durable: true);

  for (var i = 1; i <= numberOfMessages; i++) {
    final message = {
      'counter': i,
      'name': queueName,
      'type': 'Round-robin',
    };

    final json = jsonEncode(message);

    queue.publish(
      json,
      properties: MessageProperties.persistentMessage(),
    );
    print(' [$i] Sent $message');

    await Future.delayed(const Duration(milliseconds: 500));
  }

  await client.close();
}
