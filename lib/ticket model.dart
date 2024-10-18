class Ticket {
  String title;
  String description;
  String status;
  String createdBy;
  List<String> notes;
  String reply; // Add a reply field for the support agent

  Ticket({
    required this.title,
    required this.description,
    this.status = 'Pending',
    required this.createdBy,
    this.notes = const [],
    this.reply = '', // Initialize as an empty string
  });
}
