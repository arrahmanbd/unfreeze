import 'dart:async';
import 'dart:isolate';
import 'unfreeze_worker.dart';

void unfreezeTasks<T>({
  required List<Future<T> Function()> tasks,
  required Function(double) progress,
  required Function(Duration) onRemainingTime,
  required Function() then,
  required Function(dynamic) onError,
}) async {
  final List<ReceivePort> receivePorts = [];

  for (var task in tasks) {
    final ReceivePort receivePort = ReceivePort();
    final worker = UnfreezeWorker<T>(task, progress, onRemainingTime);
    receivePorts.add(receivePort);

    await Isolate.spawn(
        _isolateFunction, {'worker': worker, 'port': receivePort.sendPort});
  }

  // Listen for messages from all isolates
  for (var receivePort in receivePorts) {
    receivePort.listen((dynamic message) {
      if (message is double) {
        // Progress message received
        progress(message);
      } else if (message is Duration) {
        // Remaining time message received
        onRemainingTime(message);
      } else if (message is String && message == 'complete') {
        // Completion message received
        print('Isolate completed.');
        then();
        receivePort.close();
      } else {
        // Error message received
        onError(message);
        receivePort.close();
      }
    });
  }
}

void _isolateFunction(Map<String, dynamic> payload) async {
  final UnfreezeWorker<dynamic> worker = payload['worker'];
  final SendPort sendPort = payload['port'];

  final DateTime startTime = DateTime.now();
  final int totalIterations = 10;
  int currentIteration = 0;
  Timer.periodic(Duration(seconds: 1), (timer) {
    final double progress = ++currentIteration / totalIterations * 100;
    final Duration elapsedTime = DateTime.now().difference(startTime);
    final Duration remainingTime = Duration(
        seconds: (totalIterations - currentIteration) * elapsedTime.inSeconds);

    worker.reportProgress(progress);
    worker.reportRemainingTime(remainingTime);

    if (currentIteration == totalIterations) {
      timer.cancel();
      sendPort.send('complete');
    }
  });

  try {
    await worker.run();
  } catch (error) {
    sendPort.send(error);
  }
}
