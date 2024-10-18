import 'package:antlabs_assignment/main.dart';
import 'package:antlabs_assignment/ticket%20model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class TicketListPage extends StatelessWidget {
  const TicketListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userRole = authProvider.userRole;

    // Get tickets filtered by the current user (for customers) or all tickets (for support/admin)
    final tickets = authProvider.getTicketsForUser();

    
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Tickets'),
        backgroundColor: Colors.transparent,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          return Card(
            color: Colors.blue[200],
            shadowColor: Colors.grey,
            margin: EdgeInsets.symmetric(
              vertical: screenHeight * 0.01, // Dynamic vertical margin
              horizontal: screenWidth * 0.05, // Dynamic horizontal margin
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              title: Text(
                ticket.title,
                style: TextStyle(fontSize: screenWidth * 0.05), // Dynamic font size
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status: ${ticket.status}',
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                  if (ticket.notes.isNotEmpty)
                    Text(
                      'Notes: ${ticket.notes.join(", ")}',
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, '/ticketDetail', arguments: ticket);
              },
            ),
          );
        },
      ),
    );
  }
}



class TicketDetailPage extends StatefulWidget {
  const TicketDetailPage({super.key});

  @override
  _TicketDetailPageState createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  final TextEditingController noteController = TextEditingController();
  final TextEditingController replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userRole = authProvider.userRole;
    final Ticket ticket = ModalRoute.of(context)?.settings.arguments as Ticket;

    // Get screen dimensions for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 1,
        title: const Text('Ticket Detail'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, // Dynamic padding
            vertical: screenHeight * 0.03,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.03),
              Text(
                'Ticket Title: ${ticket.title}',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Ticket Description: ${ticket.description}',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: screenHeight * 0.04),

              // Admin delete button for each ticket
              if (userRole == 'admin') ...[
                ElevatedButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete Ticket'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[300],
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.02,
                    ),
                  ),
                  onPressed: () {
                    // Confirm deletion before deleting the ticket
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Delete Ticket'),
                          content: const Text(
                              'Are you sure you want to delete this ticket?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                
                                deleteTicket(ticket); 
                                Navigator.of(context).pop(); 
                                Navigator.of(context).pop(); 
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],

              SizedBox(height: screenHeight * 0.03),

              // Customer view - Add notes
              if (userRole == 'customer') ...[
                TextField(
                  controller: noteController,
                  decoration: InputDecoration(
                    labelText: 'Add Note',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                GestureDetector(
                  onTap: () {
                    if (noteController.text.isNotEmpty) {
                      setState(() {
                        // Add the note to the ticket's notes list
                        ticket.notes.add(noteController.text);
                        noteController.clear();
                      });
                      authProvider.notifyListeners(); // Notify provider of change
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: screenHeight * 0.06, // Dynamic height
                    width: screenWidth * 0.5, // Dynamic width
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blue[700],
                    ),
                    child: Text(
                      'Submit Note',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],

              SizedBox(height: screenHeight * 0.04),

              // Display the notes added by the customer
              if (ticket.notes.isNotEmpty) ...[
                const Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
                for (String note in ticket.notes)
                  ListTile(
                    title: Text(
                      note,
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                    leading: const Icon(Icons.note),
                  ),
              ],

              // Support agent dropdown to update status
              if (userRole == 'support' || userRole == "admin") ...[
                DropdownButton<String>(
                  items: ['Pending', 'Active', 'Closed'].map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status, style: TextStyle(fontSize: screenWidth * 0.04)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      ticket.status = newValue!;
                    });
                    authProvider.notifyListeners(); 
                  },
                  hint: const Text('Update Status'),
                  value: ticket.status,
                ),

                SizedBox(height: screenHeight * 0.03),

                // Support agent reply text field and button
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: replyController,
                        decoration: InputDecoration(
                          labelText: 'Reply',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    FloatingActionButton(
                      onPressed: () {
                        if (replyController.text.isNotEmpty) {
                          setState(() {
                            ticket.reply = replyController.text; 
                            replyController.clear();
                          });
                          authProvider.notifyListeners(); 
                        }
                      },
                      backgroundColor: Colors.blue[400],
                      child: const Icon(Icons.send_rounded),
                    ),
                  ],
                ),
              ],

              SizedBox(height: screenHeight * 0.03),

              // Display the support agent's reply if available (for customers and admins)
              if ((userRole == 'customer' || userRole == 'admin') && (ticket.reply.isNotEmpty)) ...[
                const Text('Support Reply:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(ticket.reply, style: TextStyle(fontSize: screenWidth * 0.045)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void deleteTicket(Ticket ticket) {
    final ticketProvider = Provider.of<AuthProvider>(context, listen: false);
    ticketProvider.removeTicket(ticket); // Remove the ticket
  }
}
