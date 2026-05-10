import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter_state.freezed.dart';

@freezed
class FilterState with _$FilterState {
  const factory FilterState({
    String? year,
    double? minRating,
    String? genre,
    @Default(false) bool isApplied,
  }) = _FilterState;
}
