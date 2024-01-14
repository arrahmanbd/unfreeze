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
    progress: (progress) => print('Progress from main isolate: $progress%'),
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
    progress: (progress) {
      print('Progress from main isolate thread: $progress%');
    },
    remaining: (time) {
      print(
          'Remaining time from main isolate thread: ${time.inSeconds} seconds');
    },
    then: () {
      print('Remaining work after isolates completion thread...');
    },
    onError: (error) {
      print('Error from main isolate thread: $error');
    },
  );
```
## ⚠️ Warning:
In Dart isolates, only a limited set of data types, known as "sendable" types, can be safely sent between isolates. These types include:

# Primitive types:

null
bool
num (including integers and doubles)
String
## Typed data:

## List and Uint8List
Int8List, Uint8List, Int16List, Uint16List, Int32List, Uint32List, Int64List, Uint64List
Float32List, Float64List
Other isolates:

## ReceivePort and SendPort
Capability
A few specific types from the dart:core library:

DateTime
Uri
It's important to note that functions, closures, and non-serializable objects cannot be sent between isolates. If you need to perform tasks in parallel isolates, make sure that the data you pass between them adheres to these restrictions.

If you encounter issues like "Unhandled Exception: Invalid argument(s): Illegal argument in isolate message: object is unsendable," review the code to identify the non-serializable object causing the problem and find an alternative solution.

## Badges


[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)

[![Opensource](https://img.shields.io/static/v1?label=opensource&message=❤&color=red)](https://github.com/arrahmanbd/unfreeze)

**✨  Feel free to contribute and add new features**

## Author

- [@arrahmanbd](https://www.github.com/arrahmanbd)
