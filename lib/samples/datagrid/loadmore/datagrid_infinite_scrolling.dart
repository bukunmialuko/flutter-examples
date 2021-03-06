/// Dart import
import 'dart:math';

/// Package import
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// DataGrid import
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../../model/sample_view.dart';

class LoadMoreInfiniteScrollingDataGrid extends SampleView {
  LoadMoreInfiniteScrollingDataGrid({Key key}) : super(key: key);

  @override
  _LoadMoreInfiniteScrollingDataGridState createState() =>
      _LoadMoreInfiniteScrollingDataGridState();
}

class _LoadMoreInfiniteScrollingDataGridState extends SampleViewState {
  List<Employee> _employeeData = <Employee>[];
  EmployeeDataSource _employeeDataSource;

  @override
  void initState() {
    _populateData();
    _employeeDataSource = EmployeeDataSource(employeeData: _employeeData);
    super.initState();
  }

  Widget _buildProgressIndicator() {
    final isLight = model.themeData.brightness == Brightness.light;
    return Container(
        height: 60.0,
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
            color: isLight ? Color(0xFFFFFFFF) : Color(0xFF212121),
            border: BorderDirectional(
                top: BorderSide(
                    width: 1.0,
                    color: isLight
                        ? Color.fromRGBO(0, 0, 0, 0.26)
                        : Color.fromRGBO(255, 255, 255, 0.26)))),
        child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: Container(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(model.backgroundColor),
              backgroundColor: Colors.transparent,
            ))));
  }

  Widget _buildLoadMoreView(BuildContext context, LoadMoreRows loadMoreRows) {
    Future<String> loadRows() async {
      // Call the loadMoreRows function to call the
      // DataGridSource.handleLoadMoreRows method. So, additional
      // rows can be added from handleLoadMoreRows method.
      await loadMoreRows();
      return Future<String>.value('Completed');
    }

    return FutureBuilder<String>(
      initialData: 'Loading',
      future: loadRows(),
      builder: (context, snapShot) {
        return snapShot.data == 'Loading'
            ? _buildProgressIndicator()
            : SizedBox.fromSize(size: Size.zero);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
        source: _employeeDataSource,
        loadMoreViewBuilder: _buildLoadMoreView,
        columns: _getColumns());
  }

  void _populateData() {
    _employeeData.clear();
    _employeeData = _generateList(_employeeData, 25);
  }
}

List<GridColumn> _getColumns() {
  return <GridColumn>[
    GridNumericColumn(
        mappingName: 'id',
        columnWidthMode:
            !kIsWeb ? ColumnWidthMode.header : ColumnWidthMode.fill,
        headerText: 'Order ID'),
    GridNumericColumn(
        mappingName: 'customerId',
        columnWidthMode:
            !kIsWeb ? ColumnWidthMode.header : ColumnWidthMode.fill,
        headerText: 'Customer ID'),
    GridTextColumn(mappingName: 'name', headerText: 'Name'),
    GridNumericColumn(
        mappingName: 'freight',
        numberFormat: NumberFormat.currency(locale: 'en_US', symbol: '\$'),
        headerText: 'Freight'),
    GridTextColumn(
        mappingName: 'city',
        columnWidthMode: !kIsWeb ? ColumnWidthMode.auto : ColumnWidthMode.fill,
        headerText: 'City'),
    GridNumericColumn(
        mappingName: 'price',
        numberFormat: NumberFormat.currency(
            locale: 'en_US', symbol: '\$', decimalDigits: 0),
        columnWidthMode: ColumnWidthMode.lastColumnFill,
        headerText: 'Price')
  ];
}

List<Employee> _generateList(List<Employee> employeeData, int count) {
  final Random _random = Random();
  int startIndex = employeeData.isNotEmpty ? employeeData.length : 0,
      endIndex = startIndex + count;
  for (int i = startIndex; i < endIndex; i++) {
    employeeData.add(Employee(
      1000 + i,
      1700 + i,
      _names[i < _names.length ? i : _random.nextInt(_names.length - 1)],
      _random.nextInt(1000) + _random.nextDouble(),
      _citys[_random.nextInt(_citys.length - 1)],
      1500.0 + _random.nextInt(100),
    ));
  }
  return employeeData;
}

final List<String> _names = <String>[
  'Welli',
  'Blonp',
  'Folko',
  'Furip',
  'Folig',
  'Picco',
  'Frans',
  'Warth',
  'Linod',
  'Simop',
  'Merep',
  'Riscu',
  'Seves',
  'Vaffe',
  'Alfki',
];

final List<String> _citys = <String>[
  'Bruxelles',
  'Rosario',
  'Recife',
  'Graz',
  'Montreal',
  'Tsawassen',
  'Campinas',
  'Resende',
];

class Employee {
  Employee(
      this.id, this.customerId, this.name, this.freight, this.city, this.price);
  final int id;
  final int customerId;
  final String name;
  final String city;
  final double freight;
  final double price;
}

class EmployeeDataSource extends DataGridSource<Employee> {
  EmployeeDataSource({List<Employee> employeeData}) {
    _employeeData = employeeData;
  }

  List<Employee> _employeeData;

  @override
  List<Employee> get dataSource => _employeeData;
  @override
  Object getValue(Employee employee, String columnName) {
    switch (columnName) {
      case 'id':
        return employee.id;
        break;
      case 'name':
        return employee.name;
        break;
      case 'customerId':
        return employee.customerId;
        break;
      case 'freight':
        return employee.freight;
        break;
      case 'price':
        return employee.price;
        break;
      case 'city':
        return employee.city;
        break;
      default:
        return 'empty';
        break;
    }
  }

  @override
  Future<void> handleLoadMoreRows() async {
    await Future.delayed(Duration(seconds: 5));
    _employeeData = _generateList(dataSource, 15);
    notifyListeners();
  }
}
