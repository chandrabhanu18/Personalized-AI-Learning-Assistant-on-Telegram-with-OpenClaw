#!/usr/bin/env node

const { spawnSync } = require('node:child_process');

function usage() {
  console.error('Usage: node scripts/register-user-cron.js <userId> [timezone]');
  process.exit(1);
}

const userId = process.argv[2];
const timezone = process.argv[3] || process.env.DEFAULT_TZ || 'UTC';

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

const result = spawnSync('openclaw', args, { stdio: 'inherit', shell: process.platform === 'win32' });

if (result.error) {
  console.error(`Failed to execute openclaw: ${result.error.message}`);
  process.exit(1);
}

if (result.status !== 0) {
  process.exit(result.status || 1);
}

console.log(`Registered ${jobName} for timezone ${timezone}`);