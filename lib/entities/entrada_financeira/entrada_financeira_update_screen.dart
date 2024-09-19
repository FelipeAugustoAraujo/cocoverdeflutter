import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cocoverde/entities/entrada_financeira/bloc/entrada_financeira_bloc.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:cocoverde/shared/repository/http_utils.dart';
import 'package:cocoverde/entities/entrada_financeira/entrada_financeira_model.dart';
import 'entrada_financeira_route.dart';
import 'package:time_machine/time_machine.dart';

class EntradaFinanceiraUpdateScreen extends StatelessWidget {
  EntradaFinanceiraUpdateScreen({Key? key}) : super(key: EntradaFinanceiraRoutes.editScreenKey);

  @override
  Widget build(BuildContext context) {
    return BlocListener<EntradaFinanceiraBloc, EntradaFinanceiraState>(
      listener: (context, state) {
        if(state.formStatus.isSuccess){
          Navigator.pushNamed(context, EntradaFinanceiraRoutes.list);
        }
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: BlocBuilder<EntradaFinanceiraBloc, EntradaFinanceiraState>(
                buildWhen: (previous, current) => previous.editMode != current.editMode,
                builder: (context, state) {
                String title = state.editMode == true ?'Edit EntradaFinanceiras':
'Create EntradaFinanceiras';
                 return Text(title);
                }
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(15.0),
            child: Column(children: <Widget>[settingsForm(context)]),
          ),
      ),
    );
  }

  Widget settingsForm(BuildContext context) {
    return Form(
      child: Wrap(runSpacing: 15, children: <Widget>[
          dataField(),
          valorTotalField(),
          descricaoField(),
          metodoPagamentoField(),
          statusPagamentoField(),
          responsavelPagamentoField(),
        validationZone(),
        submit(context)
      ]),
    );
  }

