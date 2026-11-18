
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Excess Baggage Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final weightController = TextEditingController();
  final rateController = TextEditingController();

  String ticketClass = 'Economy';

  double excessWeight = 0;
  double excessCharge = 0;
  double serviceTax = 0;
  double totalPayable = 0;

  bool calculated = false;

  void calculateFee() {
    final weight = double.tryParse(weightController.text);
    final rate = double.tryParse(rateController.text);

    if (weight == null || rate == null ||
        weight < 0 || rate < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid positive numbers.'),
        ),
      );
      return;
    }

    final limit = ticketClass == 'Economy' ? 20.0 : 40.0;

    setState(() {
      excessWeight = (weight - limit).clamp(0, double.infinity);
      excessCharge = excessWeight * rate;
      serviceTax = excessCharge * 0.08;
      totalPayable = excessCharge + serviceTax;
      calculated = true;
    });
  }

  @override
  void dispose() {
    weightController.dispose();
    rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Excess Baggage Calculator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Baggage Calculator',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.luggage,
              size: 65,
              color: Colors.blue,
            ),

            const SizedBox(height: 10),

            const Text(
              'Calculate Your Excess Baggage Fee',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            TextField(
              controller: weightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Baggage Weight (kg)',
                prefixIcon: Icon(Icons.scale),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 18),

            DropdownButtonFormField<String>(
              initialValue: ticketClass,
              decoration: const InputDecoration(
                labelText: 'Ticket Class',
                prefixIcon: Icon(Icons.airplane_ticket),
                border: OutlineInputBorder(),
              ),
              items: ['Economy', 'Business'].map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  ticketClass = value!;
                  calculated = false;
                });
              },
            ),

            const SizedBox(height: 18),

            TextField(
              controller: rateController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Excess Baggage Rate (RM/kg)',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: calculateFee,
              icon: const Icon(Icons.calculate),
              label: const Text('Calculate Fee'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),

            if (calculated) ...[
              const SizedBox(height: 25),

              const Text(
                'Calculation Results',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              resultRow(
                'Excess Baggage Weight',
                '${excessWeight.toStringAsFixed(2)} kg',
              ),

              resultRow(
                'Excess Baggage Charge',
                'RM ${excessCharge.toStringAsFixed(2)}',
              ),

              resultRow(
                'Service Tax (8%)',
                'RM ${serviceTax.toStringAsFixed(2)}',
              ),

              const Divider(),

              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      const Text(
                        'TOTAL AMOUNT PAYABLE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'RM ${totalPayable.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget resultRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.luggage,
                size: 80,
                color: Colors.blue,
              ),
              SizedBox(height: 20),
              Text(
                'Excess Baggage Calculator',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text('Author: NURUL ANIS NASUHA BINTI MOHD NAZRI'),
              Text('Matric No: 2024282528'),
              Text('Course: CS266'),
              SizedBox(height: 25),
              Text('© 2026 Excess Baggage Calculator'),
              SizedBox(height: 10),
              Text('GitHub Repository: To be added'),
            ],
          ),
        ),
      ),
    );
  }
}
