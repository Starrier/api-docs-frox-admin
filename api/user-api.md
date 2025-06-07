# 用户服务 API 文档

## 用户数据结构

```typescript
interface User {
  id: number; // 用户ID
  username: string; // 用户名
  email: string; // 邮箱
  phone?: string; // 手机号(可选)
  status: 'active' | 'inactive'; // 用户状态
  createdAt: string; // 创建时间
  updatedAt: string; // 更新时间
}
```

## 获取用户列表

**请求方式**: GET  
**路径**: /api/users

### 请求参数

| 参数名   | 类型   | 必填 | 说明                        |
| -------- | ------ | ---- | --------------------------- |
| page     | number | 否   | 页码，默认 1                |
| pageSize | number | 否   | 每页数量，默认 10           |
| username | string | 否   | 用户名模糊搜索              |
| status   | string | 否   | 按状态过滤(active/inactive) |

### 响应示例

```json
{
  "success": true,
  "data": {
    "list": [
      {
        "id": 1,
        "username": "user1",
        "email": "user1@example.com",
        "status": "active",
        "createdAt": "2023-01-01T00:00:00Z"
      }
    ],
    "total": 100,
    "currentPage": 1
  }
}
```

## 获取用户详情

**请求方式**: GET  
**路径**: /api/users/{id}

### 路径参数

| 参数名 | 类型   | 必填 | 说明    |
| ------ | ------ | ---- | ------- |
| id     | number | 是   | 用户 ID |

### 响应示例

```json
{
  "success": true,
  "data": {
    "id": 1,
    "username": "user1",
    "email": "user1@example.com",
    "phone": "13800138000",
    "status": "active",
    "createdAt": "2023-01-01T00:00:00Z",
    "updatedAt": "2023-01-02T00:00:00Z"
  }
}
```

## 创建用户

**请求方式**: POST  
**路径**: /api/users

### 请求体参数

| 参数名   | 类型   | 必填 | 说明              |
| -------- | ------ | ---- | ----------------- |
| username | string | 是   | 用户名            |
| email    | string | 是   | 邮箱              |
| phone    | string | 否   | 手机号            |
| status   | string | 否   | 状态(默认 active) |

### 请求示例

```json
{
  "username": "newuser",
  "email": "newuser@example.com",
  "phone": "13800138000"
}
```

## 更新用户

**请求方式**: PUT  
**路径**: /api/users/{id}

### 路径参数

| 参数名 | 类型   | 必填 | 说明    |
| ------ | ------ | ---- | ------- |
| id     | number | 是   | 用户 ID |

### 请求体参数

支持部分更新，可只传需要修改的字段

## 删除用户

**请求方式**: DELETE  
**路径**: /api/users/{id}

### 路径参数

| 参数名 | 类型   | 必填 | 说明    |
| ------ | ------ | ---- | ------- |
| id     | number | 是   | 用户 ID |

### 响应示例

```json
{
  "success": true,
  "message": "用户删除成功"
}
```
