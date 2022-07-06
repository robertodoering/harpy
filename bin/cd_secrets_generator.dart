// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

const encoder = JsonEncoder.withIndent('  ');

Future<void> main(List<String> args) async {
  final files = [
    File('android/key.properties'),
    File('android/key.jks'),
  ];

  assureBase64Installed();
  assureFilesExist(files);

  final secrets = <String, dynamic>{};

  for (final file in files) {
    final result = Process.runSync('base64', [
      file.path,
    ]);

    if (result.exitCode == 0) {
      secrets[file.path] = result.stdout;
    } else {
      print(
        '''
          Encoding ${file.path} failed with error:
          ${result.stderr}
        ''',
      );
    }
  }

  await storeSecrets(secrets);
}

Future<void> storeSecrets(Map<String, dynamic> secrets) {
  final resultFile = File('cd_secrets.json');

  if (!resultFile.existsSync()) {
    resultFile.createSync();
  }

  return resultFile.writeAsString(
    encoder.convert(secrets),
    flush: true,
  );
}

void assureFilesExist(List<File> files) {
  final fileMissing = files.where((file) => !file.existsSync());

  if (fileMissing.isNotEmpty) {
    throw Exception('Files missing: ${fileMissing.map((e) => e.path)}');
  }
}

void assureBase64Installed() {
  final result = Process.runSync('base64', ['--help']);

  if (result.exitCode != 0) {
    throw Exception('base64 not installed');
  }
}
