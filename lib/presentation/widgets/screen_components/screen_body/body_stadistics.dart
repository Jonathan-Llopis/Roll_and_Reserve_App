import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_event.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_state.dart';
import 'package:roll_and_reserve/presentation/functions/constants.dart';
import 'package:roll_and_reserve/presentation/functions/functions_utils.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BodyStadistics extends StatefulWidget {
  final int idShop;

  const BodyStadistics({
    required this.idShop,
    super.key,
  });

  @override
  State<BodyStadistics> createState() => _BodyStadisticsState();
}

class _BodyStadisticsState extends State<BodyStadistics> {
  late TooltipBehavior _tooltipBehavior;
  late List<String> monthNames;

  @override
  /// Called when the widget is inserted into the tree.
  ///
  /// This method is responsible for requesting the most played games,
  /// the player count, the total reservations, and the peak reservation
  /// hours of the shop with the given idShop from the database.
  ///
  /// It also initializes the tooltip behavior to be used in the charts.
  /// The tooltip is enabled and will show the point.x and point.y values,
  /// and will show the marker.
  ///
  void initState() {
    context
        .read<ShopBloc>()
        .add(GetMostPlayedGamesEvent(idShop: widget.idShop));
    context.read<ShopBloc>().add(GetPlayerCountEvent(idShop: widget.idShop));
    context
        .read<ShopBloc>()
        .add(GetTotalReservationsEvent(idShop: widget.idShop));
    context
        .read<ShopBloc>()
        .add(GetPeakReservationHoursEvent(idShop: widget.idShop));
    _tooltipBehavior = _tooltipBehavior = TooltipBehavior(
      enable: true,
      format: 'point.x :  point.y',
      header: '',
      canShowMarker: true,
      textAlignment: ChartAlignment.center,
    );

    super.initState();
  }

  String _selectedPeriod = 'Month';
  int _selectedChart = 1;

