# 供应链管理 API 文档

## 概述

供应链管理模块提供供应商和工厂管理功能，包括供应商信用体系、工厂产能监控等。

## 供应商管理 API

### 获取供应商列表

**接口地址：** `GET /api/suppliers`

**请求参数：**

```typescript
{
  keyword?: string;        // 搜索关键词
  current?: number;        // 当前页码
  pageSize?: number;       // 每页数量
  status?: string;         // 供应商状态
  creditLevel?: string;    // 信用等级
}
```

**响应示例：**

```json
{
  "status": 200,
  "message": "success",
  "data": [
    {
      "id": 1,
      "name": "冰雪工厂A",
      "contactPerson": "张三",
      "phone": "13800138000",
      "email": "zhangsan@example.com",
      "address": "北京市朝阳区",
      "creditScore": 85,
      "rating": 4.5,
      "blacklisted": false,
      "createdAt": "2024-01-01T00:00:00Z"
    }
  ]
}
```

### 获取供应商详情

**接口地址：** `GET /api/suppliers/{id}`

**路径参数：**

- `id` (number): 供应商 ID

### 创建供应商

**接口地址：** `POST /api/suppliers`

**请求体：**

```typescript
{
  name: string;           // 供应商名称
  contactPerson: string;  // 联系人
  phone: string;          // 联系电话
  email: string;          // 邮箱
  address: string;        // 地址
  description?: string;   // 描述
}
```

### 更新供应商

**接口地址：** `PUT /api/suppliers/{id}`

### 删除供应商

**接口地址：** `DELETE /api/suppliers/{id}`

### 供应商评价

**接口地址：** `POST /api/suppliers/{id}/ratings`

**请求体：**

```typescript
{
  rating: number;         // 评分 (1-5)
  comment: string;        // 评价内容
  orderId?: string;       // 关联订单ID
}
```

### 供应商黑名单操作

**接口地址：** `PUT /api/suppliers/{id}/blacklist`

**请求体：**

```typescript
{
  blacklisted: boolean;   // 是否加入黑名单
  reason?: string;        // 原因
}
```

## 工厂管理 API

### 获取工厂列表

**接口地址：** `GET /api/factories`

**请求参数：**

```typescript
{
  keyword?: string;       // 搜索关键词
  current?: number;       // 当前页码
  pageSize?: number;      // 每页数量
  status?: string;        // 工厂状态
  region?: string;        // 服务区域
}
```

**响应示例：**

```json
{
  "status": 200,
  "message": "success",
  "data": [
    {
      "id": 1,
      "name": "北京冰块工厂",
      "address": "北京市朝阳区工业园",
      "contactPerson": "李四",
      "phone": "13900139000",
      "capacity": {
        "daily": 1000,
        "current": 750
      },
      "serviceAreas": ["北京", "天津"],
      "status": "active",
      "createdAt": "2024-01-01T00:00:00Z"
    }
  ]
}
```

### 获取工厂详情

**接口地址：** `GET /api/factories/{id}`

### 创建工厂

**接口地址：** `POST /api/factories`

**请求体：**

```typescript
{
  name: string;           // 工厂名称
  address: string;        // 地址
  contactPerson: string;  // 联系人
  phone: string;          // 联系电话
  email?: string;         // 邮箱
  capacity: {
    daily: number;        // 日产能
  };
  serviceAreas: string[]; // 服务区域
}
```

### 更新工厂

**接口地址：** `PUT /api/factories/{id}`

### 删除工厂

**接口地址：** `DELETE /api/factories/{id}`

### 工厂产能监控

**接口地址：** `GET /api/factories/{id}/capacity`

**响应示例：**

```json
{
  "status": 200,
  "data": {
    "factoryId": 1,
    "dailyCapacity": 1000,
    "currentProduction": 750,
    "utilizationRate": 75.0,
    "productionLines": [
      {
        "id": 1,
        "name": "生产线A",
        "status": "running",
        "efficiency": 85.5
      }
    ]
  }
}
```

### 更新工厂产能

**接口地址：** `PUT /api/factories/{id}/capacity`

**请求体：**

```typescript
{
  dailyCapacity: number; // 日产能
  currentProduction: number; // 当前产量
}
```

## 错误码说明

| 错误码 | 说明           |
| ------ | -------------- |
| 200    | 成功           |
| 400    | 请求参数错误   |
| 401    | 未授权         |
| 403    | 权限不足       |
| 404    | 资源不存在     |
| 500    | 服务器内部错误 |

## 数据类型定义

### Supplier 供应商

```typescript
interface Supplier {
  id: number;
  name: string;
  contactPerson: string;
  phone: string;
  email: string;
  address: string;
  description?: string;
  creditScore: number; // 信用分数 (0-100)
  rating: number; // 平均评分 (0-5)
  blacklisted: boolean; // 是否在黑名单
  createdAt: string;
  updatedAt: string;
}
```

### Factory 工厂

```typescript
interface Factory {
  id: number;
  name: string;
  address: string;
  contactPerson: string;
  phone: string;
  email?: string;
  capacity: {
    daily: number; // 日产能
    current: number; // 当前产量
  };
  serviceAreas: string[]; // 服务区域
  status: 'active' | 'inactive' | 'maintenance';
  createdAt: string;
  updatedAt: string;
}
```
