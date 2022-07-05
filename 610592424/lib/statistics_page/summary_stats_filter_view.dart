import 'package:flutter/material.dart';

import 'package:diploma/models/event_holder.dart';
import 'summary_stats_cubit.dart';

class SummaryStatsFilterView extends StatefulWidget {
  final SummaryStatsCubit _cubit;

  const SummaryStatsFilterView(this._cubit, {Key? key}) : super(key: key);

  @override
  State<SummaryStatsFilterView> createState() => _SummaryStatsFilterViewState();
}

class _SummaryStatsFilterViewState extends State<SummaryStatsFilterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Choose pages'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  Widget _body() {
    return FutureBuilder(
      future: widget._cubit.getEventHoldersFiltersList,
      builder: (context, AsyncSnapshot<List<EventHolder>> snapshot) {
        if (snapshot.hasData) {
          return GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 3,
            children: [
              for (var eventHolder in snapshot.data!)
                GestureDetector(
                  onTap: () {
                    widget._cubit
                        .onEventholderFilterTap(eventHolder.eventholderId);
                    setState(() {});
                  },
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blueGrey,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: widget._cubit
                              .isEventholderSelected(eventHolder.eventholderId)
                          ? Row(
                              children: [
                                const Icon(Icons.check_box),
                                Text(eventHolder.title),
                              ],
                            )
                          : Text(eventHolder.title),
                    ),
                  ),
                ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
