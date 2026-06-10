import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/feed_provider.dart';
import '../models/opportunity_model.dart';
import '../constants/app_colors.dart';

class CreateOpportunityScreen extends StatefulWidget {
  final OpportunityType opportunityType;

  const CreateOpportunityScreen({super.key, required this.opportunityType});

  @override
  State<CreateOpportunityScreen> createState() =>
      _CreateOpportunityScreenState();
}

class _CreateOpportunityScreenState extends State<CreateOpportunityScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _timeController;

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  String _selectedCategory = 'Tech & Software';
  Color _selectedColor = AppColors.navyBlue;

  final List<String> _categories = [
    'Tech & Software',
    'Business & Marketing',
    'Leadership',
    'Social Impact',
    'Design',
    'Health',
    'Arts & Culture',
    'Finance',
  ];

  final Map<OpportunityType, List<Color>> _colorsByType = {
    OpportunityType.event: [
      Color(0xFF1565C0),
      Color(0xFF7B2D8B),
      Color(0xFFE07B39),
      Color(0xFF2E7D32),
      Color(0xFF00695C),
    ],
    OpportunityType.hackathon: [
      AppColors.red,
      Color(0xFF1565C0),
      Color(0xFF7B2D8B),
      Color(0xFFE07B39),
    ],
    OpportunityType.startup: [
      Color(0xFFAD1457),
      Color(0xFF1565C0),
      Color(0xFFE07B39),
      AppColors.navyBlue,
    ],
  };

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    _timeController = TextEditingController(text: '10:00 AM');
    _selectedColor = _colorsByType[widget.opportunityType]![0];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: Text(
          'Create ${widget.opportunityType.name.toUpperCase()}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFormSection('Title', _buildTitleField()),
              const SizedBox(height: 20),
              _buildFormSection('Description', _buildDescriptionField()),
              const SizedBox(height: 20),
              _buildFormSection('Category', _buildCategoryDropdown()),
              const SizedBox(height: 20),
              _buildFormSection('Date', _buildDatePicker()),
              const SizedBox(height: 20),
              _buildFormSection('Time', _buildTimeField()),
              const SizedBox(height: 20),
              _buildFormSection('Location', _buildLocationField()),
              const SizedBox(height: 20),
              _buildFormSection('Tag Color', _buildColorPicker()),
              const SizedBox(height: 32),
              _buildSubmitButton(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.navyBlue,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      decoration: InputDecoration(
        hintText: 'Enter opportunity title',
        hintStyle: const TextStyle(color: AppColors.gray),
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.red),
        ),
      ),
      maxLines: 1,
    );
  }

  Widget _buildDescriptionField() {
    return TextField(
      controller: _descriptionController,
      decoration: InputDecoration(
        hintText: 'Describe your opportunity...',
        hintStyle: const TextStyle(color: AppColors.gray),
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.red),
        ),
      ),
      maxLines: 5,
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: DropdownButton<String>(
        value: _selectedCategory,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        items: _categories
            .map(
              (category) =>
                  DropdownMenuItem(value: category, child: Text(category)),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => _selectedCategory = value);
          }
        },
      ),
    );
  }

  Widget _buildDatePicker() {
    final dateFormat = DateFormat('MMM dd, yyyy');
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.lightGray),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: AppColors.red, size: 20),
            const SizedBox(width: 12),
            Text(
              dateFormat.format(_selectedDate),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.navyBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField() {
    return TextField(
      controller: _timeController,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.access_time, color: AppColors.red),
        hintText: '10:00 AM',
        hintStyle: const TextStyle(color: AppColors.gray),
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.red),
        ),
      ),
    );
  }

  Widget _buildLocationField() {
    return TextField(
      controller: _locationController,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.location_on, color: AppColors.red),
        hintText: 'Enter location',
        hintStyle: const TextStyle(color: AppColors.gray),
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.red),
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    final colors = _colorsByType[widget.opportunityType] ?? [];
    return Wrap(
      spacing: 12,
      children: colors
          .map(
            (color) => GestureDetector(
              onTap: () => setState(() => _selectedColor = color),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _selectedColor == color
                        ? AppColors.navyBlue
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: _validateAndSubmit,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              'Create Opportunity',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  void _validateAndSubmit() {
    if (_titleController.text.isEmpty) {
      _showError('Please enter a title');
      return;
    }
    if (_descriptionController.text.isEmpty) {
      _showError('Please enter a description');
      return;
    }
    if (_locationController.text.isEmpty) {
      _showError('Please enter a location');
      return;
    }

    final feedProvider = Provider.of<FeedProvider>(context, listen: false);
    final newOpportunity = OpportunityModel(
      id: 'opp${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text,
      description: _descriptionController.text,
      date: _selectedDate,
      time: _timeController.text,
      location: _locationController.text,
      type: widget.opportunityType,
      category: _selectedCategory,
      organizer: const OrganizerInfo(
        name: 'You',
        id: 'current_user',
        avatar: '👤',
      ),
      tagColor: _selectedColor,
      rsvpCount: 0,
      isFeatured: false,
    );

    feedProvider.createOpportunity(newOpportunity);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opportunity created successfully!'),
        backgroundColor: AppColors.red,
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.of(context).pop();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorBox,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
