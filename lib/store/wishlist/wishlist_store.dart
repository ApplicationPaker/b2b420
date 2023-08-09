import 'package:cirilla/service/helpers/persist_helper.dart';
import 'package:mobx/mobx.dart';

part 'wishlist_store.g.dart';

class WishListStore = WishListStoreBase with _$WishListStore;

abstract class WishListStoreBase with Store {
  final PersistHelper _persistHelper;

  @observable
  ObservableList<String> _data = ObservableList<String>.of([]);

  @computed
  ObservableList<String> get data => _data;

  @computed
  int get count => _data.length;

  // Action: -----------------------------------------------------------------------------------------------------------
  @action
  void addWishList(String value, {int? position}) {
    int index = _data.indexOf(value);
    if (index == -1) {
      position != null ? data.insert(position, value) : _data.add(value);
    } else {
      _data.removeAt(index);
    }
  }

  // Constructor: ------------------------------------------------------------------------------------------------------
  WishListStoreBase(this._persistHelper) {
    _init();
    _reaction();
  }

  Future _init() async {
    _read();
  }

  void _read() {
    List<String>? data = _persistHelper.getWishList();
    if (data != null && data.isNotEmpty) {
      _data = ObservableList<String>.of(data);
    }
  }

  void _write() async {
    await _persistHelper.saveWishList(_data);
  }

  // disposers:---------------------------------------------------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _reaction() {
    _disposers = [
      reaction((_) => _data.length, (_) => _write()),
    ];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
