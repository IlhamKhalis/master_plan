import 'package:flutter/material.dart';
import 'package:master_plan/models/data_layer.dart';
import 'package:master_plan/provider/plan_provider.dart';
import 'package:master_plan/views/plan_screen.dart';

class PlanCreatorScreen extends StatefulWidget {
  const PlanCreatorScreen({super.key});

  @override
  State<PlanCreatorScreen> createState() => _PlanCreatorScreenState();
}

class _PlanCreatorScreenState extends State<PlanCreatorScreen> {
  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    Widget _buildMasterPlans() {
      ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);
      List<Plan> plans = planNotifier.value;

      if (plans.isEmpty) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.note, size: 100, color: Colors.grey),
              Text('Anda belum memiliki rencana apapun.',
                  style: Theme.of(context).textTheme.headlineSmall)
            ]);
      }
      return ListView.builder(
          itemCount: plans.length,
          itemBuilder: (context, index) {
            final plan = plans[index];
            return ListTile(
                title: Text(plan.name),
                subtitle: Text(plan.completenessMessage),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => PlanScreen(
                            plan: plan,
                          )));
                });
          });
    }

    void addPlan() {
      final text = textController.text;
      if (text.isEmpty) {
        return;
      }
      final plan = Plan(name: text, tasks: []);
      ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);
      planNotifier.value = List<Plan>.from(planNotifier.value)..add(plan);
      textController.clear();
      FocusScope.of(context).requestFocus(FocusNode());
      setState(() {});
    }

    Widget _buildListCreator() {
      return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Material(
            color: Theme.of(context).cardColor,
            elevation: 10,
            child: TextField(
                controller: textController,
                decoration: const InputDecoration(
                    labelText: 'Add a plan',
                    contentPadding: EdgeInsets.all(20)),
                onEditingComplete: addPlan),
          ));
    }

    @override
    void dispose() {
      textController.dispose();
      super.dispose();
    }

    return Scaffold(
      // ganti ‘Namaku' dengan nama panggilan Anda
      appBar: AppBar(title: const Text('Master Plans Ilham')),
      body: Column(children: [
        _buildListCreator(),
        Expanded(child: _buildMasterPlans())
      ]),
    );
  }
}