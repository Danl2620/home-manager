---
description: Review a pull request or merge request for quality, security, and completeness
---

You are performing a comprehensive pull request/merge request review. Follow these steps:

## 1. Identify the Platform and PR/MR Number

From the user's request, determine:
- Platform: GitHub (gh) or GitLab (glab)
- PR/MR number
- Repository (if specified, otherwise use current directory)

## 2. Fetch PR/MR Information

**For GitHub:**
```bash
# Get PR details with metadata
gh pr view <number> --json title,body,author,state,additions,deletions,files,commits,headRefName,baseRefName

# Get the diff
gh pr diff <number>

# Get PR checks/status
gh pr checks <number>
```

**For GitLab:**
```bash
# Get MR details
glab mr view <number>

# Get the diff
glab mr diff <number>

# Get MR status
glab mr status
```

## 3. Analyze All Changed Files

Review each changed file for:

### Code Quality
- Logic errors or potential bugs
- Error handling gaps
- Edge cases not handled
- Performance concerns
- Code style inconsistencies
- Poor naming or unclear code
- Duplicated code
- Anti-patterns (god objects, tight coupling, etc.)

### Security Issues
- SQL injection vulnerabilities
- XSS (Cross-Site Scripting) risks
- CSRF vulnerabilities
- Authentication/authorization bypasses
- Exposed secrets or credentials
- Command injection risks
- Path traversal vulnerabilities
- Insecure dependencies
- OWASP Top 10 violations

### Completeness
- Tests for new functionality
- Test coverage for edge cases
- Documentation updates
- No unresolved TODOs/FIXMEs
- Database migrations if needed
- Configuration updates
- Backward compatibility

## 4. Generate Comprehensive Review Report

Structure your findings as:

```markdown
# Pull Request Review: [Title]

## Summary
[1-2 sentence overview of the PR's purpose]

## Assessment Scores

- **Code Quality:** [Excellent/Good/Fair/Poor]
- **Security:** [Excellent/Good/Fair/Poor - list concerns if any]
- **Completeness:** [Complete/Mostly Complete/Incomplete]
- **Overall Verdict:** [Ready to Merge / Needs Changes / Not Ready]

## Strengths

- [List positive aspects of the PR]

## Issues Found

### Critical (Blocking)
[Issues that must be fixed before merge]

1. **[Issue Title]** (`file.ext:line`)
   - Description: [What's wrong]
   - Impact: [Why it's critical]
   - Recommendation: [How to fix]

### Major (Should Fix)
[Issues that should be addressed]

1. **[Issue Title]** (`file.ext:line`)
   - Description: [What's wrong]
   - Recommendation: [How to fix]

### Minor (Suggestions)
[Nice-to-have improvements]

1. **[Issue Title]** (`file.ext:line`)
   - Suggestion: [Improvement idea]

## Test Coverage

- Unit tests: [Yes/No/Partial - with details]
- Integration tests: [Yes/No/Partial - with details]
- Edge cases covered: [Yes/No - list any gaps]
- CI/CD status: [Passing/Failing - with details]

## Documentation

- README updated: [Yes/No/N/A]
- API docs: [Yes/No/N/A]
- Code comments: [Adequate/Needs improvement]
- CHANGELOG: [Yes/No/N/A]

## Recommendations

1. [Prioritized action items]
2. [...]

## Next Steps

[Clear guidance on what needs to happen before this can merge]
```

## 5. Special Modes

### Generate Description Mode
If the user asks to generate a PR description:

1. Analyze all commits and changes
2. Generate a description following this template:

```markdown
## Summary

[Concise 1-2 sentence overview]

## Changes

- [Key changes as bullet points]
- [Be specific about modifications]

## Motivation

[Why this change was needed]

## Testing

- [How to test]
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing performed

## Breaking Changes

[List any breaking changes or "None"]

## Screenshots/Examples

[If UI changes, describe what to include]
```

3. Ask if the user wants to update the PR with this description

### Quick Check Mode
If the user asks "is it ready to merge":

1. Focus on blocking issues only
2. Provide a quick yes/no with brief explanation
3. List only critical issues if not ready

## Best Practices

- **Be specific:** Always include file paths and line numbers
- **Be constructive:** Suggest improvements, not just problems
- **Be thorough:** Review ALL changed files
- **Be balanced:** Mention what's good, not just issues
- **Prioritize:** Critical > Major > Minor
- **Focus on impact:** Does it work? Is it secure? Is it maintainable?

## Example Usage

User: `/pr-review 123` → Full comprehensive review
User: `/pr-review 456 generate description` → Create PR description
User: `/pr-review 789 quick check` → Fast merge readiness check
User: `/pr-review gitlab:42` → Review GitLab MR #42
