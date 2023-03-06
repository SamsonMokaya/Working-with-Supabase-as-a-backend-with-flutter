import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'myButton.dart';

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();

  final String key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1bWJtcGlvaW9vZmt0cG16aGFrIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzgwOTgwODgsImV4cCI6MTk5MzY3NDA4OH0.Vn8gs8-yGzRsi5tr41PAOEDnBDQZpG5u3NG-K3WpJhc";
  final String url= "https://fumbmpioioofktpmzhak.supabase.co";

  await Supabase.initialize(
      url: url,
      anonKey: key);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Countries',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;
  final _countryController = TextEditingController();

  List<dynamic> countries = [];

  void initState(){
    super.initState();
    getData();
  }

  final _future = Supabase.instance.client
      .from('countries')
      .select<List<Map<String, dynamic>>>();


  void getData() async{
    final response = await supabase
        .from('countries')
        .select('name').execute();

    setState(() {
      countries = response.data as List<dynamic>;
    });
  }

  void _storeData() async{

    final newCountry = {
      'name':_countryController.text
    };

    final response = await supabase.from('countries').insert(newCountry).execute();

    getData();

  }

  void _openReminderForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _countryController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                myButton(onTap: _storeData, text: "Save Reminder")
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: countries.length,
                itemBuilder: ((context, index){
                  final country = countries[index];
                   return ListTile(
                     title: Text(country['name'])
                   );
                })
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _openReminderForm(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }
}