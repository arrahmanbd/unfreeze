import 'dart:async';
import 'dart:isolate';
import 'unfreeze_worker.dart';

void unfreeze({
  required Future<void> Function() function,
  required Function(double) onProgress,
  required Function(Duration) remaining,
  required Function() then,
  required Function(dynamic) onError,
}) async {
  final ReceivePort receivePort = ReceivePort();

  // Create a Worker instance with the provided function and callbacks
  final worker = Worker(function, onProgress, remaining);

  // Spawn a new isolate
  await Isolate.spawn(
      _isolateFunction, {'worker': worker, 'port': receivePort.sendPort});

  // Listen for messages from the isolate
  receivePort.listen((dynamic message) {
    if (message is double) {
      // Progress message received
      onProgress(message);
    } else if (message is Duration) {
      // Remaining time message received
      remaining(message);
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
