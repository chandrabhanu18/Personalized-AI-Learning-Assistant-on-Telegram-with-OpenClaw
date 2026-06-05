#!/usr/bin/env node
const fs = require('fs');
try {
  const s1 = fs.readFileSync('skills/user-onboarding/SKILL.md', 'utf8');
  const s2 = fs.readFileSync('skills/daily-quiz/SKILL.md', 'utf8');
  if (!s1.includes('user_profile')) {
    console.error('onboarding SKILL missing memory key');
    process.exit(2);
  }
  if (!s2.includes('🦞 *Your Daily Tech Brief*')) {
    console.error('daily SKILL missing title');
    process.exit(2);
  }
  console.log('SKILL content OK');
} catch (e) {
  console.error('Error checking SKILLs:', e.message);
  process.exit(3);
}
