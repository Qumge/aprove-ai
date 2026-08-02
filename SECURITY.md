# Security Policy

中文:请勿通过公开 Issue 报告安全漏洞,改为私下联系维护者。

## Supported versions

Aprove AI is an actively developed application rather than a versioned library.
Security fixes are applied to the latest state of the default branch. Please
make sure you are running the most recent version before reporting an issue.

## Reporting a vulnerability

**Please do not report security vulnerabilities through public GitHub issues,
discussions, or pull requests.**

Instead, report them privately using one of the following channels:

- Use GitHub's [private vulnerability reporting](https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing-information-about-vulnerabilities/privately-reporting-a-security-vulnerability)
  ("Report a vulnerability" under the repository's **Security** tab), or
- Contact the repository maintainers privately.

Please include as much of the following as you can:

- A description of the vulnerability and its potential impact.
- Steps to reproduce or a proof of concept.
- Affected components, endpoints, or configuration.
- Any suggested remediation.

## What to expect

- We will acknowledge your report as soon as possible.
- We will investigate and keep you informed of our progress.
- Once a fix is available, we will coordinate disclosure with you and credit you
  if you wish.

## Handling secrets

This project reads sensitive configuration from environment variables. When
reporting or reproducing an issue, never include real credentials. Operators
should follow the guidance in the README:

- Never commit `.env`, Rails master keys, credentials keys, database dumps, or
  cloud access keys.
- Use a unique `SECRET_KEY_BASE` and a strong `APROVE_DEMO_PASSWORD` in
  production.
- Rotate any credential that has previously appeared in source control.
