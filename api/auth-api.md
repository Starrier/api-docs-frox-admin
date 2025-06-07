# 认证服务 API 文档

## 登录接口

**请求方式**: POST  
**路径**: /api/auth/login

### 请求参数

| 参数名   | 类型   | 必填 | 说明   |
| -------- | ------ | ---- | ------ |
| username | string | 是   | 用户名 |
| password | string | 是   | 密码   |

### 特殊账号

- 用户名: frost-chain-admin
- 密码: frost-chain-admin  
  使用此账号会直接返回成功，用于开发环境快速登录

### 响应示例

```json
{
  "success": true,
  "token": "jwt-token-string"
}
```

## 注册接口

**请求方式**: POST  
**路径**: /api/auth/register

### 请求参数

| 参数名          | 类型   | 必填 | 说明     |
| --------------- | ------ | ---- | -------- |
| username        | string | 是   | 用户名   |
| password        | string | 是   | 密码     |
| confirmPassword | string | 是   | 确认密码 |

### 响应示例

```json
{
  "success": true,
  "message": "注册成功"
}
```

## 登出接口

**说明**: 本地清除 token，无网络请求
