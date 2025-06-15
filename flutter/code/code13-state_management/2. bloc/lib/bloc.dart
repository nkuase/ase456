import 'dart:async';
import 'event.dart';

class CounterBloc {
  int _counter = 0;

  final _counterStateController = StreamController<int>();
  get _stateSink => _counterStateController.sink;
  // For state, exposing only a stream which outputs data
  get stateStream => _counterStateController.stream;

  final _counterEventController = StreamController<CounterEvent>();
  // For events, exposing only a sink which is an input
  get counterEventSink => _counterEventController.sink;
  get _counterEventStream => _counterEventController.stream;

  CounterBloc() {
    // Whenever there is a new event, we want to map it to a new state
    _counterEventStream.listen(_mapEventToState);
  }

  void _mapEventToState(CounterEvent event) {
    if (event is IncrementEvent) {
      _counter++;
    }
    _stateSink.add(_counter);
  }

  void dispose() {
    _counterStateController.close();
    _counterEventController.close();
  }
}
