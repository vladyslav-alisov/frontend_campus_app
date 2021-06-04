import 'dart:async';
import 'dart:collection';

import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/widgets/CampusAppBar.dart';
import 'package:campus_app/widgets/transportation_widgets/CampusTransportationListTile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  MapSample(this.service);
  final Service service;
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  GoogleMapController _controller;
  Set<Polyline> _polilines = HashSet<Polyline>();

  @override
  void initState() {
    _setPolyLines();
    super.initState();
  }

  void _setPolyLines() {
    List<LatLng> polylineLatLongs = List<LatLng>();
    polylineLatLongs.addAll([
      LatLng(37.05188010505809, 30.620958455171444),
      LatLng(36.93595890230468, 30.65351980579249),
      LatLng(36.90477133631206, 30.654765080575938),
      LatLng(36.921310248061395, 30.666157322636742),
      LatLng(36.88265487165824, 30.659536689073857),
      LatLng(36.885498982044886, 30.625601361029076)
    ]);

    _polilines.add(Polyline(polylineId: PolylineId("0"), points: polylineLatLongs, color: Colors.red, width: 3));
  }

  void onMapCreated(GoogleMapController controller) {}
  Set<Marker> markers = HashSet<Marker>();
  static final CameraPosition initPosition =
      CameraPosition(target: LatLng(37.05188010505809, 30.620958455171444), zoom: 12);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          AppBar().preferredSize.height + 10,
        ),
        child: CampusAppBar(
          title: widget.service.name,
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            polylines: _polilines,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(target: LatLng(37.05188010505809, 30.620958455171444), zoom: 12),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              setState(() {
                markers.addAll(
                  [
                    Marker(
                      markerId: MarkerId("0"),
                      position: LatLng(37.05188010505809, 30.620958455171444),
                      infoWindow: InfoWindow(title: "Antalya Bilim University"),
                    ),
                    Marker(
                      markerId: MarkerId("1"),
                      position: LatLng(36.93595890230468, 30.65351980579249),
                      infoWindow: InfoWindow(title: "Kepez"),
                    ),
                    Marker(
                      markerId: MarkerId("2"),
                      position: LatLng(36.90477133631206, 30.654765080575938),
                      infoWindow: InfoWindow(title: "Kultur"),
                    ),
                    Marker(
                      markerId: MarkerId("3"),
                      position: LatLng(36.921310248061395, 30.666157322636742),
                      infoWindow: InfoWindow(title: "Otogar"),
                    ),
                    Marker(
                      markerId: MarkerId("4"),
                      position: LatLng(36.88265487165824, 30.659536689073857),
                      infoWindow: InfoWindow(title: "5M Migros"),
                    ),
                    Marker(
                      markerId: MarkerId("5"),
                      position: LatLng(36.885498982044886, 30.625601361029076),
                      infoWindow: InfoWindow(title: "Uncali"),
                    ),
                  ],
                );
              });
            },
            markers: markers,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0, left: 15, right: 15),
              child: Container(
                height: 70,
                color: Colors.white,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: Container(
                        color: Color(0xff52C3DA),
                        child: Center(
                          child: Icon(
                            FontAwesomeIcons.bus,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ListTile(
                          dense: false,
                          title: Text("${widget.service.startEnd ?? ""}",maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(color: Colors.black, fontSize: 12),),
                          subtitle: Column(
                            children: [
                              Divider(thickness: 0.5,color: Colors.black,),
                              Text(
                                widget.service.routes,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: TextStyle(color: Colors.black, fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
