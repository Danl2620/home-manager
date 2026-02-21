---
name: Pull Request Review
description: >
  REQUIRED when reviewing pull requests or merge requests. Use when analyzing
  PRs/MRs for quality, completeness, security issues, or generating PR
  descriptions. Triggers: pull request, merge request, PR review, MR review,
  code review, review changes, assess PR, check PR, PR description, review
  quality, gh pr, glab mr.
---

# Pull Request Review Skill

Comprehensive pull request and merge request review system for GitHub and GitLab.

## When This Skill MUST Be Used

**ALWAYS invoke this skill when:**
- User mentions reviewing a pull request or merge request
- User asks to check PR/MR quality, completeness, or issues
- User wants to generate or update a PR/MR description
- User mentions `gh pr` or `glab mr` commands
- User asks about code review, change assessment, or PR analysis
- Debugging why a PR might have issues
- Assessing whether a PR is ready to merge

## Overview

This skill provides comprehensive PR/MR review capabilities:
- **Fetch PR/MR details** from GitHub (gh) or GitLab (glab)
- **Assess code quality** - identify issues, anti-patterns, security concerns
- **Evaluate completeness** - check for tests, documentation, proper implementation
- **Generate descriptions** - create or update PR/MR descriptions based on changes
- **Report findings** - structured reports on issues and recommendations

## Platforms Supported

### GitHub (via `gh` CLI)
- Pull requests
- Comments and reviews
- PR metadata and status

### GitLab (via `glab` CLI)
- Merge requests
- Comments and discussions
- MR metadata and status

## Review Process

When reviewing a PR/MR, follow this comprehensive process:

### 1. Fetch PR/MR Information

**GitHub:**
```bash
# Get PR details
gh pr view <number> --json title,body,author,files,additions,deletions,commits

# Get PR diff
gh pr diff <number>

# Get PR comments
gh pr view <number> --comments
```

**GitLab:**
```bash
# Get MR details
glab mr view <number>

# Get MR diff
glab mr diff <number>

# Get MR comments
glab mr note list <number>
```

### 2. Code Quality Assessment

Review all changed files for:

**Code Issues:**
- Logic errors or potential bugs
- Error handling gaps
- Edge cases not handled
- Race conditions or concurrency issues
- Memory leaks or resource management
- Performance concerns

**Code Style:**
- Inconsistent formatting
- Poor naming conventions
- Overly complex code
- Lack of clarity or readability
- Missing code comments where needed
- Commented-out code

**Anti-patterns:**
- God objects or classes
- Tight coupling
- Violation of SOLID principles
- Duplicated code
- Magic numbers or hardcoded values
- Improper abstraction levels

### 3. Security Assessment

Check for security vulnerabilities:

**Common Security Issues:**
- SQL injection vulnerabilities
- XSS (Cross-Site Scripting) risks
- CSRF (Cross-Site Request Forgery) gaps
- Authentication/authorization bypasses
- Insecure data storage
- Exposed secrets or credentials
- Unsafe deserialization
- Path traversal vulnerabilities
- Command injection risks
- Insecure dependencies

**OWASP Top 10:**
- Broken access control
- Cryptographic failures
- Injection flaws
- Insecure design
- Security misconfiguration
- Vulnerable components
- Authentication failures
- Data integrity failures
- Logging/monitoring failures
- SSRF (Server-Side Request Forgery)

### 4. Completeness Assessment

Verify the PR/MR includes:

**Tests:**
- Unit tests for new functionality
- Integration tests where appropriate
- Test coverage for edge cases
- Tests actually pass (check CI/CD status)
- Tests are meaningful, not just for coverage

**Documentation:**
- Updated README if behavior changed
- API documentation for new endpoints
- Code comments for complex logic
- Updated CHANGELOG if applicable
- Migration guides if breaking changes

**Implementation:**
- All acceptance criteria met
- No TODO or FIXME comments left unresolved
- Database migrations if schema changed
- Configuration updates if needed
- Backward compatibility considered

**Quality Checks:**
- CI/CD pipeline passing
- No merge conflicts
- Proper branch naming
- Commit messages are clear
- No debug code or console.logs left behind

### 5. Generate Review Report

Structure findings into a comprehensive report:

```markdown
# Pull Request Review: [PR Title]

## Summary
[Brief overview of the PR's purpose and changes]

## Quality Assessment

### Code Quality: [Score/Rating]
- **Strengths:**
  - [List positive aspects]

- **Issues Found:**
  - [List issues with file references and line numbers]

### Security Assessment: [Score/Rating]
- **Concerns:**
  - [List security issues]

- **Recommendations:**
  - [List security improvements]

### Completeness: [Score/Rating]
- **Tests:** [Pass/Fail with details]
- **Documentation:** [Pass/Fail with details]
- **Implementation:** [Pass/Fail with details]

## Detailed Findings

### Critical Issues
1. [Issue with file:line reference]

### Major Issues
1. [Issue with file:line reference]

### Minor Issues / Suggestions
1. [Issue with file:line reference]

## Recommendations

1. [Action item]
2. [Action item]

## Verdict

**Ready to Merge:** [Yes/No/With Changes]

[Explanation of verdict]
```

## Generating PR/MR Descriptions

When user wants to generate or update a PR/MR description:

### Analysis Steps

1. **Review all commits** in the PR/MR
2. **Analyze all changed files** to understand the scope
3. **Identify the purpose** - bug fix, feature, refactor, etc.
4. **Extract key changes** - what was added/modified/removed
5. **Note any breaking changes** or migrations needed

### Description Template

