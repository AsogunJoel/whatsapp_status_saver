enum Status {
  LOADING,
  COMPLETED,
  ERROR,
}

class DirectoryResponse<T> {
  Status status;

  T? data;

  late String message;

  DirectoryResponse.loading(this.message) : status = Status.LOADING;

  DirectoryResponse.completed(this.data) : status = Status.COMPLETED;

  DirectoryResponse.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}
