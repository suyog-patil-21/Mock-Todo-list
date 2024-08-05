import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:todolist/src/data/task_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ValueNotifier<List<Tasks>> _taskListValueNotifier =
      ValueNotifier<List<Tasks>>([]);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getData();
    });
  }

  @override
  void dispose() {
    _taskListValueNotifier.dispose();
    super.dispose();
  }

  Future<void> getData() async {
    final List<Tasks> res = await getTasks();
    if (res.isNotEmpty) {
      _taskListValueNotifier.value = List.from(res);
    }
  }

  Future<List<Tasks>> getTasks() async {
    try {
      Dio dio = Dio();
      final res = await dio
          .get('https://mocki.io/v1/1a86bb36-50d6-4344-b7e7-eb48ac01ffc0');
      if (res.statusCode == 200) {
        List<Tasks> result = [];
        final data = res.data;
        for (int i = 0; i < data.length; i++) {
          result.add(Tasks.fromMap(data[i] as Map<String, dynamic>));
        }
        return result;
      }
    } catch (err) {
      print("Error while fetching $err");
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo list')),
      body: ValueListenableBuilder(
          valueListenable: _taskListValueNotifier,
          builder: (context, val, child) {
            return ListView.builder(
                itemCount: val.length,
                itemBuilder: (context, index) {
                  final Tasks task = val[index];
                  return ListTile(
                    leading: Icon(task.completed ? Icons.check : Icons.close),
                    title: Text(task.title),
                    subtitle: Text(
                        'Complete:${task.completed}  Priority:${task.priority}'),
                  );
                });
          }),
    );
  }
}
