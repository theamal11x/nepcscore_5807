import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MatchDetailsStepWidget extends StatefulWidget {
  final Map<String, dynamic> matchData;
  final Function(String, dynamic) onDataChanged;

  const MatchDetailsStepWidget({
    super.key,
    required this.matchData,
    required this.onDataChanged,
  });

  @override
  State<MatchDetailsStepWidget> createState() => _MatchDetailsStepWidgetState();
}

class _MatchDetailsStepWidgetState extends State<MatchDetailsStepWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();

  bool _useNepaliCalendar = false;
  String _selectedFormat = 'T20';

  final List<String> _matchFormats = ['T20', 'ODI', 'Test'];

  final List<Map<String, dynamic>> _suggestedVenues = [
    {
      'name': 'Tribhuvan University Cricket Ground',
      'location': 'Kirtipur, Kathmandu',
      'distance': '2.5 km',
      'image':
          'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?w=300&h=200&fit=crop',
    },
    {
      'name': 'Mulpani Cricket Ground',
      'location': 'Mulpani, Kathmandu',
      'distance': '5.2 km',
      'image':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300&h=200&fit=crop',
    },
    {
      'name': 'Pokhara Stadium',
      'location': 'Pokhara, Gandaki',
      'distance': '12.8 km',
      'image':
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=300&h=200&fit=crop',
    },
  ];

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.matchData['title'] ?? '';
    _venueController.text = widget.matchData['venue'] ?? '';
    _selectedFormat = widget.matchData['format'] ?? 'T20';
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: widget.matchData['date'] ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        builder: (context, child) {
          return DatePickerTheme(
              data: DatePickerThemeData(
                  backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                  headerBackgroundColor:
                      AppTheme.lightTheme.colorScheme.primary,
                  headerForegroundColor:
                      AppTheme.lightTheme.colorScheme.onPrimary),
              child: child!);
        });

    if (picked != null) {
      widget.onDataChanged('date', picked);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: widget.matchData['time'] ?? TimeOfDay.now());

    if (picked != null) {
      widget.onDataChanged('time', picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Match Details',
              style: AppTheme.lightTheme.textTheme.headlineSmall),
          SizedBox(height: 1.h),
          Text('Enter the basic information about your match',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7))),
          SizedBox(height: 3.h),

          // Match Title
          Text('Match Title *',
              style: AppTheme.lightTheme.textTheme.titleMedium),
          SizedBox(height: 1.h),
          TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                  hintText: 'e.g., Kathmandu Kings vs Pokhara Warriors',
                  prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                          iconName: 'sports_cricket',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20))),
              onChanged: (value) => widget.onDataChanged('title', value)),
          SizedBox(height: 3.h),

          // Date and Time
          Row(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Date *',
                      style: AppTheme.lightTheme.textTheme.titleMedium),
                  SizedBox(height: 1.h),
                  InkWell(
                      onTap: _selectDate,
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 3.h),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      AppTheme.lightTheme.colorScheme.outline),
                              borderRadius: BorderRadius.circular(8),
                              color: AppTheme.lightTheme.colorScheme.surface),
                          child: Row(children: [
                            CustomIconWidget(
                                iconName: 'calendar_today',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 20),
                            SizedBox(width: 2.w),
                            Expanded(
                                child: Text(
                                    widget.matchData['date'] != null
                                        ? '${widget.matchData['date'].day}/${widget.matchData['date'].month}/${widget.matchData['date'].year}'
                                        : 'Select Date',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium)),
                          ]))),
                ])),
            SizedBox(width: 4.w),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Time *',
                      style: AppTheme.lightTheme.textTheme.titleMedium),
                  SizedBox(height: 1.h),
                  InkWell(
                      onTap: _selectTime,
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 3.h),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      AppTheme.lightTheme.colorScheme.outline),
                              borderRadius: BorderRadius.circular(8),
                              color: AppTheme.lightTheme.colorScheme.surface),
                          child: Row(children: [
                            CustomIconWidget(
                                iconName: 'access_time',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 20),
                            SizedBox(width: 2.w),
                            Expanded(
                                child: Text(
                                    widget.matchData['time'] != null
                                        ? widget.matchData['time']
                                            .format(context)
                                        : 'Select Time',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium)),
                          ]))),
                ])),
          ]),
          SizedBox(height: 2.h),

          // Calendar Toggle
          Row(children: [
            Switch(
                value: _useNepaliCalendar,
                onChanged: (value) {
                  setState(() {
                    _useNepaliCalendar = value;
                  });
                }),
            SizedBox(width: 2.w),
            Text('Use Nepali Calendar',
                style: AppTheme.lightTheme.textTheme.bodyMedium),
          ]),
          SizedBox(height: 3.h),

          // Match Format
          Text('Match Format *',
              style: AppTheme.lightTheme.textTheme.titleMedium),
          SizedBox(height: 1.h),
          Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                  children: _matchFormats.map((format) {
                final isSelected = format == _selectedFormat;
                return Expanded(
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedFormat = format;
                          });
                          widget.onDataChanged('format', format);
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(vertical: 3.h),
                            decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(format,
                                textAlign: TextAlign.center,
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                        color: isSelected
                                            ? AppTheme.lightTheme.colorScheme
                                                .onPrimary
                                            : AppTheme.lightTheme.colorScheme
                                                .onSurface,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal)))));
              }).toList())),
          SizedBox(height: 3.h),

          // Venue
          Text('Venue *', style: AppTheme.lightTheme.textTheme.titleMedium),
          SizedBox(height: 1.h),
          TextFormField(
              controller: _venueController,
              decoration: InputDecoration(
                  hintText: 'Enter venue name or address',
                  prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                          iconName: 'location_on',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20)),
                  suffixIcon: IconButton(
                      onPressed: () {
                        // GPS location functionality
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Getting current location...')));
                      },
                      icon: CustomIconWidget(
                          iconName: 'my_location',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20))),
              onChanged: (value) => widget.onDataChanged('venue', value)),
          SizedBox(height: 2.h),

          // Suggested Venues
          Text('Suggested Venues',
              style: AppTheme.lightTheme.textTheme.titleMedium),
          SizedBox(height: 1.h),
          SizedBox(
              height: 20.h,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _suggestedVenues.length,
                  itemBuilder: (context, index) {
                    final venue = _suggestedVenues[index];
                    return Container(
                        width: 70.w,
                        margin: EdgeInsets.only(right: 3.w),
                        child: InkWell(
                            onTap: () {
                              _venueController.text = venue['name'];
                              widget.onDataChanged('venue', venue['name']);
                            },
                            child: Card(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Expanded(
                                      flex: 3,
                                      child: ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(8)),
                                          child: CustomImageWidget(
                                              imageUrl: venue['image'],
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover))),
                                  Expanded(
                                      flex: 2,
                                      child: Padding(
                                          padding: EdgeInsets.all(2.w),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(venue['name'],
                                                    style: AppTheme.lightTheme
                                                        .textTheme.titleSmall,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                                SizedBox(height: 0.5.h),
                                                Row(children: [
                                                  CustomIconWidget(
                                                      iconName: 'location_on',
                                                      color: AppTheme.lightTheme
                                                          .colorScheme.onSurface
                                                          .withValues(
                                                              alpha: 0.6),
                                                      size: 12),
                                                  SizedBox(width: 1.w),
                                                  Expanded(
                                                      child: Text(
                                                          venue['location'],
                                                          style: AppTheme
                                                              .lightTheme
                                                              .textTheme
                                                              .bodySmall,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis)),
                                                ]),
                                                SizedBox(height: 0.5.h),
                                                Text(venue['distance'],
                                                    style: AppTheme.lightTheme
                                                        .textTheme.labelSmall
                                                        ?.copyWith(
                                                            color: AppTheme
                                                                .lightTheme
                                                                .colorScheme
                                                                .primary)),
                                              ]))),
                                ]))));
                  })),
        ]));
  }
}
