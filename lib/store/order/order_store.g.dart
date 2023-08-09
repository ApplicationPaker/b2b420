// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$OrderStore on OrderStoreBase, Store {
  Computed<bool>? _$canLoadMoreComputed;

  @override
  bool get canLoadMore =>
      (_$canLoadMoreComputed ??= Computed<bool>(() => super.canLoadMore, name: '_OrderStore.canLoadMore')).value;
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading, name: '_OrderStore.loading')).value;
  Computed<ObservableList<OrderData>>? _$ordersComputed;

  @override
  ObservableList<OrderData> get orders =>
      (_$ordersComputed ??= Computed<ObservableList<OrderData>>(() => super.orders, name: '_OrderStore.orders')).value;

  final _$fetchOrdersFutureAtom = Atom(name: '_OrderStore.fetchOrdersFuture');

  @override
  ObservableFuture<List<OrderData>?> get fetchOrdersFuture {
    _$fetchOrdersFutureAtom.reportRead();
    return super.fetchOrdersFuture;
  }

  @override
  set fetchOrdersFuture(ObservableFuture<List<OrderData>?> value) {
    _$fetchOrdersFutureAtom.reportWrite(value, super.fetchOrdersFuture, () {
      super.fetchOrdersFuture = value;
    });
  }

  final _$_ordersAtom = Atom(name: '_OrderStore._orders');

  @override
  ObservableList<OrderData> get _orders {
    _$_ordersAtom.reportRead();
    return super._orders;
  }

  @override
  set _orders(ObservableList<OrderData> value) {
    _$_ordersAtom.reportWrite(value, super._orders, () {
      super._orders = value;
    });
  }

  final _$_nextPageAtom = Atom(name: '_OrderStore._nextPage');

  @override
  int get _nextPage {
    _$_nextPageAtom.reportRead();
    return super._nextPage;
  }

  @override
  set _nextPage(int value) {
    _$_nextPageAtom.reportWrite(value, super._nextPage, () {
      super._nextPage = value;
    });
  }

  final _$perPageAtom = Atom(name: '_OrderStore.perPage');

  @override
  int get perPage {
    _$perPageAtom.reportRead();
    return super.perPage;
  }

  @override
  set perPage(int value) {
    _$perPageAtom.reportWrite(value, super.perPage, () {
      super.perPage = value;
    });
  }

  final _$_customerAtom = Atom(name: '_OrderStore._customer');

  @override
  int? get _customer {
    _$_customerAtom.reportRead();
    return super._customer;
  }

  @override
  set _customer(int? value) {
    _$_customerAtom.reportWrite(value, super._customer, () {
      super._customer = value;
    });
  }

  final _$_canLoadMoreAtom = Atom(name: '_OrderStore._canLoadMore');

  @override
  bool get _canLoadMore {
    _$_canLoadMoreAtom.reportRead();
    return super._canLoadMore;
  }

  @override
  set _canLoadMore(bool value) {
    _$_canLoadMoreAtom.reportWrite(value, super._canLoadMore, () {
      super._canLoadMore = value;
    });
  }

  final _$searchAtom = Atom(name: '_OrderStore.search');

  @override
  String get search {
    _$searchAtom.reportRead();
    return super.search;
  }

  @override
  set search(String value) {
    _$searchAtom.reportWrite(value, super.search, () {
      super.search = value;
    });
  }

  final _$getOrdersAsyncAction = AsyncAction('_OrderStore.getOrders');

  @override
  Future<void> getOrders() {
    return _$getOrdersAsyncAction.run(() => super.getOrders());
  }

  final _$_OrderStoreActionController = ActionController(name: '_OrderStore');

  @override
  Future<void> refresh() {
    final $actionInfo = _$_OrderStoreActionController.startAction(name: '_OrderStore.refresh');
    try {
      return super.refresh();
    } finally {
      _$_OrderStoreActionController.endAction($actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchOrdersFuture: ${fetchOrdersFuture},
perPage: ${perPage},
search: ${search},
canLoadMore: ${canLoadMore},
loading: ${loading},
orders: ${orders}
    ''';
  }
}
