import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

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
          child: SingleChildScrollView(
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
                _buildSummaryCards(),
                const SizedBox(height: 28),

                // --- Pie Chart ---
                _buildPieChartCard(),
                const SizedBox(height: 28),

                // --- Bar Chart ---
                _buildBarChartCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _modernCard(
            child: Column(
              children: [
                Text('15',
                    style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 6),
                Text('Weekly Entries',
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
                const Text('😊', style: TextStyle(fontSize: 32)),
                const SizedBox(height: 6),
                Text('Frequent Mood',
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: Colors.white70)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPieChartCard() {
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
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                      value: 40, color: Colors.green, title: '40%', radius: 50),
                  PieChartSectionData(
                      value: 30, color: Colors.blue, title: '30%', radius: 50),
                  PieChartSectionData(
                      value: 15, color: Colors.red, title: '15%', radius: 50),
                  PieChartSectionData(
                      value: 15, color: Colors.grey, title: '15%', radius: 50),
                ],
                centerSpaceRadius: 45,
                sectionsSpace: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChartCard() {
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
                barGroups: [
                  _makeBar(0, 5),
                  _makeBar(1, 3),
                  _makeBar(2, 7),
                  _makeBar(3, 4),
                  _makeBar(4, 6),
                  _makeBar(5, 2),
                  _makeBar(6, 1),
                ],
                gridData: FlGridData(show: false),
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
                        return Text(
                          value.toInt() < labels.length ? labels[value.toInt()] : '',
                          style: style,
                        );
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
          colors: [Colors.deepPurple.withAlpha(153), Colors.black.withAlpha(153)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(77),
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
