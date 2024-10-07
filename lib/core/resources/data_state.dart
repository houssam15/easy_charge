import "package:dio/dio.dart";

abstract class DataState<T,E>{
  final T ? data;
  final E ? error;

  const DataState({this.data,this.error});
}

class DataSuccess<T,E> extends DataState<T,E> {
  const DataSuccess(T data):super(data:data);
}

class DataFailed<T,E> extends DataState<T,E>{
  const DataFailed(E? error):super(error: error);
}