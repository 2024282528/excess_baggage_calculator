
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

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
    seedColor: const Color(0xFF102A56),
  ),
  scaffoldBackgroundColor: const Color(0xFFF3F6FA),
  useMaterial3: true,

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 18,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: Color(0xFF102A56),
        width: 1.5,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: Color(0xFF102A56),
        width: 1.5,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: Color(0xFF246BCE),
        width: 2,
      ),
    ),
  ),
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
        backgroundColor: const Color(0xFF102A56),
        foregroundColor: Colors.white,
        actions: [
  IconButton(
    tooltip: 'Reset Calculator',
    icon: const Icon(Icons.refresh),
    onPressed: () {
      setState(() {
        weightController.clear();
        rateController.clear();
        ticketClass = 'Economy';
        excessWeight = 0;
        excessCharge = 0;
        serviceTax = 0;
        totalPayable = 0;
        calculated = false;
      });
    },
  ),
],
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF102A56),),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                 'assets/airport_luggage.png',
              width: double.infinity,
              height: 190,
              fit: BoxFit.cover,
  ),
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
  prefixText: 'RM ',
  prefixStyle: TextStyle(
    color: Color(0xFF102A56),
    fontWeight: FontWeight.bold,
  ),
  border: OutlineInputBorder(),
),
            ),

            const SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: calculateFee,
              icon: const Icon(Icons.calculate),
              label: const Text('Calculate Fee'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 10, 43, 87),
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
        backgroundColor: const Color(0xFF102A56),
        foregroundColor: Colors.white,
      ),
      
body: Container(
  width: double.infinity,
  decoration: const BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/airport_luggage.png'),
      fit: BoxFit.cover,
      alignment: Alignment.center,
      colorFilter: ColorFilter.mode(
        Color(0x990A2342),
        BlendMode.darken,
      ),
    ),
  ),
  child: Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.93),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.luggage,
              size: 75,
              color: Color(0xFF102A56),
            ),
            const SizedBox(height: 18),
            const Text(
              'Excess Baggage Calculator',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF102A56),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Author: NURUL ANIS NASUHA BINTI MOHD NAZRI',
              textAlign: TextAlign.center,
            ),
            const Text('Matric No: 2024282528'),
            const Text(
  'Course: ICT602 - MOBILE TECHNOLOGY AND DEVELOPMENT',
  textAlign: TextAlign.center,
  style: TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Color(0xFF102A56),
  ),
),
            const SizedBox(height: 25),
            const Text('© 2026 Excess Baggage Calculator'),
            const SizedBox(height: 15),
            InkWell(
              onTap: () async {
                final url = Uri.parse(
                  'https://github.com/2024282528-png/excess_baggage_calculator',
                );
                await launchUrl(url);
              },
              child: const Text(
                'GitHub Repository: Click Here',
                style: TextStyle(
                  color: Color(0xFF102A56),
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
),
    );
  }
}