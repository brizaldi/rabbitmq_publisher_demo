import 'dart:convert';

import 'package:dart_amqp/dart_amqp.dart';

Future<void> publishFanOutMessages(
  ConnectionSettings settings, {
  int numberOfMessages = 10,
}) async {
  final client = Client(settings: settings);

  const exchangeName = 'amq.fanout';
  const exchangeType = ExchangeType.FANOUT;

  final channel = await client.channel();
  final exchange = await channel.exchange(
    exchangeName,
    exchangeType,
    durable: true,
  );

  for (var i = 1; i <= numberOfMessages; i++) {
    final message = {
      'counter': i,
      'name': exchangeName,
      'type': exchangeType.value,
    };

    final json = jsonEncode(message);

    exchange.publish(json, '*.broadcast');
    print(' [$i] Sent $message');

    await Future.delayed(const Duration(milliseconds: 500));
  }

  await client.close();
}
