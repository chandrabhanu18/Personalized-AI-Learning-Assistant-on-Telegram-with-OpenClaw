# Personal AI Learning Assistant on Telegram — OpenClaw

This repository contains the required OpenClaw skill files, configuration, containerization, and documentation for a personalized Telegram learning assistant.

## Included Files
- `skills/user-onboarding/SKILL.md`
- `skills/daily-quiz/SKILL.md`
- `config/openclaw.json`
- `Dockerfile`
- `docker-compose.yml`
- `.env.example`
- `.github/workflows/verify.yml`
- `scripts/register-user-cron.js`
- `package.json`

## Design Choice
The onboarding trigger is implemented as a Standing Order. That keeps the behavior native to OpenClaw, simple to deploy, and reliable for first-contact user onboarding without needing an external webhook service.

The daily brief should use a per-user cron job after onboarding so each user gets the message at 9 PM in their own timezone. The helper script `scripts/register-user-cron.js` wraps the OpenClaw CLI for that purpose.

## Setup
1. Copy the example environment file:

```bash
copy .env.example .env
```

2. Fill in `TELEGRAM_BOT_TOKEN` and any LLM or search settings.

3. Build and start the containerized stack:

```bash
docker compose build
docker compose up -d
```

4. Start or connect Ollama locally if you use the recommended local model.

5. Send a first message to your Telegram bot to trigger onboarding.

## OpenClaw Configuration
The configuration uses environment variables for secrets and includes the Telegram plugin plus the daily cron job template.

## Verification
Run the included validation script after the files are in place.

Or use the npm script:

```bash
npm run verify
```

## CI
GitHub Actions runs `scripts/verify_submission.sh` on every push and pull request via `.github/workflows/verify.yml`.

## Registering a Per-User Cron Job
After onboarding completes and the user's timezone is stored, register or refresh that user's nightly job with:

```bash
node scripts/register-user-cron.js <userId> <timezone>
```

Or via npm:

```bash
npm run register-cron -- <userId> <timezone>
```

Example:

```bash
node scripts/register-user-cron.js 123456789 America/New_York
```

If no timezone is provided, the helper falls back to `DEFAULT_TZ` and then `UTC`.
