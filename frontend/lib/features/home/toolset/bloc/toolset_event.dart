import 'package:equatable/equatable.dart';
import '../models/toolset_model.dart';

abstract class ToolsetEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SelectToolsetEvent extends ToolsetEvent {
  final ToolsetModel toolset;

  SelectToolsetEvent(this.toolset);

  @override
  List<Object?> get props => [toolset];
}
