# API 服务层迁移指南

## 📋 概述

本项目已完成从 umi-request 到 axios 的 API 服务层迁移，统一了 HTTP 客户端实现，提高了代码的一致性和可维护性。

## 🔄 迁移内容

### 1. 统一 HTTP 客户端

- **旧方式**: 使用 `umi-request` 和兼容层 `requestCompat.ts`
- **新方式**: 统一使用 `axios` 客户端 (`src/utils/apiClient.ts`)

### 2. 统一服务层

- **旧方式**: 分散的服务文件 (`src/services/demo/UserController.ts`)
- **新方式**: 统一的服务层 (`src/services/index.ts`)

## 🚀 新的 API 使用方式

### 基础用法

```typescript
// 导入统一的 API 服务
import api from '@/services';

// 用户相关操作
const userList = await api.user.getUserList({ current: 1, pageSize: 10 });
const userDetail = await api.user.getUserDetail('123');
const newUser = await api.user.createUser({
  name: 'John',
  email: 'john@example.com',
});
const updatedUser = await api.user.updateUser('123', { name: 'Jane' });
await api.user.deleteUser('123');

// 产品相关操作
const productList = await api.product.getProductList();
const productDetail = await api.product.getProductDetail('456');

// 监控相关操作
const monitoringData = await api.monitoring.getMonitoringData();
const statistics = await api.monitoring.getStatistics();
```

### 兼容性支持

为了保持向后兼容，我们保留了原有的方法名：

```typescript
// 这些方法仍然可用，但建议使用新的方法名
await api.user.queryUserList(params); // 等同于 getUserList
await api.user.addUser(data); // 等同于 createUser
await api.user.modifyUser(id, data); // 等同于 updateUser
```

## 📁 项目结构

```
src/
├── services/
│   ├── index.ts                    # 统一服务层入口
│   ├── __tests__/                  # 单元测试
│   │   └── userAPI.test.ts
│   ├── iceOrder/                   # 冰块订单相关服务
│   │   ├── enhanced/               # 增强服务（已迁移到 axios）
│   │   │   ├── enhancedUserService.ts
│   │   │   ├── enhancedOrderService.ts
│   │   │   ├── enhancedIceTypeService.ts
│   │   │   ├── factoryService.ts
│   │   │   ├── reportService.ts
│   │   │   └── riskControlService.ts
│   │   └── types/
│   ├── product/
│   ├── frostChain/
│   └── permissionService/
├── utils/
│   └── apiClient.ts               # Axios HTTP 客户端
└── types/
    └── api.ts                     # API 类型定义
```

## 🔧 HTTP 客户端配置

新的 axios 客户端 (`src/utils/apiClient.ts`) 提供了以下功能：

- **自动错误处理**: 统一的错误响应处理
- **请求拦截**: 自动添加认证头和公共参数
- **响应拦截**: 统一的响应数据格式化
- **类型安全**: 完整的 TypeScript 类型支持

### 基础方法

```typescript
import { get, post, put, del } from '@/utils/apiClient';

// GET 请求
const data = await get('/api/users', { page: 1 });

// POST 请求
const result = await post('/api/users', { name: 'John' });

// PUT 请求
const updated = await put('/api/users/123', { name: 'Jane' });

// DELETE 请求
await del('/api/users/123');
```

## 🧪 测试

项目包含完整的单元测试，确保 API 调用的正确性：

```bash
# 运行所有测试
yarn test

# 运行测试并生成覆盖率报告
yarn test:coverage

# 监听模式运行测试
yarn test:watch
```

## 📋 迁移检查清单

- [x] 移除 `src/utils/requestCompat.ts` 兼容层
- [x] 删除旧的 `src/services/demo/UserController.ts`
- [x] 更新所有 enhanced 服务文件使用 axios
- [x] 修复所有 ESLint 错误
- [x] 编写单元测试验证 API 功能
- [x] 确保构建成功
- [x] 更新团队文档

## ⚠️ 注意事项

1. **错误处理**: 新的 axios 客户端会自动处理 HTTP 错误，无需在业务代码中重复处理
2. **类型安全**: 所有 API 方法都有完整的 TypeScript 类型定义
3. **向后兼容**: 保留了原有的方法名，但建议逐步迁移到新的命名规范
4. **测试覆盖**: 所有 API 方法都有对应的单元测试

## 🔗 相关链接

- [Axios 官方文档](https://axios-http.com/)
- [TypeScript 类型定义](./src/types/api.ts)
- [单元测试示例](./src/services/__tests__/)

## 🤝 团队协作

如有任何问题或建议，请：

1. 查看本文档和相关代码注释
2. 运行单元测试确保功能正常
3. 在团队群中讨论或提出 Issue

---

**迁移完成日期**: 2024 年 12 月 **负责人**: 开发团队 **状态**: ✅ 已完成
