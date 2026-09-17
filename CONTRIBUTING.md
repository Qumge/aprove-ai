# Contributing to Aprove AI

Thanks for your interest in improving Aprove AI! This guide explains how to set
up a development environment, run the checks, and submit changes.

中文:欢迎为 Aprove AI 贡献代码。本文说明如何搭建开发环境、运行检查以及提交变更。

## Code of Conduct

By participating in this project you agree to abide by our
[Code of Conduct](CODE_OF_CONDUCT.md). Please report unacceptable behavior to
the maintainers.

## Getting started

### Requirements

- Ruby (see [`.ruby-version`](.ruby-version))
- Rails 8.1
- PostgreSQL

### Setup

```bash
git clone https://github.com/Qumge/approve-ai.git
cd approve-ai
bin/setup            # installs gems and prepares the database
bin/rails server
```

`bin/setup` runs `bundle install` and `bin/rails db:prepare`. If you prefer to
do it by hand:

```bash
bundle install
bin/rails db:prepare
bin/rails db:seed     # creates the demo administrator (see README)
```

Copy `.env.example` to `.env` if you need to override the local defaults. Never
commit `.env`, master keys, credentials keys, or cloud access keys.

## Running the checks

Please run the full suite locally before opening a pull request. CI runs the
same commands:

```bash
bin/rails test
bin/rails zeitwerk:check
bundle exec brakeman --no-pager
bundle exec bundler-audit check --update
```

- **Tests** — add or update tests for any behavior you change. New features and
  bug fixes should come with coverage.
- **`zeitwerk:check`** — verifies autoloading; keep file and class names aligned.
- **Brakeman** — static security analysis. Do not introduce new warnings.
- **bundler-audit** — checks dependencies for known CVEs.

## Making changes

1. **Fork** the repository and create a topic branch from the default branch:
   `git checkout -b my-feature`.
2. Keep commits focused and write clear, descriptive commit messages.
3. Match the style of the surrounding code. This is a Rails app that leans on
   Sprockets, Bootstrap 3, and jQuery — follow the existing conventions rather
   than introducing new frameworks in a single PR.
4. Keep user-facing strings translatable. The app supports Chinese and English
   interfaces, so add new copy to the appropriate locale files instead of
   hard-coding text.
5. Update documentation (README, `.env.example`, this guide) when your change
   affects setup, configuration, or behavior.
6. Add an entry to [`CHANGELOG.md`](CHANGELOG.md) under the "Unreleased"
   section.

## Submitting a pull request

1. Push your branch and open a pull request against the default branch.
2. Fill in the pull request template, describing **what** changed and **why**,
   and how you tested it.
3. Make sure CI is green. Maintainers may request changes; please be responsive
   to review feedback.
4. Link any related issues (for example, `Closes #123`).

## Reporting bugs and requesting features

Use the GitHub issue templates:

- **Bug report** — include steps to reproduce, expected vs. actual behavior, and
  your environment.
- **Feature request** — describe the problem you are trying to solve, not just a
  proposed solution.

For **security vulnerabilities**, do **not** open a public issue. Follow the
process in [`SECURITY.md`](SECURITY.md).

## License

By contributing, you agree that your contributions will be licensed under the
[MIT License](LICENSE) that covers the project.
