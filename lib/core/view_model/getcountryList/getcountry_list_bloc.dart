import 'package:bloc/bloc.dart';
import 'package:country_app/core/model/country/country.dart';
import 'package:country_app/core/service/home_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'getcountry_list_event.dart';
part 'getcountry_list_state.dart';
part 'getcountry_list_bloc.freezed.dart';

class GetcountryListBloc
    extends Bloc<GetcountryListEvent, GetcountryListState> {
  GetcountryListBloc() : super(const _Initial()) {
    on<_FetchAllQuestionBankEvent>((event, emit) async {
      emit(const GetcountryListState.loading());

      try {
        final result = await ApiService().fetchCountries();

        await result.fold((failure) async {
          if (failure == 0) {
            emit(const GetcountryListState.noInternet());
          } else {
            emit(GetcountryListState.error(
                error: 'An error occurred: $failure'));
          }
        }, (success) async {
          emit(GetcountryListState.createdQuestionBank(questionBank: success));
        });
      } catch (e) {
        emit(GetcountryListState.error(error: 'An error occurred: $e'));
      }
    });
  }
}
