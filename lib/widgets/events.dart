import 'dart:io';
import 'package:dockcheck/models/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:dockcheck/models/event.dart';
import 'package:dockcheck/utils/enums/action_enum.dart';
import 'package:dockcheck/utils/formatter.dart';
import 'package:dockcheck/utils/theme.dart';
import 'package:dockcheck/utils/ui/colors.dart';
import 'package:flutter/material.dart';

class YourWidget extends StatefulWidget {
  final List<Event> eventos;
  final User user;

  YourWidget({
    required this.eventos,
    required this.user,
  });

  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  static const int maxEventsToShow = 10000;

  Map<String, bool> eventsVisibility = {};
  bool showAllEvents = false;

  Future<void> _generatePdf(List<Event> events, User user) async {
    final pdfLib.Document pdf = pdfLib.Document();

    pdf.addPage(
      pdfLib.Page(
        build: (pdfLib.Context context) {
          List<pdfLib.Widget> pdfWidgets = [
            pdfLib.Text(
              "${user.number.toString()} - ${user.name}",
              style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
            ),
            pdfLib.SizedBox(height: 20),
          ];

          pdfWidgets.addAll(events.map((event) {
            return pdfLib.Column(
              crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
              children: [
                pdfLib.Text(
                  "${actionEnumToString(event.action)} - ${event.portalId} - ${Formatter.fromatHourDateTime(event.timestamp.subtract(Duration(hours: 3)))}",
                ),
                pdfLib.SizedBox(height: 20),
              ],
            );
          }));

          return pdfLib.Column(
            crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
            children: pdfWidgets,
          );
        },
      ),
    );

    final directory = await _getUserDirectory(user);
    final fileName = 'relatório - ${_formatDate(events.first.timestamp)}.pdf';
    final file = File('${directory.path}/$fileName');

    await file.writeAsBytes(await pdf.save());
    print('PDF salvo em: ${file.path}');
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}-${_getMonthInitials(dateTime.month)}-${dateTime.year}';
  }

  String _getMonthInitials(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  Future<Directory> _getUserDirectory(User user) async {
    final directory = await getExternalStorageDirectory();
    final userDirectory = Directory('${directory!.path}/${user.name}');

    if (!userDirectory.existsSync()) {
      await userDirectory.create(recursive: true);
    }

    return userDirectory;
  }

  Future<File> _savePdf(pdfLib.Document pdf) async {
    final directory = await getExternalStorageDirectory();
    final file = File('${directory!.path}/events.pdf');

    await file.writeAsBytes(await pdf.save());
    return file;
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
            if (showAllEvents || eventsVisibility[date]!)
              Column(
                children: events.map((event) {
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
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                }).toList(),
              ),
            if (events.length > maxEventsToShow && !showAllEvents)
              GestureDetector(
                onTap: () {
                  setState(() {
                    showAllEvents = true;
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
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      await _generatePdf(events, widget.user);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: CQColors.iron100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(width: 1)),
                      child: Center(
                        child: Text(
                          'Exportar como arquivo PDF',
                          style: TextStyle(
                              color: CQColors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 19),
                        ),
                      ),
                      height: 40,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });

    return containers;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildEventContainers(context, widget.eventos),
    );
  }
}
