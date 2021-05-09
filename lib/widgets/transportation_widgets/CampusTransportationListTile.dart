import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Service {
  final String name;
  final String time;
  final String startEnd;
  final String routes;
  Service({
    this.name,
    this.time,
    this.startEnd,
    this.routes,
  });
}

class CampusTransportationListTile extends StatelessWidget {
  CampusTransportationListTile(this._serviceList);
  final List<Service> _serviceList;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: _serviceList.length ?? 0,
        padding: EdgeInsets.only(
          bottom: 12,
          top: 12,
          left: 8,
          right: 8,
        ),
        separatorBuilder: (BuildContext context, int index) => Divider(
              height: 10,
              color: Colors.white,
            ),
        itemBuilder: (context, index) => Card(
              color: Color(0xff52C3DA),
              elevation: 7,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(child: Icon(FontAwesomeIcons.bus,color: Colors.white,)),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      color: Colors.white,
                      child: ListTile(
                        dense: true,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${_serviceList[index].name ?? ""} : ${_serviceList[index].startEnd ?? ""}",
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      _serviceList[index].time ?? "",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                          child: Text(_serviceList[index].routes),
                        ),
                        isThreeLine: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),);
  }
}
