import 'dart:math';

import 'package:flutter/material.dart' hide Column;
import 'package:json_annotation/json_annotation.dart';
import 'package:room_annotation/room_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'main.g.dart';

void main() => runApp(const MyApp());

@RoomDatabase(
  version: 1,
  entities: [Company],
)
class MyDatabase with _$MyDatabase {
  @override
  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    //TODO: run your db migrations here. See the docs from `sqflite` package.
  }
}

@CrudRepository(
  database: MyDatabase,
  entity: Company,
)
class CompanyRepository with _$CompanyRepository {}

@Entity()
@JsonSerializable()
class Company with $CompanyEntity {
  @PrimaryKey()
  final String document;

  @Column()
  String? name;

  Company({
    required this.document,
    this.name,
  });

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  late MyDatabase database;
  final companyRepository = CompanyRepository();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    final database = MyDatabase();
    await database.initialize();
    this.database = database;
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? null
          : FutureBuilder(
              future: companyRepository.findAll(),
              builder: (context, snapshot) {
                final companies = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: companies.length,
                  itemBuilder: (context, index) {
                    final company = companies[index];
                    return ListTile(
                      title: Text(company.name ?? 'empty'),
                      leading: IconButton(
                        onPressed: () {},
                        icon: IconButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                final controller = TextEditingController();
                                return AlertDialog(
                                  content: TextFormField(
                                    controller: controller,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'name',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        company.name = controller.text.trim();
                                        Navigator.pop(context);
                                      },
                                      child: Text('save'),
                                    ),
                                  ],
                                );
                              },
                            );
                            setState(() => isLoading = true);
                            await companyRepository.save(company);
                            if (mounted) setState(() => isLoading = false);
                          },
                          icon: Icon(Icons.edit),
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () async {
                          setState(() => isLoading = true);
                          await companyRepository.deleteById(company.document);
                          if (mounted) setState(() => isLoading = false);
                        },
                        icon: Icon(Icons.delete),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: isLoading
          ? null
          : FloatingActionButton(
              onPressed: () async {
                setState(() => isLoading = true);
                await companyRepository.save(
                  Company(
                    name: 'hello',
                    document: Random().nextInt(1000).toString(),
                  ),
                );
                if (mounted) setState(() => isLoading = false);
              },
            ),
    );
  }
}
