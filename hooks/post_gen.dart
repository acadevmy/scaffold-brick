import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) async {
  final workspaceName = context.vars['workspaceName'].toString();
  if (workspaceName.trim().isEmpty) {
    throw Exception('Missing valid workspace name');
  }

  await runDotenvVault(
    context: context,
  );

  await runPnpm(
    context: context,
  );

  await runGit(
    context: context,
  );

  runNextSteps(
    context: context,
    workspaceName: workspaceName,
  );
}

Future<void> runDotenvVault({
  required HookContext context,
}) async {
  context.logger.info('🔑 Creating dotenv vault...');
  await Process.run(
    'pnpm',
    ['dlx', 'dotenv-vault', 'new', '-y'],
  );

  context.logger.info('🔑 Logging in vault...');
  await Process.run(
    'pnpm',
    ['dlx', 'dotenv-vault', 'login', '-y'],
  );
  context.logger.success('🔑 Opening Vault UI...');

  await Process.run(
    'pnpm',
    ['dlx', 'dotenv-vault', 'open', '-y'],
  );

  context.logger.success('🔑 .env Vault configured successfully 🚀');
}

Future<void> runPnpm({
  required HookContext context,
}) async {
  context.logger.info('📦 Running pnpm i');
  await Process.run('pnpm', ['i']);
  context.logger.success('📦 pnpm configured successfully 🚀');
}

Future<void> runGit({
  required HookContext context,
}) async {
  context.logger.info('📚 Initializing git with "main" as default branch...');
  await Process.run(
    'git',
    ['init', '--initial-branch=main'],
  );

  context.logger.info('📚 Staging initial scaffold files...');
  await Process.run('git', ['add', '.'],);

  context.logger.info('📚 Committing "chore(scaffold): initial commit"...');
  await Process.run(
    'git',
    ['commit', '-m', '"chore(scaffold): initial commit"'],
  );

  context.logger.success('📚 Git initialized successfully! 🚀');
}


runNextSteps({required HookContext context, required String workspaceName}) {
  context.logger.success('🏛️ Scaffold initialized successfully! 🚀');
  context.logger.info('Next steps:');
  context.logger.info('  cd ${workspaceName.paramCase}');
  context.logger.info('  pnpm run start');
}
