import 'package:flutter/material.dart';
import '../models/show.dart';
import '../services/show_service.dart';
import 'package:camera_block_app/screens/select_show_screen.dart';

class ShowScreen extends StatefulWidget {
  const ShowScreen({super.key});

  @override
  State<ShowScreen> createState() => _ShowScreenState();
}

class _ShowScreenState extends State<ShowScreen> {
  late Future<List<Show>> _showsFuture;

  @override
  void initState() {
    super.initState();
    _showsFuture = ShowService.fetchShows();
  }

  void _navigateToSelectShowScreen(Show show) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => SelectShowScreen(show: show)),
    );
    Navigator.pop(context, result);
  }

  void _onShowSelected(Show show) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${show.name} 선택됨')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('공연 선택'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: FutureBuilder<List<Show>>(
        future: _showsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '에러 발생: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('공연 정보가 없습니다.'));
          }

          final shows = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: shows.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final show = shows[index];
              return GestureDetector(
                onTap: () {
                  _onShowSelected(show);
                  _navigateToSelectShowScreen(show);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        show.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            show.date,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${show.startTime} ~ ${show.endTime}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import '../models/show.dart';
import '../services/show_service.dart';
import 'package:camera_block_app/screens/select_show_screen.dart';

class ShowScreen extends StatefulWidget {
  const ShowScreen({super.key});

  @override
  State<ShowScreen> createState() => _ShowScreenState();
}

class _ShowScreenState extends State<ShowScreen> {
  late Future<List<Show>> _showsFuture;

  @override
  void initState() {
    super.initState();
    _showsFuture = ShowService.fetchShows();
  }

  void _navigateToSelectShowScreen() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const SelectShowScreen()),
    );

    // 카메라 차단 결과를 HomeScreen으로 전달
    Navigator.pop(context, result);
  }

  void _onShowSelected(Show show) {
    // 공연 선택 후 처리 로직 (예: Navigator.pop 또는 다음 화면 이동)
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${show.name} 선택됨')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('공연 선택')),
      body: FutureBuilder<List<Show>>(
        future: _showsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('에러: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('공연 정보가 없습니다.'));
          }

          final shows = snapshot.data!;
          return ListView.builder(
            itemCount: shows.length,
            itemBuilder: (context, index) {
              final show = shows[index];
              return ListTile(
                title: Text(show.name),
                subtitle: Text(
                  '${show.date} | ${show.startTime} ~ ${show.endTime}',
                ),
                onTap: () {
                  _onShowSelected(show);
                  _navigateToSelectShowScreen();
                },
              );
            },
          );
        },
      ),
    );
  }
}*/
