enum LanguageEnum {
  ENGLISH,
  PERSIAN,
}

enum RequestMethodEnum {
  GET,
  POST,
  DELETE,
  PUT,
  PATH;

  String name() {
    switch (this) {
      case RequestMethodEnum.GET:
        return 'GET';
      case RequestMethodEnum.POST:
        return 'POST';
      case RequestMethodEnum.DELETE:
        return 'DELETE';
      case RequestMethodEnum.PATH:
        return 'PATH';
      case RequestMethodEnum.PUT:
        return 'PUT';
    }
  }
}

enum StateAuthLoginEnum {
  GET_INDEX,
  CHECK_EQUALS_FALSE,
  REPETITIOUS,
  NOT_REPETITIOUS,
  NOT_REPETITIOUS_FAILURE,
  EXCEPTION,
  SHOW_MODAL,
}

enum ChatStateEnum {
  PENDING,
  SEND,
  SUCCESS,
  FAILURE,
}
