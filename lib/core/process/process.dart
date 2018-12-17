import 'package:harpy/core/process/process_step.dart';

abstract class HarpyProcess {
  List<ProcessStep> steps;

  List<ProcessStep> initSteps();

  dynamic start(Map<String, dynamic> data) async {
    steps = initSteps();

    print("${steps.length} steps");

    Map<String, dynamic> prevStepResult;

    for (int i = 0; i < steps.length; i++) {
      ProcessStep currentStep = steps[i];
      prevStepResult = await currentStep.performStep(data, prevStepResult);
      print("$i. step -> data: $data");
    }

    return data;
  }
}
