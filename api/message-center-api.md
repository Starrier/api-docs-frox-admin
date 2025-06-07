# 消息中心 API 接口文档

## 📋 概述

消息中心模块提供统一的消息管理功能，支持多平台消息推送、模板管理、推送策略配置等功能。

## 🌐 基础信息

- **基础 URL**: `/api/v1/message`
- **数据格式**: JSON
- **认证方式**: Bearer Token

## 📨 消息管理

### 获取消息列表

- **接口**: `GET /api/v1/message/list`
- **描述**: 分页获取消息列表
- **查询参数**:
  - `current`: 当前页码
  - `pageSize`: 每页数量
  - `status`: 消息状态 (draft|sent|failed)
  - `platform`: 推送平台 (douyin|xiaohongshu|wechat|sms|email)
  - `startDate`: 开始日期
  - `endDate`: 结束日期
- **响应数据**:
  ```json
  {
    "list": [
      {
        "id": "number",
        "title": "string",
        "content": "string",
        "platform": "douyin|xiaohongshu|wechat|sms|email",
        "status": "draft|sent|failed",
        "targetAudience": {
          "type": "all|specific|group",
          "userIds": ["string"],
          "groupIds": ["string"],
          "filters": {}
        },
        "scheduledTime": "string",
        "sentTime": "string",
        "statistics": {
          "sent": "number",
          "delivered": "number",
          "read": "number",
          "clicked": "number"
        },
        "createdAt": "string",
        "updatedAt": "string"
      }
    ],
    "total": "number",
    "current": "number",
    "pageSize": "number"
  }
  ```

### 获取消息详情

- **接口**: `GET /api/v1/message/{id}`
- **描述**: 获取消息详细信息

### 创建消息

- **接口**: `POST /api/v1/message`
- **描述**: 创建新消息
- **请求参数**:
  ```json
  {
    "title": "string",
    "content": "string",
    "platform": "douyin|xiaohongshu|wechat|sms|email",
    "templateId": "number",
    "targetAudience": {
      "type": "all|specific|group",
      "userIds": ["string"],
      "groupIds": ["string"],
      "filters": {}
    },
    "scheduledTime": "string",
    "priority": "low|normal|high|urgent"
  }
  ```

### 更新消息

- **接口**: `PUT /api/v1/message/{id}`
- **描述**: 更新消息信息

### 删除消息

- **接口**: `DELETE /api/v1/message/{id}`
- **描述**: 删除消息

### 发送消息

- **接口**: `POST /api/v1/message/{id}/send`
- **描述**: 立即发送消息

### 取消发送

- **接口**: `POST /api/v1/message/{id}/cancel`
- **描述**: 取消定时发送的消息

### 获取消息统计

- **接口**: `GET /api/v1/message/{id}/statistics`
- **描述**: 获取消息发送统计数据
- **响应数据**:
  ```json
  {
    "sent": "number",
    "delivered": "number",
    "read": "number",
    "clicked": "number",
    "failed": "number",
    "deliveryRate": "number",
    "readRate": "number",
    "clickRate": "number",
    "platformBreakdown": {
      "douyin": {
        "sent": "number",
        "delivered": "number",
        "read": "number"
      },
      "xiaohongshu": {
        "sent": "number",
        "delivered": "number",
        "read": "number"
      }
    }
  }
  ```

## 📋 模板管理

### 获取模板列表

- **接口**: `GET /api/v1/message/templates`
- **描述**: 获取消息模板列表
- **查询参数**:
  - `platform`: 平台类型
  - `category`: 模板分类
  - `status`: 模板状态
- **响应数据**:
  ```json
  [
    {
      "id": "number",
      "name": "string",
      "description": "string",
      "platform": "douyin|xiaohongshu|wechat|sms|email",
      "category": "marketing|notification|alert|system",
      "content": "string",
      "variables": [
        {
          "name": "string",
          "type": "string|number|date",
          "required": "boolean",
          "description": "string"
        }
      ],
      "status": "active|inactive",
      "createdAt": "string",
      "updatedAt": "string"
    }
  ]
  ```

### 获取模板详情

- **接口**: `GET /api/v1/message/templates/{id}`
- **描述**: 获取模板详细信息

### 创建模板

- **接口**: `POST /api/v1/message/templates`
- **描述**: 创建消息模板
- **请求参数**:
  ```json
  {
    "name": "string",
    "description": "string",
    "platform": "douyin|xiaohongshu|wechat|sms|email",
    "category": "marketing|notification|alert|system",
    "content": "string",
    "variables": [
      {
        "name": "string",
        "type": "string|number|date",
        "required": "boolean",
        "description": "string"
      }
    ]
  }
  ```

### 更新模板

- **接口**: `PUT /api/v1/message/templates/{id}`
- **描述**: 更新模板信息

### 删除模板

- **接口**: `DELETE /api/v1/message/templates/{id}`
- **描述**: 删除模板

