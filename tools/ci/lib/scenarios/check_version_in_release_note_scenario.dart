import 'package:ci/domain/command.dart';
import 'package:ci/domain/element.dart';
import 'package:ci/exceptions/exceptions.dart';
import 'package:ci/services/parsers/pubspec_parser.dart';
import 'package:ci/tasks/checks.dart';
import 'package:ci/tasks/core/scenario.dart';

const String _helpInfo = 'Check for the latest version in RELEASE_NOTES.md.';

/// Сценарий для команды check_version_in_release_note.
///
/// Пример вызова:
/// dart ci check_version_in_release_note
class CheckVersionInReleaseNoteScenario extends ChangedElementScenario {
  static const String commandName = 'check_version_in_release_note';

  CheckVersionInReleaseNoteScenario(Command command, PubspecParser pubspecParser)
      : super(command, pubspecParser);

  @override
  Future<void> doExecute(List<Element> elements) async {
    try {
      for (var element in elements) {
        await checkVersionInReleaseNote(element);
      }
    } on BaseCiException {
      rethrow;
    }
  }

  @override
  String get getCommandName => commandName;

  @override
  String get helpInfo => _helpInfo;
}
