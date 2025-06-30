sealed class ApiResult<T> {
  const ApiResult();
}

class Success<T> extends ApiResult<T> {
  final T data;
  const Success(this.data);
}

class Loading<T> extends ApiResult<T> {
  const Loading();
}

class Failure<T> extends ApiResult<T> {
  final String message;
  const Failure(this.message);
}

//  Add this extension safely
extension ApiResultWhenExtension<T> on ApiResult<T> {
  R when<R>({
    required R Function(T data) success,
    R Function()? loading,
    required R Function(String message) failure,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    }
    else if (this is Loading<T>) {
      return loading!();
    }
    else if (this is Failure<T>) {
      return failure((this as Failure<T>).message);
    } else {
      throw Exception('Unhandled ApiResult type: $runtimeType');
    }
  }
}
