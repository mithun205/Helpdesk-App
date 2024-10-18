import 'package:antlabs_assignment/Create_ticket.dart';
import 'package:antlabs_assignment/dashboard.dart';
import 'package:antlabs_assignment/loginpage.dart';
import 'package:antlabs_assignment/ticket%20model.dart';
import 'package:antlabs_assignment/ticketList.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(TicketManagementApp());
}

class TicketManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'Ticket Management System',
        debugShowCheckedModeBanner: false,
        // theme: ThemeData.light(),
        // darkTheme: ThemeData.dark(),
        // themeMode: ThemeMode.system,
          
        home: LoginPage(),
        routes: {
          // '/register': (context) => RegisterPage(),
          '/dashboard': (context) => DashboardPage(),
          '/ticketList': (context) => TicketListPage(),
          '/ticketDetail': (context) => TicketDetailPage(),
          //'/userManagement': (context) => UserManagementPage(),
          '/createTicket': (context) => CreateTicketPage(),
        },
      ),
    );
  }
}

class AuthProvider with ChangeNotifier {
  String? userRole;
  String? userEmail;
  List<Ticket> tickets = [];
  int get ticketCount => tickets.length; // Get the count of tickets
 // List to store tickets

  void login(String email, String role) {
    userEmail = email;
    userRole = role;
    notifyListeners();
  }

  void logout() {
    userEmail = null;
    userRole = null;
    notifyListeners();
  }

  void addTicket(String title, String description) {
    if (userEmail != null) {
      tickets.add(Ticket(
        title: title,
        description: description,
        createdBy: userEmail!,
      ));
      notifyListeners();
    }
  }

  List<Ticket> getTicketsForUser() {
    if (userRole == 'customer' && userEmail != null) {
      return tickets.where((ticket) => ticket.createdBy == userEmail).toList();
    }
    return tickets;
  }

   void removeTicket(Ticket ticket) {
    tickets.remove(ticket);
    notifyListeners();
  }
}
