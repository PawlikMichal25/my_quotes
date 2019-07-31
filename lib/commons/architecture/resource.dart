enum Status { LOADING, SUCCESS, ERROR }

class Resource<T> {
  final Status status;
  final T data;
  final String message;

  Resource._(this.status, [this.data, this.message]);

  factory Resource.loading() {
    return Resource<T>._(Status.LOADING);
  }

  factory Resource.success({T data}) {
    return Resource<T>._(Status.SUCCESS, data, null);
  }

  factory Resource.error({String message}) {
    return Resource<T>._(Status.ERROR, null, message);
  }

  factory Resource.from(Status status, {T data, String message}) {
    return Resource<T>._(status, data, message);
  }

  bool get isSuccessful => status == Status.SUCCESS;

  bool get isLoading => status == Status.LOADING;

  @override
  String toString() {
    return 'Resource{status: $status, data: $data, message: $message}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Resource &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          data == other.data &&
          message == other.message;

  @override
  int get hashCode => status.hashCode ^ data.hashCode ^ message.hashCode;
}
