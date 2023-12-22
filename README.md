# Unfreeze
A Dart package for isolate execution of asynchronous tasks using Dart isolates in Flutter projects.Also track the progress of each task , time and display the remaining time and handel errors easily.

# Features:
- **Isolate-based Concurrency:** Leverage Dart isolates for parallel execution of asynchronous tasks, enhancing performance in Flutter applications.

- **Progress Tracking:** Monitor and track the progress of each concurrent task, providing real-time insights into the execution status.

- **Remaining Time Calculation:** Dynamically time and display the remaining time for each task, allowing for better task management and user experience.

- **After-Task Reporting:** Receive updates on tasks completed, enabling post-execution actions or additional processing steps after the isolates have finished their work.

- **Error Handling:** Gracefully handle errors within asynchronous tasks and propagate them back to the main isolate for comprehensive error management.


## Installation

Add the following to your pubspec.yaml file:

```bash
dependencies:
  unfreeze: ^1.0.0
```

Or simply run:

```bash
dart pub add unfreeze
```



## ✨ Examples

For single isolation use **unfreeze** function.
```dart
import 'package:unfreeze/unfreeze.dart';

void main() {
  print('1st task');
  unfreeze(
    function: demoAsyncFun,
    onProgress: (progress) => print('Progress from main isolate: $progress%'),
    remaining: (time) => print(
        'Remaining time from main isolate: ${time.inSeconds} seconds'),
    then: () => print('Do some work after isolate completion...'),
    onError: (error) => print('Error from main isolate1: $error'),
  );
  print('3rd task');
  //Third task will be continue without waiting 💡

}
```
For multiple isolation use **unfreezeTasks** function.
```dart
unfreezeTasks(
    tasks: [primeCheck, task1, task2],
    //Pass all tasks here 🤝
    onProgress: (progress) {
      print('Progress from main isolate thread: $progress%');
    },
    onRemainingTime: (remainingTime) {
      print(
          'Remaining time from main isolate thread: ${remainingTime.inSeconds} seconds');
    },
    then: () {
      print('Remaining work after isolates completion thread...');
    },
    onError: (error) {
      print('Error from main isolate thread: $error');
    },
  );
```

## Badges


[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)

[![Opensource](https://img.shields.io/static/v1?label=opensource&message=❤&color=red)](https://github.com/arrahmanbd/unfreeze)

**✨  Feel free to contribute and add new features**

## Author

- [@arrahmanbd](https://www.github.com/arrahmanbd)
