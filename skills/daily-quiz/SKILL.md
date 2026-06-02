# SKILL: Daily Tech Brief and Quiz Generation

## GOAL
Generate a personalized daily tech brief for a user and send it via Telegram. The brief must contain exactly 5 interview questions and 3 to 5 technical tidbits tailored to the user's stored preferences.

## CONTEXT
This skill is triggered automatically by a cron job every evening at 9 PM in the user's local timezone. The user's ID will be provided at runtime.

## GENERATION WORKFLOW
1. Retrieve the user's profile from memory using the key `user_profile_{{user.id}}`.
2. Perform a `web_search` for each of the user's domains. Prioritize fresh, recent, and relevant sources.
3. Synthesize 3 to 5 useful technical tidbits from the search results.
4. Generate exactly 5 interview questions that match the user's level and domains.
5. Ensure variety across conceptual, coding, system design, and behavioral questions.
6. Avoid repeating recently asked topics by checking memory.
7. Format the message for Telegram using Markdown with this exact structure:

```text
🦞 *Your Daily Tech Brief* — [Date]

━━━━━━━━━━━━━━━━━━━━
🧠 *Interview Questions*
━━━━━━━━━━━━━━━━━━━━

*Q1 [Type — Domain]*
[Question 1 Text]

*Q2 [Type — Domain]*
[Question 2 Text]

...

━━━━━━━━━━━━━━━━━━━━
💡 *Today's Tidbits*
━━━━━━━━━━━━━━━━━━━━

• [Tidbit 1]

• [Tidbit 2]

...

━━━━━━━━━━━━━━━━━━━━
Reply *answers* to get feedback, or *more* for extra questions.
```

## CONSTRAINTS
- Use `web_search` as part of generation.
- Prioritize accuracy and relevance.
- Do not ask the user for clarification during the scheduled job.
- Send the final result through Telegram.
