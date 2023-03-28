import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:untitled/screens/remote_screen.dart';
import 'package:lan_scanner/lan_scanner.dart';
import 'package:flutter/src/widgets/icon.dart' as Icon;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:udp/udp.dart';

class DeviceListingScreen extends StatefulWidget {
  const DeviceListingScreen({Key? key}) : super(key: key);

  @override
  State<DeviceListingScreen> createState() => _DeviceListingScreenState();
}

class _DeviceListingScreenState extends State<DeviceListingScreen> {
  final List<HostModel> _hosts = <HostModel>[];

  var result;



  _refreshHostsList() async {
    print('host called');
    final scanner = LanScanner(debugLogging: true);
    String thisDeviceIp = "";
    for (var interface in await NetworkInterface.list()) {
      if (interface.name == 'wlan0') {
        thisDeviceIp = interface.addresses[0].address;
        print("Device ip found : $thisDeviceIp");
      }
    }

    List<String> segment = thisDeviceIp.split('.');

    String scanIpSegment = "${segment[0]}.${segment[1]}.${segment[2]}";

    final stream = scanner.icmpScan(
      scanIpSegment,
      progressCallback: (progress) {
        if (kDebugMode) {
          print('progress: $progress');
        }
      },
    );

    stream.listen((HostModel host) {
      setState(() {
        _hosts.add(host);
      });
    });
  }

  @override
  void initState() {
    _refreshHostsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Text(
                "Devices",
                style: TextStyle(fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _hosts.length,
                  itemBuilder: ((context, index) {
                    return Card(
                      child: ListTile(
                        leading: Icon.Icon(
                          Icons.tv_sharp,
                          color: Colors.blue.shade400,
                        ),
                        tileColor: Color(0xFF373737),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    TVRemoteDemo(hostIP: _hosts[index].ip))),
                            title: Text(_hosts[index].ip,
                            style: TextStyle(fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  })),
            ),
          ],
        ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const QRViewExample(),
          ));
        },
        child: Icon.Icon(Icons.document_scanner_outlined),
      ),
    );
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (result != null){
      print("@@@@@");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  TVRemoteDemo(hostIP: result.toString())));
    }
    else{

    }
      //Text()
         // 'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
    //else
         //const Text('Scan a code'),
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  else
                    const Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Text('Flash: ${snapshot.data}');
                              },
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                      'Camera facing ${describeEnum(snapshot.data!)}');
                                } else {
                                  return const Text('loading');
                                }
                              },
                            )),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.pauseCamera();
                          },
                          child: const Text('pause',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          child: const Text('resume',
                              style: TextStyle(fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {

      setState(() {
         result = scanData;
         onTap: () => Navigator.push(
             context,
             MaterialPageRoute(
                 builder: (_) =>
                     TVRemoteDemo(hostIP: result.toString())));
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    //log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}