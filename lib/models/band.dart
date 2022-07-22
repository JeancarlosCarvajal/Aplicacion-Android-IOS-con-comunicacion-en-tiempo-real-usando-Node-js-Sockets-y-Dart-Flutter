


class Band {

  late String id;

  late String name;

  late int votes;

  Band({
    required this.id,
    required this.name,
    required this.votes
  });


  // Nueva instancia de la clase banda
  factory Band.fromMap(Map<String, dynamic> obj) 
    => Band(
      id: obj['id'],
      name: obj['naame'],
      votes: obj['votes']
    );






}