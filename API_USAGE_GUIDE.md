# API 使用指南

本项目已统一使用 **axios** 作为 HTTP 客户端，替换了原有的 `umi-request`。

## 📋 目录结构

```
src/
├── utils/
│   └── apiClient.ts          # axios 客户端配置
├── services/
│   ├── index.ts              # 统一的 API 服务层
│   └── demo/
│       └── UserController.ts # 示例控制器（建议迁移到 index.ts）
└── types/
    └── api.d.ts              # API 类型定义
```

## 🚀 基本使用

### 1. 使用统一的服务层（推荐）

```typescript
import api from '@/services';

// 用户相关操作
const users = await api.user.getUserList({ current: 1, pageSize: 10 });
const user = await api.user.getUserDetail('123');
await api.user.createUser({ name: '张三', email: 'zhangsan@example.com' });

// 产品相关操作
const products = await api.product.getProductList({ category: 'electronics' });
const product = await api.product.getProductDetail('456');

// 冰块订单相关操作
const orders = await api.iceOrder.getOrderList({ status: 'pending' });
const iceTypes = await api.iceOrder.getIceTypes();
```

### 2. 直接使用 axios 客户端

```typescript
import { get, post, put, del } from '@/utils/apiClient';

// GET 请求
const response = await get('/api/v1/users', { page: 1, size: 10 });

// POST 请求
const newUser = await post('/api/v1/users', {
  name: '李四',
  email: 'lisi@example.com',
});

// PUT 请求
const updatedUser = await put('/api/v1/users/123', {
  name: '李四（更新）',
});

// DELETE 请求
await del('/api/v1/users/123');
```

## 🔧 配置说明

### axios 客户端配置

位置：`src/utils/apiClient.ts`

主要特性：

- ✅ 自动添加认证 token
- ✅ 统一错误处理
- ✅ 请求/响应日志记录
- ✅ 操作日志自动记录
- ✅ 网络错误处理
- ✅ 业务错误处理

### 环境配置

```typescript
// 开发环境
apiBaseUrl: 'http://localhost:3000';

// 测试环境
apiBaseUrl: 'https://test-api.starrier.org';

// 生产环境
apiBaseUrl: 'https://api.starrier.org';
```

## 📝 类型定义

### API 响应格式

```typescript
interface ApiResponse<T = any> {
  status: number;
  data?: T | null;
  error?: string;
  message?: string;
}
```

### 使用示例

```typescript
import { ApiResponse } from '@/types/api';

// 定义具体的响应类型
interface User {
  id: string;
  name: string;
  email: string;
}

// 使用泛型
const response: ApiResponse<User[]> = await api.user.getUserList();
```

## 🛠️ 错误处理

### 自动错误处理

axios 客户端会自动处理以下错误：

- **401 未授权**：自动跳转到登录页
- **403 权限不足**：显示权限错误提示
- **404 资源不存在**：显示资源不存在提示
- **500 服务器错误**：显示服务器错误提示
- **网络错误**：显示网络连接异常提示

### 手动错误处理

```typescript
try {
  const users = await api.user.getUserList();
  // 处理成功响应
} catch (error) {
  // 处理错误
  console.error('获取用户列表失败:', error);
}
```

## 🔄 迁移指南

### 从 umi-request 迁移

**之前（umi-request）：**

```typescript
import { request } from 'umi';

const response = await request('/api/users', {
  method: 'GET',
  params: { page: 1 },
});
```

**现在（axios）：**

```typescript
import { get } from '@/utils/apiClient';
// 或者
import api from '@/services';

const response = await get('/api/users', { page: 1 });
// 或者
const response = await api.user.getUserList({ current: 1 });
```

### 从旧的 UserController 迁移

**之前：**

```typescript
import { queryUserList } from '@/services/demo/UserController';

const users = await queryUserList({ current: 1, pageSize: 10 });
```

**现在：**

```typescript
import api from '@/services';

const users = await api.user.getUserList({ current: 1, pageSize: 10 });
```

## 📚 最佳实践

### 1. 优先使用统一服务层

```typescript
// ✅ 推荐
import api from '@/services';
const users = await api.user.getUserList();

// ❌ 不推荐
import { get } from '@/utils/apiClient';
const users = await get('/api/v1/queryUserList');
```

### 2. 添加类型定义

```typescript
// ✅ 推荐
interface CreateUserRequest {
  name: string;
  email: string;
  role?: string;
}

const newUser = await api.user.createUser(userData as CreateUserRequest);
```

### 3. 错误处理

```typescript
// ✅ 推荐
try {
  const result = await api.user.createUser(userData);
  message.success('用户创建成功');
  return result;
} catch (error) {
  // axios 客户端已经显示了错误提示
  // 这里只需要处理业务逻辑
  return null;
}
```

### 4. 加载状态管理

```typescript
const [loading, setLoading] = useState(false);

const handleSubmit = async () => {
  setLoading(true);
  try {
    await api.user.createUser(formData);
    message.success('操作成功');
  } finally {
    setLoading(false);
  }
};
```

## 🔍 调试技巧

### 开发环境日志

在开发环境中，axios 客户端会自动打印详细的请求和响应日志：

```
[API Request] {
  url: '/api/v1/users',
  method: 'get',
  params: { page: 1, size: 10 },
  headers: { Authorization: 'Bearer xxx' }
}

[API Response] {
  url: '/api/v1/users',
  status: 200,
  data: { ... }
}
```

### 网络面板

使用浏览器开发者工具的网络面板查看实际的 HTTP 请求。

## 📞 支持

如果在使用过程中遇到问题，请：

1. 检查网络连接
2. 确认 API 地址配置正确
3. 查看浏览器控制台错误信息
4. 检查服务器端 API 是否正常工作

---

**注意**：项目已完全移除 `umi-request` 依赖，请统一使用 axios 进行 HTTP 请求。
