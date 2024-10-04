part of 'getcountry_list_bloc.dart';

@freezed
class GetcountryListState with _$GetcountryListState {
  const factory GetcountryListState.initial() = _Initial;
  const factory GetcountryListState.loading() = _Loading;
  const factory GetcountryListState.noInternet() = _NoInternet;
  const factory GetcountryListState.createdQuestionBank(
      {required List<Country> questionBank}) = _CreatedQuestionBank;
  const factory GetcountryListState.error({required String error}) =
      _QuestionBankFailure;
}