  @override
  /// Builds the body of the statistics screen.
  ///
  /// This screen is a [SingleChildScrollView] with a [Column] of children.
  /// The children are the following:
  ///
  /// 1. A chart selector, which is a [Row] of [Radio] buttons that allows the
  /// user to select which chart to show.
  /// 2. A divider, which is a [Padding] with a [Divider].
  /// 3. A period selector, which is a [Row] of [Radio] buttons that allows the
  /// user to select which period to show.
  /// 4. A divider, which is a [Padding] with a [Divider].
  /// 5. A [BlocBuilder] that shows the selected chart, based on the selected
  /// period and chart.
  ///
  /// The [BlocBuilder] is given the [ShopBloc] and the [ShopState]. It shows
  /// a [SfCartesianChart] with the data of the selected chart, based on the
  /// selected period and chart.
  ///
  /// The chart is given the [TooltipBehavior] that is initialized in the
  /// [initState] method. It also shows the point.x and point.y values, and will
  /// show the marker.
  ///
  Widget build(BuildContext context) {
    monthNames =
        getMonthNames(Localizations.localeOf(context).languageCode) ?? [];
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          _buildChartSelector(),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          const SizedBox(height: 10),
          _buildPeriodSelector(),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          BlocBuilder<ShopBloc, ShopState>(
            builder: (context, state) {
              switch (_selectedChart) {
                case 1:
                  return buildContent<ShopState>(
                    state: state,
                    isLoading: (state) => state.isLoading,
                    errorMessage: (state) => state.errorMessage,
                    hasData: (state) => state.mostPlayedGames != null,
                    context: context,
                    contentBuilder: (state) {
                      return _buildPopularGamesChart(state.mostPlayedGames!);
                    },
                  );
                case 2:
                  return buildContent<ShopState>(
                    state: state,
                    isLoading: (state) => state.isLoading,
                    errorMessage: (state) => state.errorMessage,
                    hasData: (state) => state.playerCount != null,
                    context: context,
                    contentBuilder: (state) {
                      return _buildPlayersChart(state.playerCount!);
                    },
                  );
                case 3:
                  return buildContent<ShopState>(
                    state: state,
                    isLoading: (state) => state.isLoading,
                    errorMessage: (state) => state.errorMessage,
                    hasData: (state) => state.peakReservationHours != null,
                    context: context,
                    contentBuilder: (state) {
                      return _buildPeakHoursChart(state.peakReservationHours!);
                    },
                  );
                case 4:
                  return buildContent<ShopState>(
                    state: state,
                    isLoading: (state) => state.isLoading,
                    errorMessage: (state) => state.errorMessage,
                    hasData: (state) => state.totalReservations != null,
                    context: context,
                    contentBuilder: (state) {
                      return _buildReservationsChart(state.totalReservations!);
                    },
                  );

                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }

  /// Builds a row of [ChoiceChip] to select the period of the statistics.
  ///
  /// The periods are: month, quarter, and year.
  ///
  /// The currently selected period is stored in [_selectedPeriod].
  ///
  /// When a period is selected, the state of the widget is updated with
  /// the selected period.
  Widget _buildPeriodSelector() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            {'label': AppLocalizations.of(context)!.month, 'value': 'Month'},
            {
              'label': AppLocalizations.of(context)!.quarter,
              'value': 'Quarter'
            },
            {'label': AppLocalizations.of(context)!.annual, 'value': 'Year'}
          ].map<Widget>((Map<String, String> period) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ChoiceChip(
                label: Text(period['label']!),
                selected: _selectedPeriod == period['value'],
                onSelected: (bool selected) {
                  setState(() {
                    _selectedPeriod = period['value']!;
                  });
                },
              ),
            );
          }).toList(),
        ),
      );

  /// Builds a row of [ChoiceChip] to select the chart to display.
  ///
  /// The charts are: popular games, active players, peak hours, and total
  /// reservations.
  ///
  /// The currently selected chart is stored in [_selectedChart].
  ///
  /// When a chart is selected, the state of the widget is updated with the
  /// selected chart.
  Widget _buildChartSelector() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            {'label': AppLocalizations.of(context)!.popular_games, 'value': 1},
            {'label': AppLocalizations.of(context)!.active_players, 'value': 2},
            {'label': AppLocalizations.of(context)!.peak_hours, 'value': 3},
            {
              'label': AppLocalizations.of(context)!.total_reservations,
              'value': 4
            }
          ].map((Map<String, dynamic> chart) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ChoiceChip(
                label: Text(chart['label']),
                selected: _selectedChart == chart['value'],
                onSelected: (bool selected) {
                  setState(() {
                    _selectedChart = chart['value'];
                  });
                },
              ),
            );
          }).toList(),
        ),
      );

  /// Builds a chart with the total reservations by period.
  ///
  /// The chart is a line chart with the x-axis showing the period and the
  /// y-axis showing the number of reservations.
  ///
  /// The chart is colored with the primary color of the app.
  ///
  /// The chart is given the selected period in [_selectedPeriod].
  /// The chart is given the data in [data].
  Widget _buildReservationsChart(Map<String, dynamic> data) {
    Map<String, int> dataChosen = data[_selectedPeriod];

    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SfCartesianChart(
          tooltipBehavior: _tooltipBehavior,
          title: ChartTitle(
              text: AppLocalizations.of(context)!
                  .total_reservations_by_period(_selectedPeriod)),
          primaryXAxis: CategoryAxis(
            labelRotation: 45,
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            labelStyle: TextStyle(fontSize: 10),
            labelAlignment: LabelAlignment.start,
          ),
          series: <CartesianSeries>[
            LineSeries<MapEntry<String, int>, String>(
              dataSource: dataChosen.entries.toList(),
              xValueMapper: (MapEntry<String, int> entry, _) =>
                  _selectedPeriod == 'Year'
                      ? monthNames[int.parse(entry.key)]
                      : _selectedPeriod == 'Quarter'
                          ? convertMonthRangeToText(entry.key, monthNames)
                          : monthStadistics(entry.key, monthNames),
              yValueMapper: (MapEntry<String, int> entry, _) => entry.value,
              markerSettings: MarkerSettings(
                shape: DataMarkerType.circle,
                borderWidth: 1,
                borderColor: Colors.blueAccent,
                isVisible: true,
              ),
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }

  /// Builds a line chart with the total number of active players by period.
  ///
  /// The chart is a [SfCartesianChart] with a [CategoryAxis] as the
  /// primaryXAxis. The xValueMapper is given a [MapEntry] with the key
  /// being the month or quarter as a string, and the value being the
  /// number of active players. The yValueMapper is given the same
  /// [MapEntry] and returns the value.
  ///
  /// The title of the chart is given the localized string
  /// "Active players by period" with the current period as the parameter.
  ///
  /// The chart is given a tooltip behavior and a title. The series is
  /// given a [ColumnSeries] with the data source as the entries of the
  /// chosen data. The color of the series is green.
  ///
  /// Returns a [SizedBox] with the given height and a [Padding] with the
  /// given padding, and a child of the [SfCartesianChart].
  Widget _buildPlayersChart(Map<String, dynamic> data) {
    Map<String, int> dataChosen = data[_selectedPeriod];
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SfCartesianChart(
          tooltipBehavior: _tooltipBehavior,
          title: ChartTitle(
              text: AppLocalizations.of(context)!
                  .active_players_by_period(_selectedPeriod)),
          primaryXAxis: CategoryAxis(
            labelRotation: 45,
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            labelStyle: TextStyle(fontSize: 10),
            labelAlignment: LabelAlignment.start,
          ),
          series: <CartesianSeries>[
            ColumnSeries<MapEntry<String, int>, String>(
              dataSource: dataChosen.entries.toList(),
              xValueMapper: (MapEntry<String, int> entry, _) =>
                  _selectedPeriod == 'Year'
                      ? monthNames[int.parse(entry.key)]
                      : _selectedPeriod == 'Quarter'
                          ? convertMonthRangeToText(entry.key, monthNames)
                          : monthStadistics(entry.key, monthNames),
              yValueMapper: (MapEntry<String, int> entry, _) => entry.value,
              color: Colors.green,
            )
          ],
        ),
      ),
    );
  }

  /// Builds a line chart displaying the peak reservation hours.
  ///
  /// The chart is a [SfCartesianChart] with a [CategoryAxis] as the
  /// primaryXAxis. It visualizes the number of reservations for each hour
  /// of the day. The x-axis represents the hours, ranging from 8 AM to 11 PM,
  /// formatted as "HH:00". The y-axis represents the count of reservations.
  ///
  /// The data is sorted by hour to ensure the chart displays the hours in
  /// chronological order. If there is no data for a specific hour, it is
  /// represented with a null value, and such points are dropped.
  ///
  /// The chart includes a tooltip behavior for data points and is styled
  /// with orange color for the line series. The title of the chart is a
  /// localized string indicating "Peak Reservation Hours".

  Widget _buildPeakHoursChart(Map<String, dynamic> data) {
    final sortedData = data[_selectedPeriod]
      ..sort((a, b) => (a['hour'] as int).compareTo(b['hour'] as int));

    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SfCartesianChart(
          tooltipBehavior: _tooltipBehavior,
          title: ChartTitle(
              text: AppLocalizations.of(context)!.peak_reservation_hours),
          primaryXAxis: CategoryAxis(
            labelRotation: 45,
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            labelStyle: TextStyle(fontSize: 10),
            labelAlignment: LabelAlignment.center,
          ),
          series: <CartesianSeries>[
            LineSeries<Map<String, dynamic>, String>(
              dataSource: List.generate(16, (index) {
                final hour = index + 8;
                final entry = sortedData.firstWhere(
                  (e) => e['hour'] == hour,
                  orElse: () => {'hour': hour, 'reservation_count': null},
                );
                return entry;
              }),
              xValueMapper: (entry, _) => "${entry['hour']}:00",
              yValueMapper: (entry, _) => entry['reservation_count'] as int?,
              markerSettings: const MarkerSettings(isVisible: true),
              color: Colors.orange,
              emptyPointSettings: EmptyPointSettings(
                mode: EmptyPointMode.drop,
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Builds a pie chart displaying the most popular games.
  ///
  /// The chart is a [SfCircularChart] with the title set to the localized
  /// string for "Most Popular Games". It uses a [PieSeries] to visualize
  /// the games and their play counts. Each slice of the pie represents
  /// a game, with the size of the slice corresponding to the number of
  /// times the game was played.
  ///
  /// The legend is visible and positioned at the bottom, showing the names
  /// of the games. The chart also has a tooltip behavior for displaying
  /// additional information when hovering over the slices.
  ///
  /// The data for the chart is selected based on the current period
  /// defined by [_selectedPeriod], and is expected to be a list of maps
  /// with keys 'name' and 'play_count'.

  Widget _buildPopularGamesChart(Map<String, dynamic> data) {
    List<Map<String, dynamic>> choseData = data[_selectedPeriod];
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: SfCircularChart(
          tooltipBehavior: _tooltipBehavior,
          title: ChartTitle(
              text: AppLocalizations.of(context)!.most_popular_games),
          series: <CircularSeries>[
            PieSeries<Map<String, dynamic>, String>(
              dataSource: choseData,
              xValueMapper: (Map<String, dynamic> entry, _) => entry['name'],
              yValueMapper: (Map<String, dynamic> entry, _) =>
                  entry['play_count'],
            )
          ],
          legend: Legend(
            isVisible: true,
            title: LegendTitle(text: AppLocalizations.of(context)!.games),
            overflowMode: LegendItemOverflowMode.wrap,
            position: LegendPosition.bottom,
          ),
        ),
      ),
    );
  }
}
