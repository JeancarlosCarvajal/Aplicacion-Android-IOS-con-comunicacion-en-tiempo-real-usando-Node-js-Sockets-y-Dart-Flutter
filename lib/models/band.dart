


class Band {

  late String id;

  late String name;

  late int? votes;

  Band({
    required this.id,
    required this.name,
    this.votes
  });


  // Nueva instancia de la clase banda
  factory Band.fromMap(Map<String, dynamic> obj)
    => Band(
      id: obj.containsKey('id') ? obj['id'] : 'no-id',
      name: obj.containsKey('name') ? obj['name'] : 'no-name',
      votes: obj.containsKey('votes') ? obj['votes'] : 'no-votes'
    );
 
}