abstract class ProcessStep {
  Future<dynamic> performStep(
      Map<String, dynamic> data, Map<String, dynamic> prevStepResult);
}
