// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'questionnaire_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuestionItem _$QuestionItemFromJson(Map<String, dynamic> json) {
  return _QuestionItem.fromJson(json);
}

/// @nodoc
mixin _$QuestionItem {
  String get questionId => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String get questionType =>
      throw _privateConstructorUsedError; // 'text' or 'multiChoice'
  List<String> get choices => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuestionItemCopyWith<QuestionItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionItemCopyWith<$Res> {
  factory $QuestionItemCopyWith(
          QuestionItem value, $Res Function(QuestionItem) then) =
      _$QuestionItemCopyWithImpl<$Res, QuestionItem>;
  @useResult
  $Res call(
      {String questionId,
      String text,
      String questionType,
      List<String> choices});
}

/// @nodoc
class _$QuestionItemCopyWithImpl<$Res, $Val extends QuestionItem>
    implements $QuestionItemCopyWith<$Res> {
  _$QuestionItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? text = null,
    Object? questionType = null,
    Object? choices = null,
  }) {
    return _then(_value.copyWith(
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      questionType: null == questionType
          ? _value.questionType
          : questionType // ignore: cast_nullable_to_non_nullable
              as String,
      choices: null == choices
          ? _value.choices
          : choices // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionItemImplCopyWith<$Res>
    implements $QuestionItemCopyWith<$Res> {
  factory _$$QuestionItemImplCopyWith(
          _$QuestionItemImpl value, $Res Function(_$QuestionItemImpl) then) =
      __$$QuestionItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String questionId,
      String text,
      String questionType,
      List<String> choices});
}

/// @nodoc
class __$$QuestionItemImplCopyWithImpl<$Res>
    extends _$QuestionItemCopyWithImpl<$Res, _$QuestionItemImpl>
    implements _$$QuestionItemImplCopyWith<$Res> {
  __$$QuestionItemImplCopyWithImpl(
      _$QuestionItemImpl _value, $Res Function(_$QuestionItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? text = null,
    Object? questionType = null,
    Object? choices = null,
  }) {
    return _then(_$QuestionItemImpl(
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      questionType: null == questionType
          ? _value.questionType
          : questionType // ignore: cast_nullable_to_non_nullable
              as String,
      choices: null == choices
          ? _value._choices
          : choices // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionItemImpl implements _QuestionItem {
  const _$QuestionItemImpl(
      {required this.questionId,
      required this.text,
      required this.questionType,
      final List<String> choices = const []})
      : _choices = choices;

  factory _$QuestionItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionItemImplFromJson(json);

  @override
  final String questionId;
  @override
  final String text;
  @override
  final String questionType;
// 'text' or 'multiChoice'
  final List<String> _choices;
// 'text' or 'multiChoice'
  @override
  @JsonKey()
  List<String> get choices {
    if (_choices is EqualUnmodifiableListView) return _choices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_choices);
  }

  @override
  String toString() {
    return 'QuestionItem(questionId: $questionId, text: $text, questionType: $questionType, choices: $choices)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionItemImpl &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.questionType, questionType) ||
                other.questionType == questionType) &&
            const DeepCollectionEquality().equals(other._choices, _choices));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, questionId, text, questionType,
      const DeepCollectionEquality().hash(_choices));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionItemImplCopyWith<_$QuestionItemImpl> get copyWith =>
      __$$QuestionItemImplCopyWithImpl<_$QuestionItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionItemImplToJson(
      this,
    );
  }
}

abstract class _QuestionItem implements QuestionItem {
  const factory _QuestionItem(
      {required final String questionId,
      required final String text,
      required final String questionType,
      final List<String> choices}) = _$QuestionItemImpl;

  factory _QuestionItem.fromJson(Map<String, dynamic> json) =
      _$QuestionItemImpl.fromJson;

