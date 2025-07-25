abstract class Cache<T> {
  final T _obj;
  Cache(this._obj);
  T get value => _obj;
  void handle();
}

class LocalCache<T> extends Cache<T> {
  LocalCache(T obj) : super(obj);
  @override
  void handle() {print('My value is ${value} and runtype is ${_obj.runtimeType}');} 
}

void main() {
  final local1 = LocalCache<int>(1);
  local1.handle();
  final local2 = LocalCache<double>(2.5);
  local2.handle();
}