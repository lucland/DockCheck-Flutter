import 'package:dockcheck/models/event.dart';
import 'package:dockcheck/utils/enums/action_enum.dart';
import 'package:dockcheck/utils/formatter.dart';
import 'package:dockcheck/utils/theme.dart';
import 'package:dockcheck/utils/ui/colors.dart';
import 'package:flutter/material.dart';

class YourWidget extends StatefulWidget {
  final List<Event> eventos;

  YourWidget({required this.eventos});

  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  static const int maxEventsToShow = 10000;

  Map<String, bool> eventsVisibility = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildEventContainers(context, widget.eventos),
    );
  }

  List<Widget> _buildEventContainers(
      BuildContext context, List<Event> eventos) {
    Map<String, List<Event>> eventsByDate = {};

    for (Event evento in eventos) {
      String formattedDate = Formatter.formatDateTime(
        evento.timestamp,
      );
      eventsByDate.putIfAbsent(formattedDate, () => []);
      eventsByDate[formattedDate]!.add(evento);
      eventsVisibility.putIfAbsent(formattedDate, () => false); //inicial
    }

    List<Widget> containers = [];
    eventsByDate.forEach((date, events) {
      containers.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  eventsVisibility[date] = !eventsVisibility[date]!;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(width: 1, color: CQColors.iron100),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Text(
                      date,
                      style: CQTheme.h3,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (eventsVisibility[date]!)
              Column(
                children: events.take(maxEventsToShow).map((event) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        actionEnumToString(event.action),
                        style: CQTheme.body.copyWith(
                          color: CQColors.iron100,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              event.portalId,
                              style: CQTheme.body.copyWith(
                                color: CQColors.iron100,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            ' -',
                            style: CQTheme.body2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              Formatter.fromatHourDateTime(
                                event.timestamp.subtract(Duration(hours: 3)),
                              ),
                              style: CQTheme.body.copyWith(
                                color: CQColors.iron100,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              event.id,
                              style: CQTheme.body.copyWith(
                                color: CQColors.iron100,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                }).toList(),
              ),
            if (events.length > maxEventsToShow)
              GestureDetector(
                onTap: () {
                  setState(() {
                    eventsVisibility[date] = true;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(width: 1, color: CQColors.iron100),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Text(
                        'Clique aqui para visualizar todos os eventos',
                        style: CQTheme.body.copyWith(
                          color: CQColors.iron100,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });

    return containers;
  }
}
