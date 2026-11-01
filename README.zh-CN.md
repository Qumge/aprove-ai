[English](README.md) | [简体中文](README.zh-CN.md)

# Aprove AI

支持中英文界面的开源项目运营平台，基于 Ruby on Rails，把项目、审批、订单、发票、伙伴、费用、文件和报表放在同一个工作区。

## 只想做一个文件小任务？交给你的 Agent

上传订单、发货与回款 CSV/XLSX，指定截止日期，取得差异、无法匹配的记录、分币种汇总及来源行号。

这是由 Qumge 自营的可选配套能力，**无需安装本项目**。你的 Agent 先确认能力当前已上线及实际价格，再上传你允许处理的文件，在费用授权范围内调用，取得私有 Excel 和 JSON 报告。

- [任务指南、限制与可用状态](https://qumge.com/zh/docs/industrial)
- [合成样例与 Agent 操作说明](docs/capability.zh-CN.md) · [English guide](docs/capability.en.md)

自部署应用继续按 MIT 许可独立使用，不会自动向 Qumge 发送公司资料。托管 Cap 按独立公布的结果价格计费，报告 24 小时后过期。README 样例不代表能力已上线或已经过生产付费验证。

## 功能

- 项目生命周期与审批流程
- 订单、交付、回款与发票管理
- 伙伴、合同、产品与费用管理
- 培训与竞品资料库
- 运营报表与基于角色的权限控制
- 中文及英文界面
- 开发环境使用本地存储，生产可配置 Cloudflare R2

## 环境要求

Ruby 4.0.1、Rails 8.1、PostgreSQL。

## 安装

```bash
git clone https://github.com/Qumge/aprove-ai.git
cd aprove-ai
bundle install
bin/rails db:prepare
bin/rails db:seed
bin/rails server
```

访问 <http://127.0.0.1:3000>。开发种子数据创建管理员：账号 `demo_admin`，密码 `AproveDemo2026!`。
可在 seed 前设置 `APROVE_DEMO_PASSWORD` 改为自己的密码；生产 seed 必须显式提供该变量。

## 配置

应用从环境变量读取设置，完整清单见 [.env.example](.env.example)。开发环境默认 PostgreSQL 和本地文件存储无需环境文件即可运行。

### PostgreSQL

生产使用 `DATABASE_URL`，也可配置 `POSTGRES_HOST`、`POSTGRES_PORT`、`POSTGRES_USER`、`POSTGRES_PASSWORD`、`POSTGRES_DB`。生产默认开启 HTTPS；只有可信内部代理已处理连接时，才设置 `FORCE_SSL=false`。

### 文件存储

开发和测试默认 `UPLOAD_STORAGE=local`。使用 Cloudflare R2 时配置：

```bash
UPLOAD_STORAGE=r2
R2_ACCOUNT_ID=
R2_ACCESS_KEY_ID=
R2_SECRET_ACCESS_KEY=
R2_BUCKET=
R2_PUBLIC_URL=
```

`R2_PUBLIC_URL` 可选；私有桶使用签名下载地址。浏览器上传需要 R2 CORS 允许应用来源的 `PUT` 请求及 `Content-Type` 请求头。SMTP、Submail 短信及异常通知设置均为可选，见 `.env.example`。

## 测试

```bash
bin/rails test
bin/rails zeitwerk:check
bundle exec brakeman --no-pager
bundle exec bundler-audit check --update
```

## 安全

不要提交 `.env`、Rails master key、凭证、数据库备份或云访问密钥。生产使用唯一的 `SECRET_KEY_BASE` 和强 `APROVE_DEMO_PASSWORD`，轮换曾进入版本库的凭证。安全问题请私下报告维护者，不要公开提交含敏感细节的 issue。

## 许可证

[MIT](LICENSE)。
