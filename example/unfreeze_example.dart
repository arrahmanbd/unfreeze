import 'package:unfreeze/unfreeze.dart';

import 'demo_tasks.dart';

void main() {
  print('1: Hello World');
//This function will go for isolation because it is heavy
  unfreeze(
    function: demoAsyncFun,
    progress: (progress) => print('Progress from main isolate: $progress%'),
    remaining: (calculate) => print(
        'Remaining time from main isolate: ${calculate.inSeconds} seconds'),
    then: () => print('Do some work after isolate completion...'),
    onError: (error) => print('Error from main isolate1: $error'),
  );
  //Second task
  //This task will be complete before previous async function
  print('3: Previous task is running in isolation');
  //I have more heavy task todo
  //This function will go for isolation because it is heavy

  unfreezeTasks(
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
  print(
      '7: Previous prime,task1,task2 is running in isolation\nAnd its complete');
}
