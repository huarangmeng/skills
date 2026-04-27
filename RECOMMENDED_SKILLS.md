# 推荐 Skills 使用说明（本地优先）

本文档汇总当前仓库里推荐你日常独立开发使用的 skills，重点是“本地优先、可落盘、便于迭代”，避免依赖 GitHub issue 工作流。

## 产物目录约定（统一写入 docs/）

- `docs/prd/`：PRD / 规格说明（需求沉淀）
- `docs/issues/`：任务单 / 问题单（可执行切片）
- `docs/refactors/`：重构计划（按极小提交拆分）
- `docs/out-of-scope/`：明确不做的增强概念（用于去重和避免反复讨论）

建议：将 `docs/` 纳入版本管理，这样每次迭代的 PRD/Issue/决策都可追溯。

## 推荐：本地优先工作流（强烈建议优先用）

### 1) to-prd-local（需求沉淀为 PRD）

- 作用：把当前对话中的需求、约束、范围、测试决策整理成 PRD，并写入 `docs/prd/`。
- 怎么用：当你把需求讲清楚后调用 `to-prd-local`，它会直接生成一个 PRD 文件（例如 `docs/prd/YYYYMMDD-xxx.md`）并返回路径。
- 适合场景：独立开发前先写清楚“要做什么/不做什么/如何验收”，避免边写边改导致返工。

对应定义：`to-prd-local/SKILL.md`

### 2) to-issues-local（PRD -> 可执行切片任务单）

- 作用：把 PRD/计划拆成 tracer-bullet 的“垂直切片”，每个切片一张任务单，写入 `docs/issues/`。
- 怎么用：
  1. 先有一份 PRD（通常来自 `to-prd-local`）
  2. 调用 `to-issues-local`，并把 PRD 路径（例如 `docs/prd/...md`）作为输入参考
  3. 它会输出一组任务单文件路径（依赖顺序可引用“Blocked by”）
- 适合场景：把“大需求”拆成“小步可验证”的序列，支持并行或按优先级推进。

对应定义：`to-issues-local/SKILL.md`

### 3) triage-issue-local（Bug 根因分析 + TDD 修复计划）

- 作用：对 bug 做定位与根因分析，并输出可执行的 TDD 修复步骤（RED/GREEN 切片），写入 `docs/issues/`。
- 怎么用：你描述“看到的问题是什么”，它会先探索代码（尽量复现/定位路径），再落盘一张包含：
  - Problem（现象/期望/复现）
  - Root Cause Analysis（根因，避免写死文件路径）
  - TDD Fix Plan（按切片）
  - Acceptance Criteria（验收条件）
- 适合场景：你不想立刻修但希望把调查结论沉淀成“未来可直接开干”的工单。

对应定义：`triage-issue-local/SKILL.md`

### 4) request-refactor-plan-local（重构计划：极小提交序列）

- 作用：把一次重构通过访谈澄清范围与风险，拆成“每步都能保持可运行”的极小提交计划，写入 `docs/refactors/`。
- 怎么用：你描述想解决的结构问题/坏味道/目标（例如解耦、提升可测性），它会：
  - 追问范围与替代方案
  - 检查相关区域测试覆盖
  - 输出一份分步骤的 commit 计划（每步都可验证）
- 适合场景：大重构、架构调整、想降低回滚成本。

对应定义：`request-refactor-plan-local/SKILL.md`

### 5) qa-local（对话式 QA 记录为 docs/issues/）

- 作用：你边自测边报问题，它边澄清边探索代码背景，然后把每个问题落盘成可复现的 issue，写入 `docs/issues/`。
- 怎么用：开始 QA session 后逐条描述问题；它每条最多问 2-3 个关键澄清问题，然后直接生成对应 issue 文件并返回路径。
- 适合场景：独立开发/自测阶段快速堆积问题池，同时保证每条都有复现步骤与验收描述。

对应定义：`qa-local/SKILL.md`

### 6) work-item-triage（本地 Inbox/状态机分拣）

- 作用：扫描 `docs/` 下的任务单/问题单，用轻量状态机推进（`needs-triage/needs-info/ready-for-agent/ready-for-human/wontfix`），并支持写入“Implementation Brief”（可交给 agent 或未来自己实现）。
- 怎么用：
  - “给我一个需要关注的概览”：它会按缺字段、待分拣、待补信息等分组列出
  - “看某个任务单”：给它 `docs/issues/...md` 路径，它会给出分类/状态建议，并按你的指令更新文件
  - “决定不做某增强”：它会引导你写入 `docs/out-of-scope/`，用于后续相似需求去重
- 适合场景：你不使用 GitHub issue，但仍需要一个可维护的本地任务流转与“ready-to-implement”标准。

对应定义：`work-item-triage/SKILL.md`（参考：`work-item-triage/AGENT-BRIEF.md`、`work-item-triage/OUT-OF-SCOPE.md`）

## 推荐：设计/代码质量（不绑定 GitHub）

### tdd（测试驱动：红绿重构）

- 作用：按“一个行为一个测试一个实现”的垂直切片推进，避免横切导致测试脆弱。
- 怎么用：当你要新增功能或修 bug，明确对外行为与优先级后使用 `tdd` 驱动实现。
- 适合场景：你追求产物抗重构、测试更像规格说明。

对应定义：`tdd/SKILL.md`

### improve-codebase-architecture（架构加深：deep module/seam）

- 作用：找“浅模块”与摩擦点，给出可提升局部性/可测性的加深改造候选。
- 怎么用：当你感觉某块代码难懂、难测、改动扩散时，使用它先给候选列表，再选一个深入讨论。
- 适合场景：系统性整理结构而不是“点修补”。

对应定义：`improve-codebase-architecture/SKILL.md`

### design-an-interface（接口设计：Design it twice）

- 作用：并行产出多种“差异足够大”的接口方案并对比，降低第一次设计就锁死的风险。
- 怎么用：在抽模块/定 API 前使用；先给需求与约束，再看多个方案对比后做取舍。
- 适合场景：抽象边界不清、担心 shallow module、需要选一个更稳的接口形态。

对应定义：`design-an-interface/SKILL.md`

### domain-model / ubiquitous-language（术语与边界）

- 作用：把对话里的概念抽成一致术语、关系与边界，并可落到 `CONTEXT.md` / `UBIQUITOUS_LANGUAGE.md`。
- 怎么用：当命名混乱、概念混用、边界不清时使用，先统一语言再写代码。
- 适合场景：长期维护的项目；你希望“架构/文档先行”。

对应定义：`domain-model/SKILL.md`、`ubiquitous-language/SKILL.md`

### zoom-out（快速要一张地图）

- 作用：让 agent “上一个抽象层”总结模块、调用者与关键路径。
- 怎么用：接手陌生区域、或者感觉自己在细节里迷路时调用。

对应定义：`zoom-out/SKILL.md`

### git-guardrails-claude-code（防危险 git 操作）

- 作用：为 Claude/agent 执行命令加护栏，避免 `push/reset --hard/clean` 等危险操作误触。
- 怎么用：当你经常让 agent 跑命令，且仓库里有重要未提交修改时建议启用。

对应定义：`git-guardrails-claude-code/SKILL.md`

## 不推荐/已排除（按你的偏好）

- TS 强相关：`migrate-to-shoehorn`、`setup-pre-commit`（偏前端/TS 工程化）
- 笔记相关：`obsidian-vault`

