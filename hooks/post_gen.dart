import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) async {
  await runDotenvVault(
    context: context,
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