```markdown
## Summary

[Concise 1-2 sentence overview of what this PR does]

## Changes

- [List key changes as bullet points]
- [Be specific about what was modified]
- [Include both code and configuration changes]

## Motivation

[Why this change was needed - link to issue if applicable]

## Testing

- [How to test these changes]
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing performed

## Breaking Changes

[List any breaking changes or "None"]

## Migration Guide

[If applicable, explain how to migrate]

## Screenshots/Examples

[If UI changes, add screenshots or examples]

## Checklist

- [ ] Tests pass locally
- [ ] Documentation updated
- [ ] No console warnings
- [ ] Code follows project style
- [ ] Reviewed own code
```

## Best Practices for Reviews

### Be Constructive
- Point out what's good, not just issues
- Suggest improvements, don't just criticize
- Explain *why* something is an issue
- Provide code examples when possible

### Be Thorough
- Review all changed files
- Check tests actually test the right things
- Verify edge cases are handled
- Look for security implications

### Be Specific
- Reference exact file and line numbers
- Quote problematic code
- Provide concrete examples
- Suggest specific fixes

### Focus on Impact
- Prioritize critical and major issues
- Distinguish between blocking issues and suggestions
- Consider the scope of the PR
- Balance perfectionism with pragmatism

## Common Review Patterns

### Bug Fix Review
Focus on:
- Does it actually fix the reported bug?
- Are there tests that would catch the bug?
- Could this fix introduce new bugs?
- Are there similar bugs elsewhere?

### Feature Review
Focus on:
- Is the implementation complete?
- Is it aligned with requirements?
- Is it properly tested?
- Is documentation updated?
- Are there security implications?

### Refactoring Review
Focus on:
- Does it improve code quality?
- Is behavior unchanged?
- Are tests still passing?
- Is it easier to maintain now?

### Performance Optimization Review
Focus on:
- Are there benchmarks showing improvement?
- Are there trade-offs (complexity vs speed)?
- Are edge cases still handled?
- Is the optimization premature?

## Using CLI Tools

### GitHub CLI (gh)

```bash
# List open PRs
gh pr list

# View specific PR
gh pr view 123

# View PR diff
gh pr diff 123

# Checkout PR locally
gh pr checkout 123

# Add review comment
gh pr review 123 --comment -b "Review comments here"

# Approve PR
gh pr review 123 --approve

# Request changes
gh pr review 123 --request-changes -b "Please address these issues"

# Get PR status
gh pr status

# View PR checks
gh pr checks 123
```

### GitLab CLI (glab)

```bash
# List open MRs
glab mr list

# View specific MR
glab mr view 123

# View MR diff
glab mr diff 123

# Checkout MR locally
glab mr checkout 123

# Add MR note
glab mr note 123 -m "Review comments here"

# Approve MR
glab mr approve 123

# Get MR status
glab mr status
```

## Integration with Agents

This skill provides the knowledge and framework for PR reviews. The actual review work should be delegated to the **pr-review agent**, which will:

1. Fetch PR/MR data using gh/glab
2. Analyze all changed files
3. Assess quality, security, and completeness
4. Generate comprehensive review report
5. Optionally generate/update PR description

When a user requests a PR review, invoke the pr-review agent with the PR number and platform (GitHub/GitLab).

## Example User Interactions

**Example 1: User wants to review a GitHub PR**
```
User: "Review PR #123"
Assistant: [Invokes pr-review skill, then delegates to pr-review agent]
[Agent fetches PR data, reviews code, generates report]
Assistant: "I've completed the review of PR #123. Here are my findings:

[Presents comprehensive review report with quality assessment, security concerns, and recommendations]
"
```

**Example 2: User wants to generate PR description**
```
User: "Generate a description for PR #456"
Assistant: [Invokes pr-review skill, then delegates to pr-review agent]
[Agent analyzes commits and changes, generates description]
Assistant: "Here's a comprehensive description for PR #456:

[Presents generated PR description following the template]

Would you like me to update the PR with this description?"
```

**Example 3: User wants to check if PR is ready**
```
User: "Is MR 789 ready to merge?"
Assistant: [Invokes pr-review skill for GitLab, delegates to pr-review agent]
[Agent reviews MR comprehensively]
Assistant: "MR 789 is NOT ready to merge. Here are the blocking issues:

1. Missing unit tests for new authentication flow (src/auth.ts)
2. Security concern: API key exposed in config file (config/api.ts:45)
3. CI pipeline failing on integration tests

Recommendations:
[Lists specific actions needed]
"
```

## Decision Framework

**When user mentions PR/MR review:**
1. ✅ Determine platform (GitHub or GitLab)
2. ✅ Extract PR/MR number from user request
3. ✅ Invoke pr-review agent with appropriate parameters
4. ✅ Present agent findings in structured format

**When generating descriptions:**
1. ✅ Invoke pr-review agent in description mode
2. ✅ Present generated description
3. ✅ Ask if user wants to update the PR/MR

**When assessing merge readiness:**
1. ✅ Invoke pr-review agent for comprehensive review
2. ✅ Clearly state verdict (Ready/Not Ready/With Changes)
3. ✅ List blocking issues if not ready
4. ✅ Provide actionable recommendations

## Troubleshooting

| Issue | Solution |
|-------|----------|
| gh/glab not authenticated | Run `gh auth login` or `glab auth login` |
| PR/MR not found | Verify number is correct, check if PR is in different repo |
| Cannot access private repos | Check authentication and permissions |
| Diff too large | Review in chunks, focus on critical files first |
| CI status unavailable | Manually check CI/CD pipeline status |

## Quality Checklist

Before completing a review, ensure:
- [ ] All changed files have been reviewed
- [ ] Security implications have been considered
- [ ] Test coverage has been assessed
- [ ] Documentation completeness checked
- [ ] Breaking changes identified
- [ ] Specific file:line references provided for issues
- [ ] Constructive recommendations given
- [ ] Clear verdict provided (Ready/Not Ready/With Changes)
