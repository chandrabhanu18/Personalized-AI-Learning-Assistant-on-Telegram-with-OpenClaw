#!/usr/bin/env node

const { existsSync } = require('node:fs');
const { join } = require('node:path');

const root = join(__dirname, '..');

const requiredFiles = [
  'skills/user-onboarding/SKILL.md',
  'skills/daily-quiz/SKILL.md',
  'config/openclaw.json',
  'README.md',
  'Dockerfile',
  'docker-compose.yml',
  '.env.example',
];

for (const relativePath of requiredFiles) {
  const absolutePath = join(root, relativePath);
  if (!existsSync(absolutePath)) {
    console.error(`Missing: ${relativePath}`);
    process.exit(1);
  }
}

console.log('All required files exist.');