### 预览模板

- **接口**: `POST /api/v1/message/templates/{id}/preview`
- **描述**: 预览模板渲染效果
- **请求参数**:
  ```json
  {
    "variables": {
      "userName": "string",
      "productName": "string",
      "date": "string"
    }
  }
  ```

## ⚙️ 推送策略

### 获取推送策略列表

- **接口**: `GET /api/v1/message/push-strategies`
- **描述**: 获取推送策略列表
- **响应数据**:
  ```json
  [
    {
      "id": "number",
      "name": "string",
      "description": "string",
      "platform": "douyin|xiaohongshu|wechat|sms|email",
      "rules": [
        {
          "condition": "string",
          "action": "string",
          "priority": "number"
        }
      ],
      "frequency": {
        "type": "immediate|scheduled|batch",
        "interval": "number",
        "maxPerDay": "number",
        "quietHours": {
          "start": "string",
          "end": "string"
        }
      },
      "retryPolicy": {
        "maxRetries": "number",
        "retryInterval": "number",
        "backoffMultiplier": "number"
      },
      "status": "active|inactive",
      "createdAt": "string",
      "updatedAt": "string"
    }
  ]
  ```

### 获取推送策略详情

- **接口**: `GET /api/v1/message/push-strategies/{id}`
- **描述**: 获取推送策略详细信息

### 创建推送策略

- **接口**: `POST /api/v1/message/push-strategies`
- **描述**: 创建推送策略

### 更新推送策略

- **接口**: `PUT /api/v1/message/push-strategies/{id}`
- **描述**: 更新推送策略

### 删除推送策略

- **接口**: `DELETE /api/v1/message/push-strategies/{id}`
- **描述**: 删除推送策略

### 测试推送策略

- **接口**: `POST /api/v1/message/push-strategies/{id}/test`
- **描述**: 测试推送策略效果

## 📊 统计分析

### 获取推送统计概览

- **接口**: `GET /api/v1/message/analytics/overview`
- **描述**: 获取推送统计概览
- **查询参数**:
  - `startDate`: 开始日期
  - `endDate`: 结束日期
  - `platform`: 平台筛选
- **响应数据**:
  ```json
  {
    "totalMessages": "number",
    "totalSent": "number",
    "totalDelivered": "number",
    "totalRead": "number",
    "totalClicked": "number",
    "deliveryRate": "number",
    "readRate": "number",
    "clickRate": "number",
    "platformStats": {
      "douyin": {
        "sent": "number",
        "delivered": "number",
        "deliveryRate": "number"
      },
      "xiaohongshu": {
        "sent": "number",
        "delivered": "number",
        "deliveryRate": "number"
      }
    },
    "trendData": [
      {
        "date": "string",
        "sent": "number",
        "delivered": "number",
        "read": "number"
      }
    ]
  }
  ```

### 获取平台分析数据

- **接口**: `GET /api/v1/message/analytics/platforms`
- **描述**: 获取各平台分析数据

### 获取用户行为分析

- **接口**: `GET /api/v1/message/analytics/user-behavior`
- **描述**: 获取用户行为分析数据

### 获取内容效果分析

- **接口**: `GET /api/v1/message/analytics/content-performance`
- **描述**: 获取内容效果分析数据

## 🔔 通知管理

### 获取通知列表

- **接口**: `GET /api/v1/message/notifications`
- **描述**: 获取系统通知列表
- **查询参数**:
  - `userId`: 用户 ID
  - `read`: 是否已读
  - `type`: 通知类型

### 标记通知为已读

- **接口**: `PUT /api/v1/message/notifications/{id}/read`
- **描述**: 标记通知为已读

### 批量标记已读

- **接口**: `PUT /api/v1/message/notifications/batch-read`
- **描述**: 批量标记通知为已读
- **请求参数**:
  ```json
  {
    "notificationIds": ["number"]
  }
  ```

### 删除通知

- **接口**: `DELETE /api/v1/message/notifications/{id}`
- **描述**: 删除通知

## 🎯 用户偏好

### 获取用户推送偏好

- **接口**: `GET /api/v1/message/user-preferences/{userId}`
- **描述**: 获取用户推送偏好设置

### 更新用户推送偏好

- **接口**: `PUT /api/v1/message/user-preferences/{userId}`
- **描述**: 更新用户推送偏好设置
- **请求参数**:
  ```json
  {
    "platforms": {
      "douyin": "boolean",
      "xiaohongshu": "boolean",
      "wechat": "boolean",
      "sms": "boolean",
      "email": "boolean"
    },
    "categories": {
      "marketing": "boolean",
      "notification": "boolean",
      "alert": "boolean",
      "system": "boolean"
    },
    "quietHours": {
      "enabled": "boolean",
      "start": "string",
      "end": "string"
    },
    "frequency": {
      "maxPerDay": "number",
      "batchDelivery": "boolean"
    }
  }
  ```
