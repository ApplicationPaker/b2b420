import 'package:cirilla/models/order/order.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/utils/query.dart';
import 'package:mobx/mobx.dart';

part 'order_store.g.dart';

class OrderStore = OrderStoreBase with _$OrderStore;

abstract class OrderStoreBase with Store {
  late RequestHelper _requestHelper;

  // Constructor: ------------------------------------------------------------------------------------------------------

  OrderStoreBase(RequestHelper requestHelper, {int? customer}) {
    _requestHelper = requestHelper;

    if (customer != null) _customer = customer;

    _reaction();
  }

  // store variables:-----------------------------------------------------------

  static ObservableFuture<List<OrderData>> emptyOrderResponse = ObservableFuture.value([]);

  @observable
  ObservableFuture<List<OrderData>?> fetchOrdersFuture = emptyOrderResponse;

  @observable
  ObservableList<OrderData> _orders = ObservableList<OrderData>.of([]);

  @observable
  int _nextPage = 1;

  @observable
  int perPage = 10;

  @observable
  int? _customer;

  @observable
  bool _canLoadMore = true;

  @computed
  bool get canLoadMore => _canLoadMore;

  @computed
  bool get loading => fetchOrdersFuture.status == FutureStatus.pending;

  @computed
  ObservableList<OrderData> get orders => _orders;

  @observable
  String search = '';

  @action
  Future<void> getOrders() async {
    Map<String, dynamic> qs = {
      "customer": _customer,
      "page": _nextPage,
      "per_page": perPage,
      "search": search,
    };

    final future = _requestHelper.getOrders(
      queryParameters: preQueryParameters(qs),
    );

    fetchOrdersFuture = ObservableFuture(future);

    return future.then((orders) {
      // Replace state in the first time or refresh

      if (_nextPage <= 1) {
        _orders = ObservableList<OrderData>.of(orders!);
      } else {
        // Add posts when load more page

        _orders.addAll(ObservableList<OrderData>.of(orders!));
      }

      // Check if can load more item

      if (orders.length >= perPage) {
        _nextPage++;
      } else {
        _canLoadMore = false;
      }
    }).catchError((error) {
      throw error;
    });
  }

  @action
  Future<void> refresh() {
    _canLoadMore = true;

    _nextPage = 1;

    return getOrders();
  }

  late List<ReactionDisposer> _disposers;

  void _reaction() {
    _disposers = [];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
