import 'package:master_plan/provider/plan_provider.dart';

import '../models/data_layer.dart';
import 'package:flutter/material.dart';

class PlanScreen extends StatefulWidget {
  final Plan plan;
  const PlanScreen({Key? key, required this.plan}) : super(key: key);

  @override
  State createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  // Plan plan = const Plan();
  late ScrollController scrollController;
  Plan get plan => widget.plan;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        FocusScope.of(context).requestFocus(FocusNode());
      });
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<List<Plan>> plansNotifier = PlanProvider.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(plan.name)),
      body: ValueListenableBuilder<List<Plan>>(
        valueListenable: plansNotifier,
        builder: (context, plans, child) {
          Plan currentPlan = plans.firstWhere((p) => p.name == plan.name);
          return Column(
            children: [
              Expanded(child: _buildList(currentPlan)),
              SafeArea(child: Text(currentPlan.completenessMessage)),
            ],
          );
        },
      ),
      floatingActionButton: _buildAddTaskButton(
        context,
      ),
    );
  }

  Widget _buildAddTaskButton(BuildContext context) {
    ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        int planIndex =
            planNotifier.value.indexWhere((p) => p.name == plan.name);
        if (planIndex != -1) {
          Plan currentPlan = planNotifier.value[planIndex];
          List<Task> updatedTasks = List<Task>.from(currentPlan.tasks)
            ..add(const Task());
          List<Plan> updatedPlans = List<Plan>.from(planNotifier.value);
          updatedPlans[planIndex] = Plan(
            name: currentPlan.name,
            tasks: updatedTasks,
          );
          planNotifier.value = updatedPlans;
        }
      },
    );
  }

  Widget _buildList(Plan plan) {
    return ListView.builder(
      controller: scrollController,
      itemCount: plan.tasks.length,
      itemBuilder: (context, index) =>
          _buildTaskTile(plan.tasks[index], index, context),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Widget _buildTaskTile(Task task, int index, BuildContext context) {
    ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);

    return ListTile(
      leading: Checkbox(
        value: task.complete,
        onChanged: (selected) {
          List<Plan> currentPlans = List<Plan>.from(planNotifier.value);
          Plan currentPlan =
              currentPlans.firstWhere((p) => p.name == plan.name);
          int planIndex = currentPlans.indexWhere((p) => p.name == plan.name);
          List<Task> updatedTasks = List<Task>.from(currentPlan.tasks);
          updatedTasks[index] = Task(
            description: task.description,
            complete: selected ?? false,
          );

          currentPlans[planIndex] = Plan(
            name: currentPlan.name,
            tasks: updatedTasks,
          );

          planNotifier.value = currentPlans;
        },
      ),
      title: TextFormField(
        initialValue: task.description,
        onChanged: (text) {
          List<Plan> currentPlans = List<Plan>.from(planNotifier.value);
          Plan currentPlan =
              currentPlans.firstWhere((p) => p.name == plan.name);
          int planIndex = currentPlans.indexWhere((p) => p.name == plan.name);
          List<Task> updatedTasks = List<Task>.from(currentPlan.tasks);
          updatedTasks[index] = Task(
            description: text,
            complete: task.complete,
          );

          currentPlans[planIndex] = Plan(
            name: currentPlan.name,
            tasks: updatedTasks,
          );

          planNotifier.value = currentPlans;
        },
      ),
    );
  }

  Widget _buildProgressFooter(Plan plan) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(plan.completenessMessage),
      ),
    );
  }
}