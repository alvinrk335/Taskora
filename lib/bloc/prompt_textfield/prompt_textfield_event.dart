abstract class PromptTextfieldEvent {}

class OpenPromptTextfield extends PromptTextfieldEvent {}

class ClosePromptTextfield extends PromptTextfieldEvent {}

class SavePromptTextfield extends PromptTextfieldEvent {
  final String prompt;
  SavePromptTextfield({required this.prompt});
}
