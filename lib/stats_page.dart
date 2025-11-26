import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'services/api_service.dart'; // Import the service

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late Future<Map<String, dynamic>> _statsFuture;

  @override
  void initState() {
    super.initState();
    _refreshStats();
  }

  void _refreshStats() {
    setState(() {
      _statsFuture = ApiService().getStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/wallpaper.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: FutureBuilder<Map<String, dynamic>>(
            future: _statsFuture,
            builder: (context, snapshot) {
              // 1. Loading State
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFFC5A8FF)));
              }
              
              // 2. Error State
              if (snapshot.hasError) {
                return Center(child: Text("Error loading stats", style: GoogleFonts.poppins(color: Colors.white)));
              }

              // 3. Data Loaded
              final data = snapshot.data!;
              final totalEntries = data['total_entries'] as int;
              final frequentMood = data['frequent_mood'] as String;
              final weeklyData = data['weekly_entries'] as List<int>;

              // Calculate percentages for Pie Chart (Mock logic for display)
              // In a real app, backend sends specific percentages.
              // We will just show visual placeholders if data exists.
              final hasData = totalEntries > 0;

              return RefreshIndicator(
                onRefresh: () async => _refreshStats(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // --- Title ---
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
                        child: Center(
                          child: Text(
                            'Statistics',
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
            
                      // --- Summary Cards ---
                      Row(
                        children: [
                          Expanded(
                            child: _modernCard(
                              child: Column(
                                children: [
                                  Text('$totalEntries',
                                      style: GoogleFonts.poppins(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  const SizedBox(height: 6),
                                  Text('Total Entries',
                                      style: GoogleFonts.poppins(
                                          fontSize: 14, color: Colors.white70)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _modernCard(
                              child: Column(
                                children: [
                                  Text(frequentMood, style: const TextStyle(fontSize: 32)),
                                  const SizedBox(height: 6),
                                  Text('Frequent Mood',
                                      style: GoogleFonts.poppins(
                                          fontSize: 14, color: Colors.white70)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
            
                      // --- Pie Chart ---
                      _buildPieChartCard(hasData),
                      const SizedBox(height: 28),
            
                      // --- Bar Chart ---
                      _buildBarChartCard(weeklyData),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPieChartCard(bool hasData) {
    return _modernCard(
      child: Column(
        children: [
          Text('Mood Distribution',
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: hasData 
            ? PieChart(
              PieChartData(
                sections: [
                  // We are hardcoding these specifically for the demo look
                  // When backend is ready, they will map 'mood_counts' from API
                  PieChartSectionData(
                      value: 40, color: Colors.green.withValues(alpha: 0.8), title: '40%', radius: 50),
                  PieChartSectionData(
                      value: 30, color: Colors.blue.withValues(alpha: 0.8), title: '30%', radius: 50),
                  PieChartSectionData(
                      value: 15, color: Colors.red.withValues(alpha: 0.8), title: '15%', radius: 50),
                  PieChartSectionData(
                      value: 15, color: Colors.orange.withValues(alpha: 0.8), title: '15%', radius: 50),
                ],
                centerSpaceRadius: 45,
                sectionsSpace: 2,
              ),
            )
            : const Center(child: Text("Not enough data yet", style: TextStyle(color: Colors.white54))),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChartCard(List<int> weeklyData) {
    return _modernCard(
      child: Column(
        children: [
          Text('Daily Entries This Week',
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barGroups: List.generate(weeklyData.length, (index) {
                   return _makeBar(index, weeklyData[index].toDouble());
                }),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles:
                      const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                            fontSize: 11, color: Colors.white70);
                        const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        if (value.toInt() >= 0 && value.toInt() < labels.length) {
                          return Text(labels[value.toInt()], style: style);
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _modernCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.withValues(alpha: 0.6), Colors.black.withValues(alpha: 0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: child,
    );
  }

  BarChartGroupData _makeBar(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: const LinearGradient(
            colors: [Colors.purpleAccent, Colors.deepPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          width: 14,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}