class Planeta {
  final String id;
  final String nome;
  final String descricao;
  final String image_url;

  Planeta({this.id, this.nome, this.descricao, this.image_url});

  Planeta.fromJson(Map<String, dynamic> json) : this(
    id: json['id'],
    nome: json['nome'],
    descricao: json['descricao'],
    image_url: json['image_url']
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'image_url': image_url
    };
  }
}
