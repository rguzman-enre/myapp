// Suggested code may be subject to a license. Learn more: ~LicenseLog:2870512989.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1133874944.
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Cortes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<int> _counters = List.generate(10, (index) => 0);
  int _selectedCounterIndex = 0;
  String _ufsData = 'NADA';
  final List<String> _counterLabels = [
    "UFS",
    "Contador dos",
    "Contador tres",
    "Contador cuatro",
    "Contador cinco",
    "Final"
  ];

  @override
  void initState() {
    super.initState();
    _fetchUfsData();
  }

  Future<void> _fetchUfsData() async {
    final response = await http.post(
      Uri.parse(
          'https://www.enre.gov.ar/web/pinbb.nsf/ObtenerCortes-Android?OpenAgent'),
      headers: {'REQUEST_CONTENT': '~OBTENER_CORTES_EMPRESA2~'},
    );

    if (response.statusCode == 200) {
      setState(() {
        _ufsData = response.body;
      });
      //print(response.body); // Imprime la respuesta en la consola del servidor
    } else {
      //print('Failed to load UFS data');
      throw Exception('Failed to load UFS data');
    }
  }

  @override
  Widget build(BuildContext context) {
    void incrementCounter(int index) {
      setState(() {
        _counters[index]++;
      });
    }

    void decrementCounter(int index) {
      setState(() {
        _counters[index]--;
      });
    }

    void setSelectedCounterIndex(int index) {
      setState(() {
        _selectedCounterIndex = index;
        if (index == 0) {
          _fetchUfsData(); 
        }
      });
    }

    return Scaffold(
      // Scaffold: widget principal que proporciona la estructura básica de la pantalla.
      appBar: AppBar(
        // AppBar: barra de aplicación en la parte superior de la pantalla.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // backgroundColor: color de fondo de la barra de aplicación.
        title: Row(
          children: [const Icon(Icons.electric_bolt), Text(widget.title)],
          // title: widget de texto que muestra el título de la aplicación.
        ),
      ),
      body: Column(
        // Column: widget que organiza sus hijos en una columna vertical.
        children: [
          SingleChildScrollView(
            // SingleChildScrollView: widget que permite el desplazamiento de su contenido si es demasiado grande para la pantalla.
            scrollDirection: Axis.horizontal,
            // scrollDirection: dirección del desplazamiento (horizontal en este caso).
            child: Row(
              children: List.generate(_counterLabels.length, (index) {
                // List.generate: crea una lista de 10 elementos, cada uno un botón.
                return Padding(
                  // Padding: widget que agrega espacio alrededor de su hijo.
                  padding: const EdgeInsets.all(0),
                  // padding: espacio de 8.0 en todos los lados.
                  child: OutlinedButton(
                    onPressed: () => setSelectedCounterIndex(index),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      side: const BorderSide(color: Colors.blue),
                    ),
                    child: Text(_counterLabels[index]),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            // Expanded: widget que expande su hijo para que llene el espacio disponible.
            child: Center(
              // Center: widget que centra su hijo.
              child: Column(
                // Column: widget que organiza sus hijos en una columna vertical.
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisAlignment: alinea los hijos en el centro del eje principal (vertical en este caso).
                children: <Widget>[
                  const Text(
                    'Seleccionado:',
                    // Text: widget que muestra texto.
                  ),
                  Text(_counterLabels[_selectedCounterIndex]),
                  const Text(
                    'Contador:',
                    // Text: widget que muestra texto.
                  ),
                  if (_selectedCounterIndex == 0) 
                    Text(
                      _ufsData,
                      // Text: widget que muestra el valor de _ufsData si _selectedCounterIndex es 0.
                      style: Theme.of(context).textTheme.headlineMedium,
                    )
                  else
                    Text(
                      '${_counters[_selectedCounterIndex]}',
                      // Text: widget que muestra el valor del contador seleccionado si _selectedCounterIndex no es 0.
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: FloatingActionButton(
            onPressed: () => decrementCounter(_selectedCounterIndex),
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(right: 0),
        //   child: FloatingActionButton(
        //     onPressed: () => incrementCounter(_selectedCounterIndex),
        //     tooltip: 'Increment',
        //     child: const Icon(Icons.add),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(right: 0),
          child: FloatingActionButton(
            onPressed: () => incrementCounter(_selectedCounterIndex),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ),
      ]),
    );
  }
}
