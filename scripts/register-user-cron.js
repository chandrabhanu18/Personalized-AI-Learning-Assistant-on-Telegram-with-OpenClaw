#!/usr/bin/env node

const { spawnSync } = require('node:child_process');

function usage() {
  console.error('Usage: node scripts/register-user-cron.js <userId> [timezone] [--dry-run]');
  process.exit(1);
}

const argv = process.argv.slice(2);
const dryRunIndex = argv.indexOf('--dry-run');
const dryRun = dryRunIndex !== -1;
if (dryRun) argv.splice(dryRunIndex, 1);

const userId = argv[0];
const timezone = argv[1] || process.env.DEFAULT_TZ || 'UTC';

if (!userId) {
  usage();
}

const jobName = `nightly-tech-brief-${userId}`;
const prompt = `Run the daily-quiz skill for user ${userId}. Use their stored preferences to generate and send the daily brief via Telegram.`;

const args = [
  'cron',
  'add',
  '--name',
  jobName,
  '--cron',
  '0 21 * * *',
  '--tz',
  timezone,
  '--session',
  'isolated',
  '--message',
  prompt,
  '--announce',
  '--channel',
  'telegram',
];

if (dryRun) {
  console.log('Dry run enabled. The following OpenClaw CLI would be executed:');
  console.log('openclaw ' + args.map(a => (a.includes(' ') ? `"${a}"` : a)).join(' '));
  console.log(`Job name: ${jobName}, timezone: ${timezone}`);
  process.exit(0);
}

const result = spawnSync('openclaw', args, { stdio: 'inherit', shell: process.platform === 'win32' });

if (result.error) {
  console.error(`Failed to execute openclaw: ${result.error.message}`);
  process.exit(1);
}

if (result.status !== 0) {
  process.exit(result.status || 1);
}

console.log(`Registered ${jobName} for timezone ${timezone}`);