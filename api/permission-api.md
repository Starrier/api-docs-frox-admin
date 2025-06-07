# 权限服务 API 文档

## RBAC 模型说明

系统采用基于角色的访问控制(RBAC)模型：

- 用户(User)可以拥有多个角色(Role)
- 角色(Role)可以包含多个权限(Permission)
- 权限(Permission)是最小的权限单元

## 数据结构定义

### 用户(User)

```typescript
interface User {
  id: string; // 用户ID
  username: string; // 用户名
  email: string; // 邮箱
  roles: string[]; // 角色ID数组
  status: 'active' | 'disabled'; // 用户状态
}
```

### 角色(Role)

```typescript
interface Role {
  id: string; // 角色ID
  name: string; // 角色名称
  description: string; // 角色描述
  permissions: string[]; // 权限ID数组
}
```

### 权限(Permission)

```typescript
interface Permission {
  id: string; // 权限ID
  name: string; // 权限名称
  code: string; // 权限代码(如: user:create)
  description: string; // 权限描述
}
```

## 用户管理

### 获取用户列表

**请求方式**: GET  
**路径**: /api/permission/users

#### 请求参数

| 参数名   | 类型   | 必填 | 说明                        |
| -------- | ------ | ---- | --------------------------- |
| page     | number | 否   | 页码，默认 1                |
| pageSize | number | 否   | 每页数量，默认 10           |
| username | string | 否   | 用户名模糊搜索              |
| status   | string | 否   | 按状态过滤(active/disabled) |

#### 响应示例

```json
{
  "data": [
    {
      "id": "1",
      "username": "admin",
      "email": "admin@example.com",
      "roles": ["1"],
      "status": "active"
    }
  ],
  "total": 10
}
```

### 创建用户

**请求方式**: POST  
**路径**: /api/permission/users

#### 请求体参数

| 参数名   | 类型     | 必填 | 说明              |
| -------- | -------- | ---- | ----------------- |
| username | string   | 是   | 用户名            |
| email    | string   | 是   | 邮箱              |
| roles    | string[] | 否   | 角色 ID 数组      |
| status   | string   | 否   | 状态(默认 active) |

## 角色管理

### 获取角色列表

**请求方式**: GET  
**路径**: /api/permission/roles

#### 请求参数

支持分页参数(page/pageSize)

#### 响应示例

```json
{
  "data": [
    {
      "id": "1",
      "name": "管理员",
      "description": "系统管理员",
      "permissions": ["1", "2"]
    }
  ],
  "total": 5
}
```

### 更新角色

**请求方式**: PUT  
**路径**: /api/permission/roles/{id}

#### 路径参数

| 参数名 | 类型   | 必填 | 说明    |
| ------ | ------ | ---- | ------- |
| id     | string | 是   | 角色 ID |

#### 请求体参数

支持部分更新，可只传需要修改的字段

## 权限管理

### 获取权限列表

**请求方式**: GET  
**路径**: /api/permission/permissions

#### 响应示例

```json
{
  "data": [
    {
      "id": "1",
      "name": "创建用户",
      "code": "user:create",
      "description": "允许创建新用户"
    }
  ],
  "total": 20
}
```

## 特殊功能

### 检查超级管理员

**说明**: 检查指定用户名是否是超级管理员  
**特殊账号**: 用户名为"frost-chain-admin"的账号是超级管理员

```typescript
function isSuperAdmin(username: string): boolean;
```
