abstract class PromptTextfieldState {}

class PromptTextfieldOpened extends PromptTextfieldState {}

class PromptTextFieldClosed extends PromptTextfieldState {}

class PromptTextfieldSaved extends PromptTextfieldState {
  final String prompt;
  PromptTextfieldSaved({required this.prompt});
}