  @override
  String get questionId;
  @override
  String get text;
  @override
  String get questionType;
  @override // 'text' or 'multiChoice'
  List<String> get choices;
  @override
  @JsonKey(ignore: true)
  _$$QuestionItemImplCopyWith<_$QuestionItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommunityQuestionnaire _$CommunityQuestionnaireFromJson(
    Map<String, dynamic> json) {
  return _CommunityQuestionnaire.fromJson(json);
}

/// @nodoc
mixin _$CommunityQuestionnaire {
  String get id => throw _privateConstructorUsedError;
  String get communityId => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  List<QuestionItem> get questions =>
      throw _privateConstructorUsedError; // 1-5 questions
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommunityQuestionnaireCopyWith<CommunityQuestionnaire> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunityQuestionnaireCopyWith<$Res> {
  factory $CommunityQuestionnaireCopyWith(CommunityQuestionnaire value,
          $Res Function(CommunityQuestionnaire) then) =
      _$CommunityQuestionnaireCopyWithImpl<$Res, CommunityQuestionnaire>;
  @useResult
  $Res call(
      {String id,
      String communityId,
      String ownerId,
      List<QuestionItem> questions,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$CommunityQuestionnaireCopyWithImpl<$Res,
        $Val extends CommunityQuestionnaire>
    implements $CommunityQuestionnaireCopyWith<$Res> {
  _$CommunityQuestionnaireCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? communityId = null,
    Object? ownerId = null,
    Object? questions = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      communityId: null == communityId
          ? _value.communityId
          : communityId // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      questions: null == questions
          ? _value.questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<QuestionItem>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommunityQuestionnaireImplCopyWith<$Res>
    implements $CommunityQuestionnaireCopyWith<$Res> {
  factory _$$CommunityQuestionnaireImplCopyWith(
          _$CommunityQuestionnaireImpl value,
          $Res Function(_$CommunityQuestionnaireImpl) then) =
      __$$CommunityQuestionnaireImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String communityId,
      String ownerId,
      List<QuestionItem> questions,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$CommunityQuestionnaireImplCopyWithImpl<$Res>
    extends _$CommunityQuestionnaireCopyWithImpl<$Res,
        _$CommunityQuestionnaireImpl>
    implements _$$CommunityQuestionnaireImplCopyWith<$Res> {
  __$$CommunityQuestionnaireImplCopyWithImpl(
      _$CommunityQuestionnaireImpl _value,
      $Res Function(_$CommunityQuestionnaireImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? communityId = null,
    Object? ownerId = null,
    Object? questions = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$CommunityQuestionnaireImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      communityId: null == communityId
          ? _value.communityId
          : communityId // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      questions: null == questions
          ? _value._questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<QuestionItem>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommunityQuestionnaireImpl implements _CommunityQuestionnaire {
  const _$CommunityQuestionnaireImpl(
      {required this.id,
      required this.communityId,
      required this.ownerId,
      final List<QuestionItem> questions = const [],
      required this.createdAt,
      required this.updatedAt})
      : _questions = questions;

  factory _$CommunityQuestionnaireImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommunityQuestionnaireImplFromJson(json);

  @override
  final String id;
  @override
  final String communityId;
  @override
  final String ownerId;
  final List<QuestionItem> _questions;
  @override
  @JsonKey()
  List<QuestionItem> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

// 1-5 questions
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'CommunityQuestionnaire(id: $id, communityId: $communityId, ownerId: $ownerId, questions: $questions, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityQuestionnaireImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.communityId, communityId) ||
                other.communityId == communityId) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            const DeepCollectionEquality()
                .equals(other._questions, _questions) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, communityId, ownerId,
      const DeepCollectionEquality().hash(_questions), createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunityQuestionnaireImplCopyWith<_$CommunityQuestionnaireImpl>
      get copyWith => __$$CommunityQuestionnaireImplCopyWithImpl<
          _$CommunityQuestionnaireImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommunityQuestionnaireImplToJson(
      this,
    );
  }
}

abstract class _CommunityQuestionnaire implements CommunityQuestionnaire {
  const factory _CommunityQuestionnaire(
      {required final String id,
      required final String communityId,
      required final String ownerId,
      final List<QuestionItem> questions,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$CommunityQuestionnaireImpl;

  factory _CommunityQuestionnaire.fromJson(Map<String, dynamic> json) =
      _$CommunityQuestionnaireImpl.fromJson;

  @override
  String get id;
  @override
  String get communityId;
  @override
  String get ownerId;
  @override
  List<QuestionItem> get questions;
  @override // 1-5 questions
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$CommunityQuestionnaireImplCopyWith<_$CommunityQuestionnaireImpl>
      get copyWith => throw _privateConstructorUsedError;
}
