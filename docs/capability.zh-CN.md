# 用 Agent 核对订单、发货与回款

[English](capability.en.md) | [简体中文](capability.zh-CN.md)

上传订单、发货与回款 CSV/XLSX，指定截止日期，取得差异、无法匹配的记录、分币种汇总及来源行号。

完整流程见 [Qumge 工业文件任务指南](https://qumge.com/zh/docs/industrial)，包括实时可用状态、列映射、私有上传、费用授权和报告下载。无需安装本项目；需要持续管理业务记录与协作时，可以使用本项目的完整管理流程。

1. 让 Agent 在 Qumge 搜索 `order reconciliation`，读取匹配的已上线契约与当前价格；没有匹配操作则停止。
2. 先用 [examples/industrial](../examples/industrial) 中的合成 CSV 样例，不含客户数据。
3. 使用调用方买家的 Qumge key，向 `POST https://qumge.com/v1/industrial/files` 上传每份文件。标识符按文本保留，显式映射表头；样例用英文字段，实际文件可以使用中文表头。
4. 取得费用授权后，将 file_id 传给 `aprove-order-reconciliation` 的 `reconcile_orders` 操作。重试相同输入时复用幂等标识，轮询返回的平台任务 ID。
5. 使用同一买家 key 或已登录该买家账户的浏览器下载私有 Excel／JSON，并按来源行核查结果。

限制：UTF-8 CSV／XLSX，每份 512 KiB、2,000 行数据、32 列；多工作表 XLSX 需指定工作表。公式先导出为值，日期存成 ISO 文本。文件及报告 24 小时后过期。Qumge 不会把这两个操作的文件内容交给模型。上传需要你明确发起，自部署应用不会自动上传业务数据。

订单主表每个订单一行，显式映射数量、金额、币种和日期，并指定截止日。不同币种分别计算，不换汇、不入账。样例截至 2026-11-01 有一笔币种不符、一笔未知订单，以及一笔较晚发货被排除。此任务不判断合同收款权利。

托管 Cap 的可用状态与价格独立于本 MIT 开源项目。合成样例和连通性检查不代表生产付费交付验证。
