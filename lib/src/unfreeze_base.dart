import 'dart:async';
import 'dart:isolate';
import 'unfreeze_worker.dart';

void unfreeze<T>({
  required Future<T> Function() function,
  required Function(double) progress,
  required Function(Duration) remaining,
  required Function() then,
  required Function(dynamic) onError,
}) async {
  final ReceivePort receivePort = ReceivePort();
  final worker = UnfreezeWorker<T>(function, progress, remaining);

  await Isolate.spawn(
      _isolateFunction, {'worker': worker, 'port': receivePort.sendPort});

  receivePort.listen((dynamic message) {
    if (message is double) {
      progress(message);
    } else if (message is Duration) {
      remaining(message);
    } else if (message is String && message == 'complete') {
      then();
      receivePort.close();
    } else {
      onError(message);
      receivePort.close();
    }
  });
}

void _isolateFunction(Map<String, dynamic> payload) async {
  final UnfreezeWorker worker = payload['worker'];
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
