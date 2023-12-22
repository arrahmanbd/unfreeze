import 'package:unfreeze/unfreeze.dart';
import 'package:test/test.dart';

import '../example/demo_tasks.dart';

void main() {
  group('A group of isolation tests', () {
    test('Test SingleThread function', () {
      return unfreeze(
        function: () => demoAsyncFun(),
        onProgress: (progress) =>
            print('Progress from main isolate: $progress%'),
        remaining: (calculate) => print(
            'Remaining time from main isolate: ${calculate.inSeconds} seconds'),
        then: () => print('Do some work after isolate completion...'),
        onError: (error) => print('Error from main isolate1: $error'),
      );
    });
    test('Test multiThread function', () {
      return unfreezeTasks(
        tasks: [primeCheck, task1, task2],
        onProgress: (progress) {
          print('Progress from main isolate 2nd thread: $progress%');
        },
        onRemainingTime: (remainingTime) {
          print(
              'Remaining time from main isolate 2nd thread: ${remainingTime.inSeconds} seconds');
        },
        then: () {
          print('Remaining work after isolates completion 2nd thread...');
        },
        onError: (error) {
          print('Error from main isolate 2nd thread: $error');
        },
      );
    });
  });
}
