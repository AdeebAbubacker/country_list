part of 'getcountry_list_bloc.dart';

@freezed
class GetcountryListEvent with _$GetcountryListEvent {
  const factory GetcountryListEvent.started() = _Started;
  const factory GetcountryListEvent.fetchAllQuestionBank() =
      _FetchAllQuestionBankEvent;
}
