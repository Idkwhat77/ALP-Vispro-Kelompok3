import 'package:equatable/equatable.dart';
import '../models/toolset_model.dart';

abstract class ToolsetState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ToolsetInitial extends ToolsetState {}

class ToolsetSelected extends ToolsetState {
  final ToolsetModel selectedToolset;

  ToolsetSelected(this.selectedToolset);

  @override
  List<Object?> get props => [selectedToolset];
}
