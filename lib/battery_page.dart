import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Orchestrator {
  List<Function> functions = [];

  void add(Function fun) => functions.add(fun);

  Future execute() async {
    functions.forEach((fun) async => await fun());
  }
}

class BatteryPage extends StatefulWidget {
  BatteryPage({Key? key}) : super(key: key);

  @override
  _BatteryPageState createState() => _BatteryPageState();
}

class _BatteryPageState extends State<BatteryPage> {
  static const plataform = MethodChannel("native.flutter/battery");

  Orchestrator orchestrator = new Orchestrator();

  String _batteryLevel = "Nível desconhecido";
  String _statusCharger = "Status desconhecido";

  Future<void> _getBatteryLevel() async {
    String batteryLevel = "";

    try {
      final int result = await plataform.invokeMethod('getBatteryLevel');
      batteryLevel = "Nível da bateria: $result%";
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Falha ao buscar o nível da bateria",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _batteryLevel = batteryLevel;
      });
    }
  }

  Future<void> _getStatusCharger() async {
    String status = "";

    try {
      final String result = await plataform.invokeMethod('getStatusCharger');
      status = "Status da bateria: $result";
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Falha ao buscar o status da bateria",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _statusCharger = status;
      });
    }
  }

  @override
  void initState() {
    orchestrator.add(_getBatteryLevel);
    orchestrator.add(_getStatusCharger);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Informações da bateria"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sua bateria",
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 32),
            Text(_batteryLevel),
            SizedBox(height: 8),
            Text(_statusCharger),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await orchestrator.execute();
        },
        label: Text("Atualizar"),
      ),
    );
  }
}
