class Worker {
  final Future<void> Function() _asyncFunction;
  final Function(double) _onProgress;
  final Function(Duration) _onRemainingTime;

  Worker(this._asyncFunction, this._onProgress, this._onRemainingTime);

  Future<void> run() async {
    try {
      await _asyncFunction();
    } catch (error) {
      // If an error occurs, propagate it back to the main isolate
      throw 'Error: $error';
    }
  }

  void reportProgress(double progress) {
    _onProgress(progress);
  }

  void reportRemainingTime(Duration remainingTime) {
    _onRemainingTime(remainingTime);
  }
}
