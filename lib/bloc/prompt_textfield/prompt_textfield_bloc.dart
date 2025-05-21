import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/prompt_textfield/prompt_textfield_event.dart';
import 'package:taskora/bloc/prompt_textfield/prompt_textfield_state.dart';

class PromptTextfieldBloc
    extends Bloc<PromptTextfieldEvent, PromptTextfieldState> {
  PromptTextfieldBloc() : super(PromptTextFieldClosed()) {
    on<OpenPromptTextfield>((event, emit) {
      emit(PromptTextfieldOpened());
    });

    on<ClosePromptTextfield>((event, emit) {
      emit(PromptTextFieldClosed());
    });

    on<SavePromptTextfield>((event, emit) {
      emit(PromptTextfieldSaved(prompt: event.prompt));
    });
  }
}
