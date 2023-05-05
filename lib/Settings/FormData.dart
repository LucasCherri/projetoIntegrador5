import '../flutter_flow/form_field_controller.dart';

class FormEndereco {
  final String rua;
  final String bairro;
  final String cep;
  final String numero;
  final String uf;
  final String cidade;

  FormEndereco({
    required this.rua,
    required this.bairro,
    required this.cep,
    required this.numero,
    required this.uf,
    required this.cidade,
  });
}

class FormTipo {
  final String titulo;
  final String tipo;
  final String tamanho;

  FormTipo({
    required this.titulo,
    required this.tipo,
    required this.tamanho,
  });
}

class FormCaracteristicas {
  final bool switchMobilias;
  final List<String> mobilias;
  final bool switchQuartos;
  final String numeroQuartos;
  final bool switchBanheiros;
  final String numeroBanheiros;
  final bool switchVagas;
  final String numeroVagas;
  final bool switchPets;

  FormCaracteristicas({
    required this.switchMobilias,
    required this.mobilias,
    required this.switchQuartos,
    required this.numeroQuartos,
    required this.switchBanheiros,
    required this.numeroBanheiros,
    required this.switchVagas,
    required this.numeroVagas,
    required this.switchPets,
  });
}

class FormValores {
  final String negocio;
  final String valor;
  final bool switchValorCond;
  final String valorCond;
  final bool switchValorIPTU;
  final String valorIPTU;
  final bool switchValorSeguro;
  final String valorSeguro;

  FormValores({
    required this.negocio,
    required this.valor,
    required this.switchValorCond,
    required this.valorCond,
    required this.switchValorIPTU,
    required this.valorIPTU,
    required this.switchValorSeguro,
    required this.valorSeguro,
  });
}