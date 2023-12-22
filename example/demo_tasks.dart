//Dummy heavy tasks
Future<void> primeCheck() async {
  bool prime =  isPrime(4139581);
  if (prime) {
    print('This is prime Number');
  } else {
    print('This is not a prime Number');
  }
}

//another demo function
Future<void> demoAsyncFun() async {
  // Replace this with your actual async function logic
  print('Async function is running...');
  await Future.delayed(Duration(seconds: 10));
  //It will throw eception after 3 seconds
  throw Exception('Simulated error during async function'); // Simulated error
}

//Dummy tasks
Future<void> task1() async {
  // Replace this with your actual async function logic for task1
  print('Task 1 is running...');
  await Future.delayed(Duration(seconds: 3));
  print('Task 1 completed.');
}

Future<void> task2() async {
  // Replace this with your actual async function logic for task2
  print('Task 2 is running...');
  await Future.delayed(Duration(seconds: 5));
  print('Task 2 completed.');
}

// A task that checks if a number is prime:
bool isPrime(int n) {
  if (n < 2) return false;

  var limit = n ~/ 2;
  for (var p = 2; p <= limit; ++p) {
    if (n % p == 0) return false;
  }

  return true;
}
