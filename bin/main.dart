import 'package:args/args.dart';
import 'package:dart_amqp/dart_amqp.dart';
import 'package:rabbitmq_publisher/fanout.dart';
import 'package:rabbitmq_publisher/round_robin.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('t', defaultsTo: '1')
    ..addOption('type');

  final argResults = parser.parse(arguments);
  final numberOfLoop = int.tryParse(argResults['t']) ?? 10;
  final type = argResults['type'] as String?;

  final settings = ConnectionSettings(
    host: '127.0.0.1',
    port: 5672,
    authProvider: PlainAuthenticator(
      'admin',
      'admin12345',
    ),
  );

  switch (type) {
    case 'fanout':
      await publishFanOutMessages(settings, numberOfMessages: numberOfLoop);
      break;
    default:
      await publishQueuedMessages(settings, numberOfMessages: numberOfLoop);
  }
}
