import 'package:flutter/material.dart';
import '../services/error_reporting_service.dart';
import '../error/error_handler.dart';
import '../l10n/strings_nl.dart' as strings_nl;

/// A dialog widget that allows users to submit bug reports
class BugReportDialog extends StatefulWidget {
  const BugReportDialog({super.key});

  @override
  State<BugReportDialog> createState() => _BugReportDialogState();
}

class _BugReportDialogState extends State<BugReportDialog> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Create a simple error report 
      await ErrorReportingService().reportSimpleError(
        message: _descriptionController.text,
        userMessage: _subjectController.text,
        additionalInfo: {
          'email': _emailController.text,
          'form_type': 'bug_report',
        },
      );

      if (mounted) {
        // Show success message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(strings_nl.AppStrings.success),
              content: Text(strings_nl.AppStrings.reportSubmittedSuccessfully),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close success dialog
                    Navigator.of(context).pop(); // Close bug report dialog
                  },
                  child: Text(strings_nl.AppStrings.ok),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        // Show error message
        final error = ErrorHandler().fromException(
          e,
          userMessage: strings_nl.AppStrings.reportSubmissionFailed,
        );
        ErrorHandler().showErrorDialog(
          context: context,
          error: error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      title: Text(strings_nl.AppStrings.reportBug),
      content: SizedBox(
        width: 500, // Fixed width for desktop
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: strings_nl.AppStrings.subject,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return strings_nl.AppStrings.pleaseEnterSubject;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: strings_nl.AppStrings.description,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return strings_nl.AppStrings.pleaseEnterDescription;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: strings_nl.AppStrings.emailOptional,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(strings_nl.AppStrings.cancel),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitReport,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDarkMode ? Colors.red[900] : Colors.red[600],
            foregroundColor: Colors.white,
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(strings_nl.AppStrings.submit),
        ),
      ],
    );
  }
}

/// A widget that shows the bug report button in the settings
class BugReportWidget extends StatelessWidget {
  const BugReportWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const BugReportScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.bug_report,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings_nl.AppStrings.reportBug,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        strings_nl.AppStrings.reportBugDescription,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A full-screen widget that allows users to submit bug reports
class BugReportScreen extends StatefulWidget {
  const BugReportScreen({super.key});

  @override
  State<BugReportScreen> createState() => _BugReportScreenState();
}

class _BugReportScreenState extends State<BugReportScreen> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  bool _isSubmitted = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Create a simple error report 
      await ErrorReportingService().reportSimpleError(
        message: _descriptionController.text,
        userMessage: _subjectController.text,
        additionalInfo: {
          'email': _emailController.text,
          'form_type': 'bug_report',
        },
      );

      if (mounted) {
        setState(() {
          _isSubmitting = false;
          // Change button to green to indicate success
          _isSubmitted = true;
        });
        
        // Automatically reset the button state after 5 seconds
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) {
            setState(() {
              _isSubmitted = false;
              // Clear the form after successful submission
              _subjectController.clear();
              _descriptionController.clear();
              _emailController.clear();
            });
          }
        });
      }
    } catch (e) {
      if (mounted) {
        // Show error message
        final error = ErrorHandler().fromException(
          e,
          userMessage: strings_nl.AppStrings.reportSubmissionFailed,
        );
        ErrorHandler().showErrorDialog(
          context: context,
          error: error,
        );
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings_nl.AppStrings.reportBug),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: strings_nl.AppStrings.subject,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return strings_nl.AppStrings.pleaseEnterSubject;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: strings_nl.AppStrings.description,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 8,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return strings_nl.AppStrings.pleaseEnterDescription;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: strings_nl.AppStrings.emailOptional,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting || _isSubmitted ? null : _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSubmitted 
                      ? Colors.green[600] 
                      : (isDarkMode ? Colors.red[900] : Colors.red[600]),
                    foregroundColor: Colors.white,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                        )
                      : _isSubmitted
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  strings_nl.AppStrings.success,
                                ),
                              ],
                            )
                          : Text(strings_nl.AppStrings.submit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}