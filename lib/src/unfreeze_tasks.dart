import 'dart:async';
import 'dart:isolate';
import 'unfreeze_worker.dart';

void unfreezeTasks({
  required List<Future<void> Function()> tasks,
  required Function(double) onProgress,
  required Function(Duration) onRemainingTime,
  required Function() then,
  required Function(dynamic) onError,
}) async {
  final List<ReceivePort> receivePorts = [];

  for (var task in tasks) {
    final ReceivePort receivePort = ReceivePort();
    final worker = Worker(task, onProgress, onRemainingTime);
    receivePorts.add(receivePort);

    await Isolate.spawn(
        _isolateFunction, {'worker': worker, 'port': receivePort.sendPort});
  }

  // Listen for messages from all isolates
  for (var receivePort in receivePorts) {
    receivePort.listen((dynamic message) {
      if (message is double) {
        // Progress message received
        onProgress(message);
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
  final Worker worker = payload['worker'];
  final SendPort sendPort = payload['port'];

  // Track the start time for calculating elapsed and remaining time
  final DateTime startTime = DateTime.now();

  // Set up a timer to simulate progress reporting
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
      sendPort.send('complete'); // Signal completion to the main isolate
    }
  });

  // Run the async function
  try {
    await worker.run();
  } catch (error) {
    // Send error message to the main isolate
    sendPort.send(error);
  }
}
