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
  void initState() {
    context.read<ShopBloc>().add(GetPlayerCountEvent(idShop: widget.idShop));
    context
        .read<ShopBloc>()
        .add(GetTotalReservationsEvent(idShop: widget.idShop));
    context
        .read<ShopBloc>()
        .add(GetPeakReservationHoursEvent(idShop: widget.idShop));
    context
        .read<ShopBloc>()
        .add(GetMostPlayedGamesEvent(idShop: widget.idShop));
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
  Widget build(BuildContext context) {
    monthNames =
        getMonthNames(Localizations.localeOf(context).languageCode) ?? [];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildChartSelector(),
          const SizedBox(height: 10),
          Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          const SizedBox(height: 10),
          _buildPeriodSelector(),
          const SizedBox(height: 10),
          Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          BlocBuilder<ShopBloc, ShopState>(
            builder: (context, state) {
              switch (_selectedChart) {
                case 1:
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
                    hasData: (state) => state.mostPlayedGames != null,
                    context: context,
                    contentBuilder: (state) {
                      return _buildPopularGamesChart(state.mostPlayedGames!);
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

  Widget _buildChartSelector() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            {'label': AppLocalizations.of(context)!.total_reservations, 'value': 1},
            {'label': AppLocalizations.of(context)!.active_players, 'value': 2},
            {'label': AppLocalizations.of(context)!.peak_hours, 'value': 3},
            {'label': AppLocalizations.of(context)!.popular_games, 'value': 4}
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

  Widget _buildReservationsChart(Map<String, dynamic> data) {
    Map<String, int> dataChosen = data[_selectedPeriod];

    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SfCartesianChart(
          tooltipBehavior: _tooltipBehavior,
          title: ChartTitle(text: AppLocalizations.of(context)!.total_reservations_by_period(_selectedPeriod)),
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

  Widget _buildPlayersChart(Map<String, dynamic> data) {
    Map<String, int> dataChosen = data[_selectedPeriod];
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SfCartesianChart(
          tooltipBehavior: _tooltipBehavior,
          title: ChartTitle(text: AppLocalizations.of(context)!.active_players_by_period(_selectedPeriod)),
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

  Widget _buildPeakHoursChart(Map<String, dynamic> data) {
    final sortedData = data[_selectedPeriod]
      ..sort((a, b) => (a['hour'] as int).compareTo(b['hour'] as int));

    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SfCartesianChart(
          tooltipBehavior: _tooltipBehavior,
          title:  ChartTitle(text: AppLocalizations.of(context)!.peak_reservation_hours),
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

  Widget _buildPopularGamesChart(Map<String, dynamic> data) {
    List<Map<String, dynamic>> choseData = data[_selectedPeriod];
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: SfCircularChart(
          tooltipBehavior: _tooltipBehavior,
          title: ChartTitle(text: AppLocalizations.of(context)!.most_popular_games),
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
