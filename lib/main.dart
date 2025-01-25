import 'package:flutter/material.dart';

void main() {
  runApp(TimetableApp());
}

class TimetableApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dynamic Timetable App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      home: TimetableScreen(),
    );
  }
}

class TimetableScreen extends StatefulWidget {
  @override
  _TimetableScreenState createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  final List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  final Map<String, List<Map<String, String>>> timetable = {
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
    'Sunday': [],
  };

  void _addTimetableEntry(String day, String entry, String timePeriod) {
    setState(() {
      timetable[day]?.add({'entry': entry, 'time': timePeriod});
    });
  }

  void _removeTimetableEntry(String day, int index) {
    setState(() {
      timetable[day]?.removeAt(index);
    });
  }

  void _showAddEntryDialog(String day) {
    TextEditingController entryController = TextEditingController();
    TextEditingController timeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        title: Text('Add Entry for $day', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: entryController,
              decoration: InputDecoration(
                hintText: 'Enter schedule item',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: timeController,
              decoration: InputDecoration(
                hintText: 'Enter time period (e.g., 9:00 AM - 10:00 AM)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              if (entryController.text.isNotEmpty && timeController.text.isNotEmpty) {
                _addTimetableEntry(day, entryController.text, timeController.text);
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
            ),
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Weekly Timetable'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: ListView.builder(
        itemCount: days.length,
        itemBuilder: (context, index) {
          String day = days[index];
          List<Map<String, String>> schedule = timetable[day] ?? [];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: ExpansionTile(
              tilePadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              title: Text(
                day,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              iconColor: Colors.indigo,
              children: [
                ...schedule.asMap().entries.map((entry) => ListTile(
                  title: Text(entry.value['entry'] ?? ''),
                  subtitle: Text(entry.value['time'] ?? ''),
                  leading: Icon(Icons.event_note, color: Colors.indigo),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeTimetableEntry(day, entry.key),
                  ),
                )),
                ListTile(
                  leading: Icon(Icons.add, color: Colors.indigo),
                  title: Text('Add Entry', style: TextStyle(color: Colors.indigo)),
                  onTap: () => _showAddEntryDialog(day),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.indigo,
        child: Icon(Icons.add),
      ),
    );
  }
}
