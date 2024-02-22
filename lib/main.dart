import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INTERNSHALA',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simulating a splash screen with a delay
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SearchPage()),
      );
    });
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 94, 133, 165),
      body: Center(
        child: Text(
          'INTERNSHALA',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Map<String, dynamic> internshipData = {};
  Map<String, dynamic> filteredData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchInternshipData();
  }

  Future<void> fetchInternshipData() async {
    try {
      final response = await http
          .get(Uri.parse('https://internshala.com/flutter_hiring/search'));

      if (response.statusCode == 200) {
        setState(() {
          internshipData = jsonDecode(response.body)['internships_meta'];
          filteredData = Map.from(internshipData);
          isLoading = false;
        });
      } else {
        print('API call failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void applyFilters(String? profile, String? city, String? duration) {
    setState(() {
      filteredData = Map.from(internshipData).map((id, data) {
        if ((profile == null || data['title'] == profile) &&
            (city == null || data['location_names'].contains(city)) &&
            (duration == null || data['duration'] == duration)) {
          return MapEntry(id, data);
        } else {
          return MapEntry(id, null);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'INTERNSHALA',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt_sharp),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FiltersScreen(applyFilters),
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final String id = filteredData.keys.toList()[index];
                final Map<String, dynamic>? data = filteredData[id];
                if (data == null) return SizedBox();
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      data['title'] ?? 'No Title',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'City: ${data['location_names'] ?? 'Work From Home'}'),
                        Text(
                            'Employment Type: ${data['employment_type'] ?? 'No Employment Type'}'),
                        Text('Duration: ${data['duration'] ?? 'No Duration'}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class FiltersScreen extends StatefulWidget {
  final Function(String?, String?, String?) applyFilters;

  FiltersScreen(this.applyFilters);

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  String? selectedProfile;
  String? selectedCity;
  String? selectedDuration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
      ),
      body: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profile:'),
              DropdownButton<String>(
                value: selectedProfile,
                onChanged: (newValue) {
                  setState(() {
                    selectedProfile = newValue;
                  });
                },
                isExpanded: true,
                items: [
                  DropdownMenuItem(
                    child: Text('Data Science Intern'),
                    value: 'Data Science Intern',
                  ),
                  DropdownMenuItem(
                    child: Text('Administration Intern'),
                    value: 'Administration Intern',
                  ),
                  DropdownMenuItem(
                    child: Text('Business Analyst Intern'),
                    value: 'Business Analyst Intern',
                  ),
                  DropdownMenuItem(
                    child: Text('Brand Management Intern'),
                    value: 'Brand Management Intern',
                  ),
                  DropdownMenuItem(
                    child: Text('Android App Development Intern'),
                    value: 'Android App Development Intern',
                  ),
                  DropdownMenuItem(
                    child: Text('Product Management Intern'),
                    value: 'Product Management Intern',
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('City:'),
              DropdownButton<String>(
                value: selectedCity,
                onChanged: (newValue) {
                  setState(() {
                    selectedCity = newValue;
                  });
                },
                isExpanded: true, // Adjusts size based on content
                items: [
                  DropdownMenuItem(
                    child: Text('Munnar'),
                    value: 'Munnar',
                  ),
                  DropdownMenuItem(
                    child: Text('Delhi'),
                    value: 'Delhi',
                  ),
                  DropdownMenuItem(
                    child: Text('Lucknow'),
                    value: 'Lucknow',
                  ),
                  DropdownMenuItem(
                    child: Text('Tran taran'),
                    value: 'Tran taran',
                  ),
                  DropdownMenuItem(
                    child: Text('Banga'),
                    value: 'Banga',
                  ),
                  DropdownMenuItem(
                    child: Text('Kera'),
                    value: 'Kera',
                  ),
                  DropdownMenuItem(
                    child: Text('Parbhani'),
                    value: 'Parbhani',
                  ),
                  DropdownMenuItem(
                    child: Text('Gurgaon'),
                    value: 'Gurgaon',
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('Duration:'),
              DropdownButton<String>(
                value: selectedDuration,
                onChanged: (newValue) {
                  setState(() {
                    selectedDuration = newValue;
                  });
                },
                isExpanded: true,
                items: [
                  DropdownMenuItem(
                    child: Text('2 Months'),
                    value: '2 Months',
                  ),
                  DropdownMenuItem(
                    child: Text('3 Months'),
                    value: '3 Months',
                  ),
                  DropdownMenuItem(
                    child: Text('5 Months'),
                    value: '5 Months',
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  widget.applyFilters(
                    selectedProfile,
                    selectedCity,
                    selectedDuration,
                  );
                  Navigator.pop(context);
                },
                child: Text(
                  'Apply Filters',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
