import 'package:flutter/material.dart';
import '../services/api_services.dart';
import '../models/analytics.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  late Future<Analytics> _analyticsFuture;

  @override
  void initState() {
    super.initState();
    _analyticsFuture = ApiService().getAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: FutureBuilder<Analytics>(
        future: _analyticsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data'));
          } else {
            final analytics = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildStatCard('Total Books', analytics.totalBooks),
                  _buildStatCard('Reading', analytics.readingBooks),
                  _buildStatCard('Completed', analytics.completedBooks),
                  _buildStatCard('Unread', analytics.unreadBooks),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildStatCard(String label, int value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 18)),
            Text(value.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}