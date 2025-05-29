import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notiq/app/config/env.dart';
import 'package:notiq/app/exception_handler/app_exceptions.dart';
import 'package:notiq/app/utils/user_session_helper.dart';
import 'package:notiq/models/task.model.dart';
import 'dart:convert';

/// A service to handle parsing natural language into structured task data
class AiParserService {
  final String apiKey;
  final String baseUrl;

  AiParserService({
    this.apiKey = Env.apiKey,
    this.baseUrl = "https://api.aimlapi.com/v1/chat/completions",
  });

  /// Parse natural language text into a list of tasks using LLM
  Future<List<Task>> parseText(String text) async {
    final prompt =
        '''
    You are a task management assistant. Parse the following text into structured task data.
    The current date is ${DateTime.now().toIso8601String()}.

    Rules for parsing:
    1. Split into multiple tasks if multiple actions/items are mentioned
    2. Convert relative dates (e.g., "tomorrow", "next week") to ISO dates
    3. Infer priority based on urgency words ("urgent", "asap" -> high; "sometime", "when possible" -> low)
    4. Infer category based on task context (work-related -> work; groceries -> shopping; etc.)
    5. Clean and standardize task titles for clarity

    Format the response as a JSON object with this structure:
    {
      "tasks": [
        {
          "title": "Clean, action-oriented task title",
          "dueDate": "YYYY-MM-DDTHH:mm:ssZ", // ISO string or null if no date mentioned
          "priority": "high|medium|low", // or null if not implied
          "category": "work|personal|shopping|health" // or null if not clear
        }
      ]
    }

    Text to parse:
    $text

    Return valid JSON only, no other text.
    ''';

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            // Changed to array format
            {
              'role': 'system',
              'content':
                  'You are a task management assistant that parses text into structured task data.',
            },
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.7,
          'top_p': 0.7,
          'frequency_penalty': 1,
          'max_output_tokens': 512,
          'top_k': 50,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw AiParserException(
          'API request failed. Status code: ${response.statusCode}, Body: ${response.body}',
        );
      }

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      final content =
          responseJson['choices'][0]['message']['content'] as String;
      final parsedContent = jsonDecode(content) as Map<String, dynamic>;
      final taskList = (parsedContent['tasks'] as List)
          .cast<Map<String, dynamic>>();

      // Validate each task before creating Task objects
      for (final taskData in taskList) {
        _validateTaskData(taskData);
      }

      return taskList.map((taskData) {
        var date = taskData['dueDate'] != null
            ? DateTime.parse(taskData['dueDate'] as String)
            : null;
        return Task(
          user_id: UserSession().getUser!.id,
          title: taskData['title'] as String,
          dueDate: date,
          priority: taskData['priority'] as String?,
          tag: taskData['category'] as String?,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error parsing with LLM: $e');
      rethrow;
    }
  }

  /// Validate the JSON response from the LLM
  void _validateTaskData(Map<String, dynamic> taskData) {
    if (!taskData.containsKey('title')) {
      throw AiParserException('Task title is required');
    }

    if (taskData.containsKey('dueDate') && taskData['dueDate'] != null) {
      try {
        DateTime.parse(taskData['dueDate'] as String);
      } catch (e) {
        throw AiParserException(
          'Invalid date format. Due date must be a valid ISO 8601 string',
        );
      }
    }

    if (taskData.containsKey('priority') && taskData['priority'] != null) {
      final priority = taskData['priority'] as String;
      if (!['high', 'medium', 'low'].contains(priority)) {
        throw AiParserException(
          'Invalid priority. Priority must be one of: high, medium, low',
        );
      }
    }

    if (taskData.containsKey('category') && taskData['category'] != null) {
      final category = taskData['category'] as String;
      if (!['work', 'personal', 'shopping', 'health'].contains(category)) {
        throw AiParserException(
          'Invalid category. Category must be one of: work, personal, shopping, health',
        );
      }
    }
  }

  /// Shows a loading dialog while parsing is in progress
  static Future<T> withLoadingDialog<T>(
    BuildContext context,
    Future<T> Function() action,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Parsing with AI...',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final result = await action();
      if (context.mounted) Navigator.of(context).pop();
      return result;
    } catch (e) {
      if (context.mounted) Navigator.of(context).pop();
      rethrow;
    }
  }
}
