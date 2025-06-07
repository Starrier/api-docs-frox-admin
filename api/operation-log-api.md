# 操作日志 API 文档

## 概述

操作日志 API 用于记录和查询系统中的用户操作行为。

## 接口变更

**原接口**: `/api/operation-logs`  
**新接口**: `/api/v1/log/operation`

## 记录操作日志

**请求方式**: POST  
**路径**: `/api/v1/log/operation`  
**请求格式**: JSON

### 请求参数

| 参数名       | 类型   | 必填 | 说明                                  |
| ------------ | ------ | ---- | ------------------------------------- |
| module       | string | 是   | 模块名称，如"用户认证"、"用户管理"等  |
| action       | string | 是   | 操作类型：CREATE/UPDATE/DELETE/READ   |
| resourceType | string | 是   | 资源类型，如"login"、"user"、"role"等 |
| resourceId   | string | 否   | 资源 ID                               |
| description  | string | 是   | 操作描述                              |
| details      | object | 否   | 详细信息，包含请求参数等              |

### 请求示例

```json
{
  "module": "用户认证",
  "action": "CREATE",
  "resourceType": "login",
  "resourceId": "b08a7904f3c26868928a299eb30de854",
  "description": "用户登录",
  "details": {
    "request": {
      "username": "frost-chain"
    },
    "loginTime": "2024-01-15T10:30:00.000Z",
    "userAgent": "Mozilla/5.0..."
  }
}
```

## 查询操作日志

**请求方式**: GET  
**路径**: `/api/v1/log/operation`

### 查询参数

| 参数名       | 类型   | 必填 | 说明              |
| ------------ | ------ | ---- | ----------------- |
| current      | number | 否   | 当前页码，默认 1  |
| pageSize     | number | 否   | 每页条数，默认 10 |
| startTime    | string | 否   | 开始时间          |
| endTime      | string | 否   | 结束时间          |
| username     | string | 否   | 用户名            |
| action       | string | 否   | 操作类型          |
| module       | string | 否   | 模块名称          |
| resourceType | string | 否   | 资源类型          |

### 响应示例

```json
{
  "code": 200,
  "success": true,
  "data": {
    "list": [
      {
        "id": "log_id_123",
        "createdAt": "2024-01-15T10:30:00.000Z",
        "username": "frost-chain",
        "action": "CREATE",
        "module": "用户认证",
        "resourceId": "b08a7904f3c26868928a299eb30de854",
        "resourceType": "login",
        "description": "用户登录",
        "ipAddress": "192.168.1.100",
        "userAgent": "Mozilla/5.0...",
        "details": {
          "request": {
            "username": "frost-chain"
          },
          "loginTime": "2024-01-15T10:30:00.000Z"
        }
      }
    ],
    "total": 1,
    "current": 1,
    "pageSize": 10
  },
  "message": "查询成功"
}
```

## 获取操作日志详情

**请求方式**: GET  
**路径**: `/api/v1/log/operation/{id}`

### 路径参数

| 参数名 | 类型   | 必填 | 说明    |
| ------ | ------ | ---- | ------- |
| id     | string | 是   | 日志 ID |

### 响应示例

```json
{
  "code": 200,
  "success": true,
  "data": {
    "id": "log_id_123",
    "createdAt": "2024-01-15T10:30:00.000Z",
    "username": "frost-chain",
    "action": "CREATE",
    "module": "用户认证",
    "resourceId": "b08a7904f3c26868928a299eb30de854",
    "resourceType": "login",
    "description": "用户登录",
    "ipAddress": "192.168.1.100",
    "userAgent": "Mozilla/5.0...",
    "details": {
      "request": {
        "username": "frost-chain"
      },
      "loginTime": "2024-01-15T10:30:00.000Z"
    }
  },
  "message": "查询成功"
}
```

## 特殊说明

### 登录操作日志

- **模块**: "用户认证"
- **操作类型**: "CREATE"
- **资源类型**: "login"
- **记录内容**: 只记录请求中的用户名，不记录响应信息
- **自动记录**: 登录成功后自动记录，无需手动调用

### 自动记录规则

系统会自动为以下操作记录日志：

- 所有 API 请求（除了登录和日志记录接口本身）
- 根据 HTTP 方法自动判断操作类型：
  - POST → CREATE
  - PUT/PATCH → UPDATE
  - DELETE → DELETE
  - GET → READ

### 排除规则

以下接口不会被自动记录到操作日志：

- `/api/v1/log/operation` - 避免循环调用
- `/api/auth/login` - 登录接口单独处理
