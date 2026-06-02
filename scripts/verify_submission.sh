#!/usr/bin/env sh
set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

for path in \
  "$ROOT/skills/user-onboarding/SKILL.md" \
  "$ROOT/skills/daily-quiz/SKILL.md" \
  "$ROOT/config/openclaw.json" \
  "$ROOT/README.md" \
  "$ROOT/Dockerfile" \
  "$ROOT/docker-compose.yml" \
  "$ROOT/.env.example"
do
  if [ ! -f "$path" ]; then
    echo "Missing: $path"
    exit 1
  fi
done

echo "All required files exist."
