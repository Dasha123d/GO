import 'package:equatable/equatable.dart';

abstract class Action extends Equatable {
  @override
  List<Object> get props => [];
  
  const Action();
}