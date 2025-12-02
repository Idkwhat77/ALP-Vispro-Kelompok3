import 'package:flutter_bloc/flutter_bloc.dart';
import 'toolset_event.dart';
import 'toolset_state.dart';

class ToolsetBloc extends Bloc<ToolsetEvent, ToolsetState> {
  ToolsetBloc() : super(ToolsetInitial()) {
    on<SelectToolsetEvent>((event, emit) {
      emit(ToolsetSelected(event.toolset));
    });
  }
}
