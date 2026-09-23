class Produto {
  int? id;
  String nome;
  String descricao;
  String categoria;
  double valor;

  Produto({
    this.id,
    required this.nome,
    required this.descricao,
    required this.categoria,
    required this.valor,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'categoria': categoria,
      'valor': valor,
    };
  }

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'],
      categoria: map['categoria'],
      valor: map['valor'],
    );
  }
}