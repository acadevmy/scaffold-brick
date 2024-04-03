import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) async {
  final workspaceName = context.vars['workspaceName'].toString();
  if (workspaceName.trim().isEmpty) {
    throw Exception('Missing valid workspace name');
  }

  String workingDirectory =
      getWorkingDirectory(context: context, workspaceName: workspaceName);

  await runDotenvVault(
    context: context,
    workingDirectory: workingDirectory,
  );

  await runPnpm(
    context: context,
    workingDirectory: workingDirectory,
  );

  await runGit(
    context: context,
    workingDirectory: workingDirectory,
  );

  runNextSteps(
    context: context,
    workspaceName: workspaceName,
  );
}

String getWorkingDirectory(
    {required HookContext context, required String workspaceName}) {
  return Directory.current.uri.resolve(workspaceName).path;
}

Future<void> runDotenvVault({
  required HookContext context,
  required String workingDirectory,
}) async {
  context.logger.info('🔑 Creating dotenv vault...');
  await Process.run(
    'pnpm',
    ['dlx', 'dotenv-vault', 'new', '-y'],
    workingDirectory: workingDirectory,
  );

  context.logger.info('🔑 Logging in vault...');
  await Process.run(
    'pnpm',
    ['dlx', 'dotenv-vault', 'login', '-y'],
    workingDirectory: workingDirectory,
  );
  context.logger.success('🔑 Opening Vault UI...');

  await Process.run(
    'pnpm',
    ['dlx', 'dotenv-vault', 'open', '-y'],
    workingDirectory: workingDirectory,
  );

  context.logger.success('🔑 .env Vault configured successfully 🚀');
}

Future<void> runPnpm({
  required HookContext context,
  required String workingDirectory,
}) async {
  context.logger.info('📦 Running pnpm i');
  await Process.run('pnpm', ['i'], workingDirectory: workingDirectory);
  context.logger.success('📦 pnpm configured successfully 🚀');
}

Future<void> runGit({
  required HookContext context,
  required String workingDirectory,
}) async {
  context.logger.info('📚 Initializing git with "main" as default branch...');
  await Process.run(
    'git',
    ['init', '--initial-branch=main'],
    workingDirectory: workingDirectory,
  );

  context.logger.info('📚 Staging initial scaffold files...');
  await Process.run('git', ['add', '.'], workingDirectory: workingDirectory);

  context.logger.info('📚 Committing "chore(scaffold): initial commit"...');
  await Process.run(
    'git',
    ['commit', '-m', '"chore(scaffold): initial commit"'],
    workingDirectory: workingDirectory,
  );

  context.logger.success('📚 Git initialized successfully! 🚀');
}


runNextSteps({required HookContext context, required String workspaceName}) {
  context.logger.success('🏛️ Scaffold initialized successfully! 🚀');
  context.logger.info('Next steps:');
  context.logger.info('  cd ${workspaceName.paramCase}');
  context.logger.info('  pnpm run start');
}
