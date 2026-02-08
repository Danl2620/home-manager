---
name: Justfile
description: >
  REQUIRED when working with Justfiles or project task execution. Use when
  editing, reading, or creating justfile or Justfile files. Triggers: just,
  justfile, recipes, tasks, how to build, how to test, how to run, how to
  deploy, project automation, task runner, make alternative, available tasks,
  list tasks, run tasks.
---

# Justfile Skill

Manage [Just](https://just.systems/) task runner configurations and recipes.

## When This Skill MUST Be Used

**ALWAYS invoke this skill when:**
- The user mentions `justfile`, `Justfile`, or `just` commands
- Reading or parsing a justfile to understand available tasks
- Asking how to build, test, run, deploy, or perform project tasks
- Writing new recipes or modifying existing justfile configurations
- Debugging justfile syntax or recipe execution
- Asking "what tasks are available" or "how do I run X"

## What is Just?

Just is a command runner and modern alternative to Make. It uses a `justfile` or `Justfile` to define recipes (tasks) that can be executed with the `just` command.

Key features:
- Simple, intuitive syntax
- Cross-platform (works on Linux, macOS, Windows)
- Supports variables, parameters, dependencies, and conditionals
- No tab-sensitivity (unlike Make)
- Built-in help system

## Justfile Syntax Overview

### Basic Recipe Structure

```just
# Recipe with no parameters
recipe-name:
    command1
    command2

# Recipe with parameters
recipe-with-args param1 param2:
    echo "{{param1}} {{param2}}"

# Recipe with default parameters
recipe-with-defaults name="world":
    echo "Hello {{name}}"

# Recipe with dependencies (runs dependency first)
test: build
    cargo test
```

### Key Syntax Elements

**Variables:**
```just
# Set at top of file
version := "1.0.0"
build_dir := "target"

# Use in recipes
build:
    mkdir -p {{build_dir}}
```

**Comments:**
```just
# This is a comment
recipe: # inline comment
    echo "task"
```

**Recipe documentation:**
```just
# Build the project for production
build:
    cargo build --release
```

**Multi-line strings:**
```just
deploy:
    echo '''
    Deploying version {{version}}
    to production
    '''
```

**Conditionals:**
```just
test:
    #!/bin/bash
    if [ -f "Cargo.toml" ]; then
        cargo test
    else
        npm test
    fi
```

**Shell selection:**
```just
# Use specific shell for a recipe
recipe:
    #!/usr/bin/env python3
    print("Hello from Python")
```

### Common Recipe Patterns

**Default recipe (runs when `just` is called with no args):**
```just
# List available recipes
default:
    @just --list
```

**List recipes with descriptions:**
```just
# Show this help message
help:
    @just --list --unsorted
```

**Chain multiple recipes:**
```just
# Run all checks before committing
pre-commit: fmt lint test
    echo "All checks passed!"
```

**Recipes with error handling:**
```just
# Build and notify on completion
build:
    cargo build || (echo "Build failed!" && exit 1)
    echo "Build succeeded!"
```

**Platform-specific recipes:**
```just
# Install dependencies (Linux)
[linux]
install:
    apt-get install dependencies

# Install dependencies (macOS)
[macos]
install:
    brew install dependencies
```

**Private recipes (don't show in --list):**
```just
# Public recipe
public:
    echo "visible"

# Private recipe (starts with _)
_private:
    echo "hidden"
```

## Reading and Understanding Justfiles

When a user asks about project tasks or how to perform actions:

1. **ALWAYS check for a justfile first:**
   - Look for `justfile` or `Justfile` in the current directory
   - If found, read it to understand available tasks

2. **Parse the justfile structure:**
   - Identify all recipe names (non-indented lines ending with `:`)
   - Look for comments above recipes (these are descriptions)
   - Note recipe parameters and dependencies
   - Identify the default recipe (if any)

3. **Present findings to the user:**
   - List available tasks with their descriptions
   - Explain what each task does based on commands
   - Note any dependencies between tasks
   - Suggest which task matches the user's goal

### Example Analysis Process

If user asks: "How do I test this project?"

**Step 1:** Read justfile
```just
# Run all tests
test: build
    cargo test --all

# Build the project
build:
    cargo build
```

**Step 2:** Analyze
- Found `test` recipe that runs `cargo test --all`
- Has dependency on `build` recipe
- Will build first, then test

**Step 3:** Respond
"To test this project, run: `just test`

This will:
1. First run the `build` recipe to compile the project
2. Then run all tests with `cargo test --all`"

## Writing Justfile Recipes

When helping users create new recipes:

1. **Use clear, descriptive names:**
   - Good: `test`, `build-docker`, `deploy-staging`
   - Bad: `t`, `bd`, `dplstg`

2. **Add documentation comments:**
   ```just
   # Build Docker image for production
   build-docker:
       docker build -t myapp:latest .
   ```

3. **Use parameters for flexibility:**
   ```just
   # Deploy to specified environment
   deploy env="staging":
       ./deploy.sh {{env}}
   ```

4. **Set up dependencies correctly:**
   ```just
   # Deploy (builds and tests first)
   deploy: build test
       ./deploy.sh
   ```

5. **Use @ to suppress command echo:**
   ```just
   # Clean build artifacts
   clean:
       @echo "Cleaning..."
       @rm -rf target/
   ```

6. **Provide sensible defaults:**
   ```just
   # Set default recipe to show help
   default:
       @just --list
   ```

## Best Practices

1. **Always include a default recipe** that lists available tasks or shows help
2. **Add comments above recipes** to explain what they do
3. **Use variables** for repeated values (versions, paths, etc.)
4. **Chain related tasks** using dependencies
5. **Use `@` prefix** to hide noise from commands that just print output
6. **Group related recipes** with comments
7. **Use `set` directives** for justfile-wide settings:
   ```just
   set dotenv-load  # Load .env file automatically
   set shell := ["bash", "-uc"]  # Use bash for all recipes
   ```

## Suggesting Tasks Based on User Needs

When a user asks to perform an action:

| User Request | Steps to Help |
|--------------|---------------|
| "How do I build?" | 1. Read justfile<br>2. Look for `build`, `compile`, or similar recipes<br>3. Suggest: `just build` |
| "How do I test?" | 1. Read justfile<br>2. Look for `test`, `check`, or `ci` recipes<br>3. Explain what the test recipe does |
| "How do I deploy?" | 1. Read justfile<br>2. Find `deploy`, `release`, or `publish` recipes<br>3. Check if it needs parameters (e.g., environment) |
| "What can I do?" | 1. Read justfile<br>2. Run `just --list` mentally or suggest user runs it<br>3. Summarize available tasks with descriptions |

## Common Just Commands

```bash
# List all available recipes
just --list

# Show justfile with line numbers
just --show

# Run a recipe
just recipe-name

# Run a recipe with parameters
just deploy staging

# Set variables from command line
just --set version 2.0.0 build

# Run justfile from different directory
just --working-directory /path/to/project recipe

# Use different justfile
just --justfile custom.just recipe
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Recipe not found | Check spelling, check if recipe is in justfile |
| Command failed | Check if dependencies are installed, verify commands work standalone |
| Variable not set | Define variable at top of justfile or pass via `--set` |
| Indentation error | Use spaces or tabs consistently (just accepts both) |
| Shell syntax error | Verify shell commands work in terminal first |

## Decision Framework

**When user asks about project tasks:**
1. ✅ Check if justfile exists in project
2. ✅ If yes: Read justfile and suggest appropriate recipe
3. ✅ If no: Check for other task runners (Makefile, package.json scripts, etc.)

**When writing new recipes:**
1. ✅ Check if similar recipe already exists
2. ✅ Use existing patterns from the justfile
3. ✅ Add documentation comment
4. ✅ Test recipe syntax before suggesting

**When modifying recipes:**
1. ✅ Read existing recipe first
2. ✅ Understand current behavior
3. ✅ Make minimal necessary changes
4. ✅ Preserve existing style and patterns

## Example User Interactions

**Example 1: User asks what tasks are available**
```
User: "What tasks can I run in this project?"
Assistant: [Reads justfile] "This project has the following tasks:
- just build: Compile the project
- just test: Run all tests (builds first)
- just fmt: Format code
- just lint: Run linter
- just deploy <env>: Deploy to specified environment (staging/production)
"
```

**Example 2: User asks how to do something**
```
User: "How do I deploy to staging?"
Assistant: [Reads justfile, finds deploy recipe with env parameter]
"Run: just deploy staging

This will execute the deployment script with staging configuration."
```

**Example 3: User wants to add a new task**
```
User: "Can you add a task to run the database migrations?"
Assistant: [Reads justfile to understand style and patterns]
"I'll add a migrate recipe to your justfile:

# Run database migrations
migrate:
    ./scripts/migrate.sh

This follows the pattern of other tasks in your justfile. Run it with: just migrate"
```
