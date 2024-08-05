import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rubidya/resources/color.dart';
import 'package:rubidya/services/home_service.dart';
import 'package:rubidya/support/logger.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  List<dynamic> activityNotifications = [];
  List<dynamic> referralNotifications = [];
  bool isLoading = true;
  bool _isFetchingMoreActivity = false;
  bool _isFetchingMoreReferral = false;
  int _activityPage = 1;
  int _referralPage = 1;
  bool _isLastPageActivity = false;
  bool _isLastPageReferral = false;
  final ScrollController _activityScrollController = ScrollController();
  final ScrollController _referralScrollController = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchActivityNotifications();
    _fetchReferralNotifications();
    _activityScrollController.addListener(_activityScrollListener);
    _referralScrollController.addListener(_referralScrollListener);
  }

  @override
  void dispose() {
    _activityScrollController.dispose();
    _referralScrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _activityScrollListener() {
    if (_activityScrollController.position.pixels ==
        _activityScrollController.position.maxScrollExtent &&
        !_isFetchingMoreActivity &&
        !_isLastPageActivity) {
      _fetchActivityNotifications();
    }
  }

  void _referralScrollListener() {
    if (_referralScrollController.position.pixels ==
        _referralScrollController.position.maxScrollExtent &&
        !_isFetchingMoreReferral &&
        !_isLastPageReferral) {
      _fetchReferralNotifications();
    }
  }

  Future<void> _fetchActivityNotifications({bool reset = false}) async {
    if (_isFetchingMoreActivity) return;
    if (reset) {
      setState(() {
        _activityPage = 1;
        _isLastPageActivity = false;
        activityNotifications.clear();
      });
    }
    if (_isLastPageActivity) return;

    setState(() {
      _isFetchingMoreActivity = true;
    });

    try {
      var response = await HomeService.getActivityNotification(
          page: _activityPage, limit: 10);
      log.i('Activity API Request: page $_activityPage');
      log.i('Activity API Response: $response');

      if (response['notifications'] != null &&
          response['notifications'].isNotEmpty) {
        setState(() {
          activityNotifications.addAll(response['notifications']);
          if (response['notifications'].length < 10) {
            _isLastPageActivity = true;
          }
          _activityPage++;
        });
      } else {
        setState(() {
          _isLastPageActivity = true;
        });
      }
    } catch (e) {
      log.e('Failed to fetch activity notifications: $e');
    } finally {
      setState(() {
        isLoading = false;
        _isFetchingMoreActivity = false;
      });
    }
  }

  Future<void> _fetchReferralNotifications({bool reset = false}) async {
    if (_isFetchingMoreReferral) return;
    if (reset) {
      setState(() {
        _referralPage = 1;
        _isLastPageReferral = false;
        referralNotifications.clear();
      });
    }
    if (_isLastPageReferral) return;

    setState(() {
      _isFetchingMoreReferral = true;
    });

    try {
      var response = await HomeService.getReferalNotification(
          page: _referralPage, limit: 10);
      log.i('Referral API Request: page $_referralPage');
      log.i('Referral API Response: $response');

      if (response['notifications'] != null &&
          response['notifications'].isNotEmpty) {
        setState(() {
          referralNotifications.addAll(response['notifications']);
          if (response['notifications'].length < 10) {
            _isLastPageReferral = true;
          }
          _referralPage++;
        });
      } else {
        setState(() {
          _isLastPageReferral = true;
        });
      }
    } catch (e) {
      log.e('Failed to fetch referral notifications: $e');
    } finally {
      setState(() {
        isLoading = false;
        _isFetchingMoreReferral = false;
      });
    }
  }

  String formatTime(String dateTime) {
    DateTime time = DateTime.parse(dateTime).toLocal(); // Convert to local time
    return DateFormat.yMMMd().add_jm().format(time); // Format the time
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Notifications",
          style: TextStyle(fontSize: 14),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Activity Notifications'),
            Tab(text: 'Referral Notifications'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          isLoading
              ? Center(child: CircularProgressIndicator())
              : activityNotifications.isEmpty
              ? Center(child: Text("No activity notifications available"))
              : NotificationListView(
            notifications: activityNotifications,
            isLoadingMore: _isFetchingMoreActivity,
            formatTime: formatTime,
            scrollController: _activityScrollController,
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : referralNotifications.isEmpty
              ? Center(child: Text("No referral notifications available"))
              : NotificationListView(
            notifications: referralNotifications,
            isLoadingMore: _isFetchingMoreReferral,
            formatTime: formatTime,
            scrollController: _referralScrollController,
          ),
        ],
      ),
    );
  }
}

class NotificationListView extends StatelessWidget {
  final List<dynamic> notifications;
  final bool isLoadingMore;
  final Function(String) formatTime;
  final ScrollController scrollController;

  NotificationListView({
    required this.notifications,
    required this.isLoadingMore,
    required this.formatTime,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length + (isLoadingMore ? 1 : 0),
      controller: scrollController,
      itemBuilder: (context, index) {
        if (index < notifications.length) {
          var notification = notifications[index];
          return Card(
            color: bluetext,
            child: ListTile(
              leading: notification['profilePic'] != null
                  ? CircleAvatar(
                backgroundImage: NetworkImage(notification['profilePic']),
              )
                  : CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(
                notification['user'],
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                notification['message'],
                style: TextStyle(color: Colors.white),
              ),
              trailing: Text(
                formatTime(notification['time']),
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