      Widget dataField() {
        return BlocBuilder<EntradaFinanceiraBloc, EntradaFinanceiraState>(
            buildWhen: (previous, current) => previous.data != current.data,
            builder: (context, state) {
              return DateTimeField(
                controller: context.read<EntradaFinanceiraBloc>().dataController,
                onChanged: (value) { context.read<EntradaFinanceiraBloc>().add(DataChanged(data: Instant.dateTime(value!))); },
                format: DateFormat.yMMMMd('en'),
                keyboardType: TextInputType.datetime,
            decoration: InputDecoration(labelText:'data',),
                onShowPicker: (context, currentValue) {
                  return showDatePicker(
                      locale: Locale('en'),
                      context: context,
                      firstDate: DateTime(1950),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2050));
                },
              );
            }
        );
      }
      Widget valorTotalField() {
        return BlocBuilder<EntradaFinanceiraBloc, EntradaFinanceiraState>(
            buildWhen: (previous, current) => previous.valorTotal != current.valorTotal,
            builder: (context, state) {
              return TextFormField(
                  controller: context.read<EntradaFinanceiraBloc>().valorTotalController,
                  onChanged: (value) { context.read<EntradaFinanceiraBloc>()
                    .add(ValorTotalChanged(valorTotal:value)); },
                  keyboardType:TextInputType.text,                  decoration: InputDecoration(
                      labelText:'valorTotal'));
            }
        );
      }
      Widget descricaoField() {
        return BlocBuilder<EntradaFinanceiraBloc, EntradaFinanceiraState>(
            buildWhen: (previous, current) => previous.descricao != current.descricao,
            builder: (context, state) {
              return TextFormField(
                  controller: context.read<EntradaFinanceiraBloc>().descricaoController,
                  onChanged: (value) { context.read<EntradaFinanceiraBloc>()
                    .add(DescricaoChanged(descricao:value)); },
                  keyboardType:TextInputType.text,                  decoration: InputDecoration(
                      labelText:'descricao'));
            }
        );
      }
      Widget metodoPagamentoField() {
        return BlocBuilder<EntradaFinanceiraBloc,EntradaFinanceiraState>(
            buildWhen: (previous, current) => previous.metodoPagamento != current.metodoPagamento,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('metodoPagamento', style: Theme.of(context).textTheme.bodyText1,),
                    DropdownButton<MetodoPagamento>(
                        value: state.metodoPagamento.value,
                        onChanged: (value) { context.read<EntradaFinanceiraBloc>().add(MetodoPagamentoChanged(metodoPagamento: value!)); },
                        items: createDropdownMetodoPagamentoItems(MetodoPagamento.values)),
                  ],
                ),
              );
            });
      }
      Widget statusPagamentoField() {
        return BlocBuilder<EntradaFinanceiraBloc,EntradaFinanceiraState>(
            buildWhen: (previous, current) => previous.statusPagamento != current.statusPagamento,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('statusPagamento', style: Theme.of(context).textTheme.bodyText1,),
                    DropdownButton<StatusPagamento>(
                        value: state.statusPagamento.value,
                        onChanged: (value) { context.read<EntradaFinanceiraBloc>().add(StatusPagamentoChanged(statusPagamento: value!)); },
                        items: createDropdownStatusPagamentoItems(StatusPagamento.values)),
                  ],
                ),
              );
            });
      }
      Widget responsavelPagamentoField() {
        return BlocBuilder<EntradaFinanceiraBloc,EntradaFinanceiraState>(
            buildWhen: (previous, current) => previous.responsavelPagamento != current.responsavelPagamento,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('responsavelPagamento', style: Theme.of(context).textTheme.bodyText1,),
                    DropdownButton<ResponsavelPagamento>(
                        value: state.responsavelPagamento.value,
                        onChanged: (value) { context.read<EntradaFinanceiraBloc>().add(ResponsavelPagamentoChanged(responsavelPagamento: value!)); },
                        items: createDropdownResponsavelPagamentoItems(ResponsavelPagamento.values)),
                  ],
                ),
              );
            });
      }

      List<DropdownMenuItem<MetodoPagamento>> createDropdownMetodoPagamentoItems(List<MetodoPagamento> metodoPagamentos) {
        List<DropdownMenuItem<MetodoPagamento>> metodoPagamentoDropDown = [];

        for (MetodoPagamento metodoPagamento in metodoPagamentos) {
          DropdownMenuItem<MetodoPagamento> dropdown = DropdownMenuItem<MetodoPagamento>(
              value: metodoPagamento, child: Text(metodoPagamento.toString()));
              metodoPagamentoDropDown.add(dropdown);
        }

        return metodoPagamentoDropDown;
      }
      List<DropdownMenuItem<StatusPagamento>> createDropdownStatusPagamentoItems(List<StatusPagamento> statusPagamentos) {
        List<DropdownMenuItem<StatusPagamento>> statusPagamentoDropDown = [];

        for (StatusPagamento statusPagamento in statusPagamentos) {
          DropdownMenuItem<StatusPagamento> dropdown = DropdownMenuItem<StatusPagamento>(
              value: statusPagamento, child: Text(statusPagamento.toString()));
              statusPagamentoDropDown.add(dropdown);
        }

        return statusPagamentoDropDown;
      }
      List<DropdownMenuItem<ResponsavelPagamento>> createDropdownResponsavelPagamentoItems(List<ResponsavelPagamento> responsavelPagamentos) {
        List<DropdownMenuItem<ResponsavelPagamento>> responsavelPagamentoDropDown = [];

        for (ResponsavelPagamento responsavelPagamento in responsavelPagamentos) {
          DropdownMenuItem<ResponsavelPagamento> dropdown = DropdownMenuItem<ResponsavelPagamento>(
              value: responsavelPagamento, child: Text(responsavelPagamento.toString()));
              responsavelPagamentoDropDown.add(dropdown);
        }

        return responsavelPagamentoDropDown;
      }

  Widget validationZone() {
    return BlocBuilder<EntradaFinanceiraBloc, EntradaFinanceiraState>(
        buildWhen:(previous, current) => previous.formStatus != current.formStatus,
        builder: (context, state) {
          return Visibility(
              visible: state.formStatus.isFailure ||  state.formStatus.isSuccess,
              child: Center(
                child: generateNotificationText(state, context),
              ));
        });
  }

  Widget generateNotificationText(EntradaFinanceiraState state, BuildContext context) {
    String notificationTranslated = '';
    Color? notificationColors;

    if (state.generalNotificationKey.toString().compareTo(HttpUtils.errorServerKey) == 0) {
      notificationTranslated ='Something wrong when calling the server, please try again';
      notificationColors = Theme.of(context).errorColor;
    } else if (state.generalNotificationKey.toString().compareTo(HttpUtils.badRequestServerKey) == 0) {
      notificationTranslated ='Something wrong happened with the received data';
      notificationColors = Theme.of(context).errorColor;
    }

    return Text(
      notificationTranslated,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
          color: notificationColors),
    );
  }

  submit(BuildContext context) {
    return BlocBuilder<EntradaFinanceiraBloc, EntradaFinanceiraState>(
        buildWhen: (previous, current) => previous.isValid != current.isValid,
        builder: (context, state) {
          String buttonLabel = state.editMode == true ?
'Edit':
'Create';
          return ElevatedButton(
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Visibility(
                    replacement: CircularProgressIndicator(value: null),
                    visible: !state.formStatus.isInProgress,
                    child: Text(buttonLabel),
                  ),
                )),
            onPressed: state.isValid ? () => context.read<EntradaFinanceiraBloc>().add(EntradaFinanceiraFormSubmitted()) : null,
          );
        }
    );
  }
}
