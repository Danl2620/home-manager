---
name: CI/CD Pipelines
description: >
  REQUIRED when working with CI/CD configurations or asking about project
  automation. Use when editing .gitlab-ci.yml, .github/workflows/*.yml, or
  pipeline configurations. Triggers: CI/CD, pipeline, GitHub Actions, GitLab CI,
  workflows, continuous integration, continuous deployment, automated testing,
  build automation, deployment automation, how to test, how to deploy, how to
  build, actions, jobs, stages, runners.
---

# CI/CD Pipelines Skill

Manage GitHub Actions workflows and GitLab CI pipeline configurations.

## When This Skill MUST Be Used

**ALWAYS invoke this skill when:**
- Editing `.gitlab-ci.yml` or `.github/workflows/*.yml` files
- User mentions CI/CD, pipelines, GitHub Actions, or GitLab CI
- Asking how to test, build, or deploy (when referring to automation)
- Debugging pipeline failures or configuration issues
- Writing new workflows or pipeline jobs
- Asking "how does the CI work" or "what happens when I push"
- Discussing automated testing, deployment, or release processes

## Overview

This skill covers two major CI/CD platforms:
- **GitHub Actions**: Workflows in `.github/workflows/*.yml`
- **GitLab CI**: Pipelines in `.gitlab-ci.yml`

Both use YAML configuration to define automated workflows triggered by repository events.

## GitHub Actions

### File Location
`.github/workflows/*.yml` (e.g., `.github/workflows/ci.yml`, `.github/workflows/deploy.yml`)

### Basic Structure

```yaml
name: CI Pipeline

# Triggers
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

# Environment variables
env:
  NODE_VERSION: '18'

# Jobs
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run tests
        run: npm test

  build:
    runs-on: ubuntu-latest
    needs: test  # Dependency
    steps:
      - uses: actions/checkout@v4
      - name: Build
        run: npm run build
```

### Key Components

**Triggers (on):**
```yaml
on:
  push:
    branches: [main]
    paths:
      - 'src/**'
  pull_request:
  schedule:
    - cron: '0 0 * * *'  # Daily at midnight
  workflow_dispatch:  # Manual trigger
```

**Jobs:**
```yaml
jobs:
  job-name:
    runs-on: ubuntu-latest  # Runner
    needs: [other-job]  # Dependencies
    if: github.ref == 'refs/heads/main'  # Condition
    steps:
      - name: Step name
        run: command
```

**Steps:**
```yaml
steps:
  # Checkout code
  - uses: actions/checkout@v4

  # Run commands
  - name: Run script
    run: |
      echo "Multi-line"
      ./script.sh

  # Use actions
  - uses: actions/setup-node@v4
    with:
      node-version: '18'

  # Set environment variables
  - name: Set env
    run: echo "VAR=value" >> $GITHUB_ENV
```

**Secrets and variables:**
```yaml
steps:
  - name: Deploy
    run: ./deploy.sh
    env:
      API_KEY: ${{ secrets.API_KEY }}
      ENV_NAME: ${{ vars.ENVIRONMENT }}
```

**Matrix builds:**
```yaml
jobs:
  test:
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
        node: [16, 18, 20]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node }}
```

**Artifacts:**
```yaml
steps:
  # Upload artifacts
  - uses: actions/upload-artifact@v4
    with:
      name: build-output
      path: dist/

  # Download artifacts (in another job)
  - uses: actions/download-artifact@v4
    with:
      name: build-output
```

**Caching:**
```yaml
steps:
  - uses: actions/cache@v4
    with:
      path: ~/.npm
      key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
```

### Common Patterns

**Test on multiple versions:**
```yaml
name: Test
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [16, 18, 20]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
      - run: npm ci
      - run: npm test
```

**Deploy on release:**
```yaml
name: Deploy
on:
  release:
    types: [published]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Deploy to production
        run: ./deploy.sh
        env:
          DEPLOY_KEY: ${{ secrets.DEPLOY_KEY }}
```

**Conditional job execution:**
```yaml
jobs:
  deploy:
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    runs-on: ubuntu-latest
    steps:
      - run: ./deploy.sh
```

## GitLab CI

### File Location
`.gitlab-ci.yml` (root of repository)

### Basic Structure

```yaml
# Stages definition
stages:
  - build
  - test
  - deploy

# Variables
variables:
  NODE_VERSION: "18"

# Jobs
build:
  stage: build
  image: node:18
  script:
    - npm ci
    - npm run build
  artifacts:
    paths:
      - dist/

test:
  stage: test
  image: node:18
  script:
    - npm test

deploy:
  stage: deploy
  script:
    - ./deploy.sh
  only:
    - main
```

### Key Components

**Stages:**
```yaml
stages:
  - build
  - test
  - deploy
  - release
```

**Jobs:**
```yaml
job-name:
  stage: test
  image: node:18  # Docker image
  before_script:
    - npm ci
  script:
    - npm test
  after_script:
    - cleanup.sh
  only:  # When to run
    - main
    - merge_requests
  except:  # When NOT to run
    - tags
```

**Rules (modern alternative to only/except):**
```yaml
deploy:
  script: ./deploy.sh
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      when: manual
```

**Artifacts:**
```yaml
build:
  script:
    - make build
  artifacts:
    paths:
      - build/
      - dist/
    expire_in: 1 week
    when: on_success
```

**Cache:**
```yaml
test:
  cache:
    key: ${CI_COMMIT_REF_SLUG}
    paths:
      - node_modules/
      - .npm/
  script:
    - npm ci
    - npm test
```

**Services (for databases, etc.):**
```yaml
test:
  image: node:18
  services:
    - postgres:14
  variables:
    POSTGRES_DB: testdb
    POSTGRES_USER: user
    POSTGRES_PASSWORD: password
  script:
    - npm test
```

**Needs (DAG - run jobs out of stage order):**
```yaml
stages:
  - build
  - test

test-unit:
  stage: test
  needs: ["build"]
  script: npm run test:unit

test-integration:
  stage: test
  needs: ["build"]
  script: npm run test:integration
```

**Extends and templates:**
```yaml
.test-template:
  image: node:18
  before_script:
    - npm ci

unit-test:
  extends: .test-template
  script:
    - npm run test:unit

integration-test:
  extends: .test-template
  script:
    - npm run test:integration
```

**Environment deployments:**
```yaml
deploy-staging:
  stage: deploy
  script: ./deploy.sh staging
  environment:
    name: staging
    url: https://staging.example.com

deploy-production:
  stage: deploy
  script: ./deploy.sh production
  environment:
    name: production
    url: https://example.com
  when: manual
  only:
    - main
```

### Common Patterns

**Parallel matrix:**
```yaml
test:
  parallel:
    matrix:
      - NODE_VERSION: ["16", "18", "20"]
        OS: ["ubuntu", "alpine"]
  image: node:${NODE_VERSION}-${OS}
  script:
    - npm test
```

**Multi-project pipeline:**
```yaml
trigger-downstream:
  stage: deploy
  trigger:
    project: group/downstream-project
    branch: main
```

**Manual approval:**
```yaml
deploy-production:
  stage: deploy
  script: ./deploy.sh
  when: manual
  only:
    - main
```

## Reading and Understanding Pipelines

When a user asks about CI/CD or project automation:

1. **Check for CI/CD configurations:**
   - Look for `.github/workflows/*.yml` (GitHub Actions)
   - Look for `.gitlab-ci.yml` (GitLab CI)

2. **Parse the structure:**
   - **GitHub Actions:** Identify triggers, jobs, steps, dependencies
   - **GitLab CI:** Identify stages, jobs, rules, artifacts

3. **Understand the flow:**
   - What triggers the pipeline (push, PR, manual, schedule)
   - What stages/jobs run and in what order
   - What each job does (build, test, deploy, etc.)
   - What dependencies exist between jobs
   - What artifacts are created and used

4. **Present findings:**
   - Explain what happens when code is pushed
   - List all jobs and their purposes
   - Note any manual steps or approvals needed
   - Explain deployment process if present

### Example Analysis Process

User asks: "What happens when I push to main?"

**Step 1:** Read `.github/workflows/ci.yml`
```yaml
on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm test

  deploy:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - run: ./deploy.sh
```

**Step 2:** Analyze
- Triggered on push to main
- First runs `test` job
- If test passes, runs `deploy` job
- Deploy runs deployment script

**Step 3:** Respond
"When you push to main:
1. The CI pipeline triggers automatically
2. Tests run first (`npm test`)
3. If tests pass, deployment runs (`./deploy.sh`)
4. If tests fail, deployment is skipped"

## Writing Pipeline Configurations

### Best Practices

**1. Use caching to speed up builds:**
```yaml
# GitHub Actions
- uses: actions/cache@v4
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}

# GitLab CI
cache:
  key: ${CI_COMMIT_REF_SLUG}
  paths:
    - node_modules/
```

**2. Fail fast with dependency chains:**
```yaml
# GitHub Actions
jobs:
  test:
    runs-on: ubuntu-latest
  deploy:
    needs: test  # Only runs if test succeeds

# GitLab CI
test:
  stage: test
deploy:
  stage: deploy  # Runs after test stage
```

**3. Use secrets for sensitive data:**
```yaml
# GitHub Actions
env:
  API_KEY: ${{ secrets.API_KEY }}

# GitLab CI (set in Settings > CI/CD > Variables)
script:
  - echo $API_KEY
```

**4. Add manual gates for production:**
```yaml
# GitHub Actions
deploy-prod:
  environment:
    name: production
  # Requires approval in GitHub settings

# GitLab CI
deploy-prod:
  when: manual
  only:
    - main
```

**5. Use meaningful job and step names:**
```yaml
# Good
- name: Run unit tests with coverage
  run: npm run test:coverage

# Bad
- run: npm test
```

**6. Use matrix builds for multi-version testing:**
```yaml
# Test across versions
strategy:
  matrix:
    node: [16, 18, 20]
    os: [ubuntu-latest, macos-latest]
```

## Common CI/CD Variables

### GitHub Actions
```
github.ref          # refs/heads/main
github.sha          # Commit SHA
github.actor        # User who triggered
github.event_name   # push, pull_request, etc.
runner.os           # Linux, macOS, Windows
```

### GitLab CI
```
CI_COMMIT_BRANCH       # Branch name
CI_COMMIT_SHA          # Commit SHA
CI_COMMIT_TAG          # Tag name (if applicable)
CI_PIPELINE_SOURCE     # push, merge_request_event, etc.
CI_PROJECT_DIR         # Working directory
```

## Troubleshooting

| Issue | Platform | Solution |
|-------|----------|----------|
| Job fails silently | Both | Check job logs, add `set -x` for debug output |
| Artifacts not found | Both | Ensure upload/download names match, check paths |
| Cache not working | Both | Verify cache key, check path correctness |
| Secrets not available | GitHub | Check secret name, ensure it's set in repo settings |
| Job doesn't run | GitLab | Check `only`/`except`/`rules`, verify stage exists |
| Dependency issues | Both | Use caching, lock files (package-lock.json, etc.) |

## Decision Framework

**When user asks about CI/CD:**
1. ✅ Check for `.github/workflows/*.yml` and `.gitlab-ci.yml`
2. ✅ Determine which platform is in use
3. ✅ Read configuration and explain workflow

**When writing new configurations:**
1. ✅ Check existing patterns in the project
2. ✅ Use appropriate platform syntax (GitHub Actions vs GitLab CI)
3. ✅ Follow best practices (caching, secrets, manual gates)
4. ✅ Test locally if possible (act for GitHub Actions, gitlab-runner for GitLab)

**When modifying configurations:**
1. ✅ Read existing configuration first
2. ✅ Understand current workflow
3. ✅ Make minimal necessary changes
4. ✅ Preserve existing style and patterns
5. ✅ Consider impact on existing pipelines

## Platform Detection

**When helping with CI/CD, determine platform by:**
1. Check for `.github/workflows/` directory → GitHub Actions
2. Check for `.gitlab-ci.yml` file → GitLab CI
3. If both exist, ask user which they want to work with
4. If neither exists, ask which platform they use

## Example User Interactions

**Example 1: User asks what runs on push**
```
User: "What happens when I push code?"
Assistant: [Reads .github/workflows/ci.yml]
"When you push code to any branch:
1. Lint job runs to check code style
2. Test job runs unit tests in parallel with lint
3. If both pass and you're on 'main', deploy job runs
4. Deploy pushes to staging environment

The full pipeline takes about 5 minutes."
```

**Example 2: User wants to add deployment**
```
User: "Can you add a production deployment step?"
Assistant: [Reads existing .gitlab-ci.yml]
"I'll add a production deployment job to your .gitlab-ci.yml:

deploy-production:
  stage: deploy
  script:
    - ./deploy.sh production
  environment:
    name: production
    url: https://example.com
  when: manual
  only:
    - main

This requires manual approval and only runs on the main branch."
```

**Example 3: User debugging CI failure**
```
User: "Why is my CI failing on the build step?"
Assistant: [Reads .github/workflows/build.yml and checks logs]
"Your build is failing because:
1. The 'dist/' directory doesn't exist before upload-artifact
2. The build step needs to run before uploading

Fix: Add 'mkdir -p dist' before the build command, or ensure the build script creates the directory."
```
