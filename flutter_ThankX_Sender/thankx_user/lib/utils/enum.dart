typedef LogoutCallBack = void  Function();


enum NotificaionType {
  notification1,
  notification2,
  notification3,
  notification4
}

enum MediaFor {
  profile,
}


typedef TapActionCallback = void Function();
typedef ButtonClickActionCallback = void Function();
typedef DropdownValueSelectionCallback = void Function(String value);

typedef OnChangeCallback = void Function(String value);