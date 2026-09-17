# Aprove AI

A bilingual, open-source project operations platform built with Ruby on Rails.
It brings projects, approvals, orders, invoices, partners, expenses, files, and
reports into one workspace.

中文：Aprove AI 是一个支持中英文界面的开源项目运营与审批平台。

## Features

- Project lifecycle and approval workflows
- Order, delivery, payment, and invoice management
- Partner, contract, product, and expense management
- Training and competitor-material libraries
- Operational reports and role-based access control
- Chinese and English interfaces
- Local file storage for development and Cloudflare R2 for production

## Requirements

- Ruby 4.0.1
- Rails 8.1
- PostgreSQL

## Setup

```bash
git clone https://github.com/Qumge/aprove-ai.git
cd aprove-ai
bundle install
bin/rails db:prepare
bin/rails db:seed
bin/rails server
```

Open <http://127.0.0.1:3000>.

The development seed creates a local administrator:

- Account: `demo_admin`
- Password: `AproveDemo2026!`

Set `APROVE_DEMO_PASSWORD` before seeding to use a different password. It is
required when seeding in production.

## Configuration

The app reads configuration from environment variables. `.env.example` lists
all supported settings and can be used with your preferred environment manager.
Local PostgreSQL and file-storage defaults work without an environment file.

### PostgreSQL

Use `DATABASE_URL` in production, or configure `POSTGRES_HOST`,
`POSTGRES_PORT`, `POSTGRES_USER`, `POSTGRES_PASSWORD`, and `POSTGRES_DB`.
HTTPS is enabled by default in production; set `FORCE_SSL=false` only when a
trusted internal proxy handles the connection.

### File Storage

Local storage is the default in development and test:

```bash
UPLOAD_STORAGE=local
```

For Cloudflare R2, set:

```bash
UPLOAD_STORAGE=r2
R2_ACCOUNT_ID=
R2_ACCESS_KEY_ID=
R2_SECRET_ACCESS_KEY=
R2_BUCKET=
R2_PUBLIC_URL=
```

`R2_PUBLIC_URL` is optional. Private buckets use signed download URLs. Browser
uploads require an R2 CORS policy that allows `PUT` from the application origin
and permits the `Content-Type` request header.

SMTP, Submail SMS, and exception notification settings are optional and
documented in `.env.example`.

## Testing

```bash
bin/rails test
bin/rails zeitwerk:check
bundle exec brakeman --no-pager
bundle exec bundler-audit check --update
```

## Security

- Never commit `.env`, Rails master keys, credentials keys, database dumps, or
  cloud access keys.
- Use a unique `SECRET_KEY_BASE` and strong `APROVE_DEMO_PASSWORD` in production.
- Rotate any credential that has previously appeared in source control.

Please report security issues privately to the repository maintainers rather
than opening a public issue.

## License

Released under the [MIT License](LICENSE).
