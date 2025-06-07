# Front-Logix-Admin 完整 API 接口文档

## 📋 概述

本文档详细描述了 Front-Logix-Admin 系统的所有 API 接口，包括认证、用户管理、产品管理、订单管理、监控报表、消息中心等模块。

## 🌐 基础信息

- **基础 URL**: `/api/v1`
- **数据格式**: JSON
- **认证方式**: Bearer Token
- **请求头**:
  ```
  Authorization: Bearer {token}
  Content-Type: application/json
  ```

## 📊 通用响应格式

```json
{
  "status": 200,
  "message": "操作成功",
  "data": {},
  "error": null
}
```

## 🔐 认证模块 (Auth API)

### 用户登录

- **接口**: `POST /api/v1/auth/login`
- **描述**: 用户登录认证
- **请求参数**:
  ```json
  {
    "username": "string",
    "password": "string"
  }
  ```
- **响应数据**:
  ```json
  {
    "token": "string",
    "userInfo": {
      "id": "string",
      "username": "string",
      "email": "string",
      "roles": ["string"]
    }
  }
  ```

### 用户注册

- **接口**: `POST /api/v1/auth/register`
- **描述**: 用户注册
- **请求参数**:
  ```json
  {
    "username": "string",
    "password": "string",
    "email": "string"
  }
  ```

### 重置密码

- **接口**: `POST /api/v1/auth/reset-password`
- **描述**: 重置用户密码
- **请求参数**:
  ```json
  {
    "email": "string"
  }
  ```

### 获取用户信息

- **接口**: `GET /api/v1/auth/user-info`
- **描述**: 获取当前登录用户信息

### 退出登录

- **接口**: `POST /api/v1/auth/logout`
- **描述**: 用户退出登录

## 👥 用户管理模块 (User API)

### 获取用户列表

- **接口**: `GET /api/v1/queryUserList`
- **描述**: 分页获取用户列表
- **查询参数**:
  - `keyword`: 搜索关键词
  - `current`: 当前页码
  - `pageSize`: 每页数量
- **响应数据**:
  ```json
  {
    "list": [
      {
        "id": "string",
        "username": "string",
        "email": "string",
        "phone": "string",
        "status": "active|disabled",
        "createdAt": "string"
      }
    ],
    "total": "number",
    "current": "number",
    "pageSize": "number"
  }
  ```

### 获取用户详情

- **接口**: `GET /api/v1/user/{userId}`
- **描述**: 获取指定用户详细信息

### 创建用户

- **接口**: `POST /api/v1/user`
- **描述**: 创建新用户
- **请求参数**:
  ```json
  {
    "username": "string",
    "email": "string",
    "phone": "string",
    "password": "string",
    "roles": ["string"]
  }
  ```

### 更新用户

- **接口**: `PUT /api/v1/user/{userId}`
- **描述**: 更新用户信息

### 删除用户

- **接口**: `DELETE /api/v1/user/{userId}`
- **描述**: 删除用户

## 📦 产品管理模块 (Product API)

### 获取产品列表

- **接口**: `GET /api/v1/products`
- **描述**: 分页获取产品列表
- **查询参数**:
  - `keyword`: 搜索关键词
  - `current`: 当前页码
  - `pageSize`: 每页数量
  - `category`: 产品分类

### 获取产品详情

- **接口**: `GET /api/v1/products/{id}`
- **描述**: 获取产品详细信息

### 创建产品

- **接口**: `POST /api/v1/products`
- **描述**: 创建新产品
- **请求参数**:
  ```json
  {
    "title": "string",
    "description": "string",
    "features": ["string"],
    "applications": ["string"],
    "images": [
      {
        "src": "string",
        "alt": "string"
      }
    ],
    "specifications": {}
  }
  ```

### 更新产品

- **接口**: `PUT /api/v1/products/{id}`
- **描述**: 更新产品信息

### 删除产品

- **接口**: `DELETE /api/v1/products/{id}`
- **描述**: 删除产品

## 🧊 冰块订单模块 (Ice Order API)

### 获取订单列表

- **接口**: `GET /api/v1/ice-orders`
- **描述**: 分页获取订单列表
- **查询参数**:
  - `keyword`: 搜索关键词
  - `current`: 当前页码
  - `pageSize`: 每页数量
  - `status`: 订单状态
  - `startDate`: 开始日期
  - `endDate`: 结束日期

### 获取订单详情

- **接口**: `GET /api/v1/ice-orders/{id}`
- **描述**: 获取订单详细信息

### 创建订单

- **接口**: `POST /api/v1/ice-orders`
- **描述**: 创建新订单

### 更新订单

- **接口**: `PUT /api/v1/ice-orders/{id}`
- **描述**: 更新订单信息

### 删除订单

- **接口**: `DELETE /api/v1/ice-orders/{id}`
- **描述**: 删除订单

### 获取冰块类型列表

- **接口**: `GET /api/ice-types`
- **描述**: 获取所有冰块类型

### 获取用户列表

- **接口**: `GET /api/users`
- **描述**: 获取用户列表

## 📊 监控报表模块 (Monitoring API)

### 系统监控

#### 获取监控统计

- **接口**: `GET /api/v1/monitoring/system/statistics`
- **描述**: 获取系统监控统计数据
- **查询参数**:
  - `startTime`: 开始时间戳
  - `endTime`: 结束时间戳
  - `eventType`: 事件类型
  - `deviceType`: 设备类型

#### 获取监控数据

- **接口**: `GET /api/v1/monitoring/system/data`
- **描述**: 获取系统监控详细数据
- **查询参数**:
  - `current`: 当前页码
  - `pageSize`: 每页数量
  - `startTime`: 开始时间戳
  - `endTime`: 结束时间戳
  - `eventType`: 事件类型
  - `deviceType`: 设备类型

### 用户行为分析

#### 获取用户行为轨迹

- **接口**: `GET /api/v1/monitoring/user-behavior/tracks`
- **描述**: 获取用户行为轨迹数据
- **查询参数**:
  - `startTime`: 开始时间戳
  - `endTime`: 结束时间戳
  - `userId`: 用户 ID
  - `sessionId`: 会话 ID
  - `current`: 当前页码
  - `pageSize`: 每页数量

#### 获取用户会话数据

- **接口**: `GET /api/v1/monitoring/user-behavior/sessions`
- **描述**: 获取用户会话数据

#### 获取页面流转数据

- **接口**: `GET /api/v1/monitoring/user-behavior/page-flows`
- **描述**: 获取页面流转数据

### UV/PV 统计

#### 获取 UV/PV 统计数据

- **接口**: `GET /api/v1/monitoring/uv-pv/stats`
- **描述**: 获取 UV/PV 统计数据
- **查询参数**:
  - `startTime`: 开始时间戳
  - `endTime`: 结束时间戳
  - `granularity`: 时间粒度 (hour|day|week|month)

#### 获取页面访问统计

- **接口**: `GET /api/v1/monitoring/uv-pv/page-stats`
- **描述**: 获取页面访问统计

#### 获取设备统计

- **接口**: `GET /api/v1/monitoring/uv-pv/device-stats`
- **描述**: 获取设备访问统计

#### 获取地域统计

- **接口**: `GET /api/v1/monitoring/uv-pv/region-stats`
- **描述**: 获取地域访问统计

#### 获取总览统计

- **接口**: `GET /api/v1/monitoring/uv-pv/overview`
- **描述**: 获取 UV/PV 总览统计数据
- **响应数据**:
  ```json
  {
    "totalPv": "number",
    "totalUv": "number",
    "totalNewUsers": "number",
    "avgBounceRate": "number",
    "avgSessionDuration": "number"
  }
  ```

## 🔧 系统管理模块 (System API)

### 获取操作日志

- **接口**: `GET /api/v1/system/operation-logs`
- **描述**: 获取系统操作日志
- **查询参数**:
  - `current`: 当前页码
  - `pageSize`: 每页数量
  - `startDate`: 开始日期
  - `endDate`: 结束日期
  - `module`: 模块名称
  - `action`: 操作类型

### 获取系统配置

- **接口**: `GET /api/v1/system/config`
- **描述**: 获取系统配置信息

### 更新系统配置

- **接口**: `PUT /api/v1/system/config`
- **描述**: 更新系统配置

## 🔑 权限管理模块 (Permission API)

### 用户管理

#### 获取用户列表

- **接口**: `GET /api/permission/users`
- **描述**: 获取权限管理用户列表

#### 创建用户

- **接口**: `POST /api/permission/users`
- **描述**: 创建权限管理用户

#### 更新用户

- **接口**: `PUT /api/permission/users/{id}`
- **描述**: 更新用户信息

#### 删除用户

- **接口**: `DELETE /api/permission/users/{id}`
- **描述**: 删除用户

### 角色管理

#### 获取角色列表

- **接口**: `GET /api/permission/roles`
- **描述**: 获取角色列表

#### 创建角色

- **接口**: `POST /api/permission/roles`
- **描述**: 创建新角色

#### 更新角色

- **接口**: `PUT /api/permission/roles/{id}`
- **描述**: 更新角色信息

#### 删除角色

- **接口**: `DELETE /api/permission/roles/{id}`
- **描述**: 删除角色

### 权限管理

#### 获取权限列表

- **接口**: `GET /api/permission/permissions`
- **描述**: 获取权限列表

#### 创建权限

- **接口**: `POST /api/permission/permissions`
- **描述**: 创建新权限

#### 更新权限

- **接口**: `PUT /api/permission/permissions/{id}`
- **描述**: 更新权限信息

#### 删除权限

- **接口**: `DELETE /api/permission/permissions/{id}`
- **描述**: 删除权限

## 🚀 增强服务模块 (Enhanced Services)

### 增强用户服务

#### 获取增强用户列表

- **接口**: `GET /api/enhanced-users`
- **描述**: 获取增强用户列表
- **响应数据**:
  ```json
  [
    {
      "id": "number",
      "username": "string",
      "email": "string",
      "phone": "string",
      "type": "individual|business|factory",
      "businessType": "string",
      "creditScore": "number",
      "address": {
        "province": "string",
        "city": "string",
        "district": "string",
        "detail": "string",
        "location": {
          "longitude": "number",
          "latitude": "number"
        }
      },
      "createdAt": "string",
      "lastLoginAt": "string"
    }
  ]
  ```

#### 获取增强用户详情

- **接口**: `GET /api/enhanced-users/{id}`
- **描述**: 获取增强用户详细信息

#### 创建增强用户

- **接口**: `POST /api/enhanced-users`
- **描述**: 创建增强用户

#### 更新增强用户

- **接口**: `PUT /api/enhanced-users/{id}`
- **描述**: 更新增强用户信息

#### 删除增强用户

- **接口**: `DELETE /api/enhanced-users/{id}`
- **描述**: 删除增强用户

#### 更新用户信用评分

- **接口**: `PUT /api/enhanced-users/{id}/credit-score`
- **描述**: 更新用户信用评分
- **请求参数**:
  ```json
  {
    "creditScore": "number"
  }
  ```

#### 获取用户订单历史

- **接口**: `GET /api/enhanced-users/{id}/orders`
- **描述**: 获取用户订单历史

#### 获取用户地址

- **接口**: `GET /api/enhanced-users/{id}/address`
- **描述**: 获取用户地址信息

#### 更新用户地址

- **接口**: `PUT /api/enhanced-users/{id}/address`
- **描述**: 更新用户地址信息

### 增强冰块类型服务

#### 获取增强冰块类型列表

- **接口**: `GET /api/enhanced-ice-types`
- **描述**: 获取增强冰块类型列表
- **响应数据**:
  ```json
  [
    {
      "id": "number",
      "name": "string",
      "description": "string",
      "category": "industrial|food|cooling",
      "specifications": {
        "shape": "string",
        "size": "string",
        "weight": "string",
        "temperatureRange": {
          "min": "number",
          "max": "number"
        },
        "duration": "number"
      },
      "certifications": ["string"],
      "images": ["string"],
      "model3d": "string"
    }
  ]
  ```

#### 获取增强冰块类型详情

- **接口**: `GET /api/enhanced-ice-types/{id}`
- **描述**: 获取增强冰块类型详细信息

#### 创建增强冰块类型

- **接口**: `POST /api/enhanced-ice-types`
- **描述**: 创建增强冰块类型

#### 更新增强冰块类型

- **接口**: `PUT /api/enhanced-ice-types/{id}`
- **描述**: 更新增强冰块类型信息

#### 删除增强冰块类型

- **接口**: `DELETE /api/enhanced-ice-types/{id}`
- **描述**: 删除增强冰块类型

#### 获取冰块价格信息

- **接口**: `GET /api/enhanced-ice-types/{id}/price`
- **描述**: 获取冰块价格信息
- **响应数据**:
  ```json
  {
    "basePrice": "number",
    "unit": "string",
    "bulkDiscounts": [
      {
        "quantity": "number",
        "discount": "number"
      }
    ],
    "seasonalFactors": [
      {
        "season": "spring|summer|autumn|winter",
        "factor": "number"
      }
    ],
    "emergencyFactor": "number",
    "historyPrices": [
      {
        "date": "string",
        "price": "number"
      }
    ]
  }
  ```

#### 更新冰块价格信息

- **接口**: `PUT /api/enhanced-ice-types/{id}/price`
- **描述**: 更新冰块价格信息

#### 获取冰块历史价格

- **接口**: `GET /api/enhanced-ice-types/{id}/history-prices`
- **描述**: 获取冰块历史价格

#### 获取冰块 3D 模型

- **接口**: `GET /api/enhanced-ice-types/{id}/3d-model`
- **描述**: 获取冰块 3D 模型

#### 上传冰块 3D 模型

- **接口**: `POST /api/enhanced-ice-types/{id}/3d-model`
- **描述**: 上传冰块 3D 模型
- **请求类型**: multipart/form-data

### 增强订单服务

#### 获取增强订单列表

- **接口**: `GET /api/enhanced-orders`
- **描述**: 获取增强订单列表

#### 获取增强订单详情

- **接口**: `GET /api/enhanced-orders/{id}`
- **描述**: 获取增强订单详细信息
- **响应数据**:
  ```json
  {
    "id": "number",
    "orderNumber": "string",
    "userId": "number",
    "username": "string",
    "supplierId": "number",
    "supplierName": "string",
    "items": [
      {
        "id": "number",
        "iceTypeId": "number",
        "iceTypeName": "string",
        "quantity": "number",
        "size": "string",
        "unitPrice": "number",
        "totalPrice": "number"
      }
    ],
    "totalAmount": "number",
    "deliveryInfo": {
      "type": "self-pickup|delivery",
      "address": {},
      "contactPerson": "string",
      "contactPhone": "string",
      "expectedDeliveryTime": "string",
      "actualDeliveryTime": "string"
    },
    "urgencyLevel": "normal|urgent|emergency",
    "status": "string",
    "paymentStatus": "unpaid|paid|refunded",
    "paymentMethod": "alipay|wechat|bank-transfer|cash",
    "logisticsInfo": {
      "provider": "string",
      "trackingNumber": "string",
      "vehicleType": "string",
      "temperature": "number",
      "currentLocation": {
        "longitude": "number",
        "latitude": "number"
      },
      "estimatedArrivalTime": "string"
    },
    "insurance": {
      "provider": "string",
      "policyNumber": "string",
      "coverage": "number",
      "validUntil": "string"
    },
    "contract": {
      "url": "string",
      "signedAt": "string",
      "validUntil": "string"
    },
    "carbonFootprint": {
      "emissions": "number",
      "saved": "number"
    },
    "notes": "string",
    "createdAt": "string",
    "updatedAt": "string"
  }
  ```

#### 创建增强订单

- **接口**: `POST /api/enhanced-orders`
- **描述**: 创建增强订单

#### 更新增强订单

- **接口**: `PUT /api/enhanced-orders/{id}`
- **描述**: 更新增强订单信息

#### 更新订单状态

- **接口**: `PUT /api/enhanced-orders/{id}/status`
- **描述**: 更新订单状态
- **请求参数**:
  ```json
  {
    "status": "string"
  }
  ```

#### 更新订单支付状态

- **接口**: `PUT /api/enhanced-orders/{id}/payment`
- **描述**: 更新订单支付状态
- **请求参数**:
  ```json
  {
    "paymentStatus": "unpaid|paid|refunded",
    "paymentMethod": "alipay|wechat|bank-transfer|cash"
  }
  ```

#### 更新物流信息

- **接口**: `PUT /api/enhanced-orders/{id}/logistics`
- **描述**: 更新订单物流信息

#### 添加保险信息

- **接口**: `PUT /api/enhanced-orders/{id}/insurance`
- **描述**: 添加订单保险信息

#### 生成电子合同

- **接口**: `POST /api/enhanced-orders/{id}/contract`
- **描述**: 生成订单电子合同

#### 计算订单碳足迹

- **接口**: `GET /api/enhanced-orders/{id}/carbon-footprint`
- **描述**: 计算订单碳足迹

#### 获取订单统计数据

- **接口**: `GET /api/enhanced-orders/statistics`
- **描述**: 获取订单统计数据
- **查询参数**:
  - `startDate`: 开始日期
  - `endDate`: 结束日期

### 工厂服务

#### 获取工厂列表

- **接口**: `GET /api/factories`
- **描述**: 获取工厂列表
- **响应数据**:
  ```json
  [
    {
      "id": "number",
      "name": "string",
      "address": {
        "province": "string",
        "city": "string",
        "district": "string",
        "detail": "string",
        "location": {
          "longitude": "number",
          "latitude": "number"
        }
      },
      "contactPerson": "string",
      "contactPhone": "string",
      "serviceArea": {
        "center": {
          "longitude": "number",
          "latitude": "number"
        },
        "radius": "number",
        "customArea": [
          {
            "longitude": "number",
            "latitude": "number"
          }
        ]
      },
      "capacity": {
        "dailyProduction": "number",
        "currentInventory": "number",
        "maxInventory": "number"
      },
      "productionLines": [
        {
          "id": "number",
          "name": "string",
          "status": "active|maintenance|offline",
          "capacity": "number"
        }
      ],
      "certifications": ["string"],
      "rating": "number",
      "createdAt": "string"
    }
  ]
  ```

#### 获取工厂详情

- **接口**: `GET /api/factories/{id}`
- **描述**: 获取工厂详细信息

#### 创建工厂

- **接口**: `POST /api/factories`
- **描述**: 创建新工厂

#### 更新工厂信息

- **接口**: `PUT /api/factories/{id}`
- **描述**: 更新工厂信息

#### 删除工厂

- **接口**: `DELETE /api/factories/{id}`
- **描述**: 删除工厂

#### 更新工厂服务区域

- **接口**: `PUT /api/factories/{id}/service-area`
- **描述**: 更新工厂服务区域

#### 更新工厂产能信息

- **接口**: `PUT /api/factories/{id}/capacity`
- **描述**: 更新工厂产能信息

#### 更新生产线状态

- **接口**: `PUT /api/factories/{factoryId}/production-lines/{lineId}/status`
- **描述**: 更新生产线状态
- **请求参数**:
  ```json
  {
    "status": "active|maintenance|offline"
  }
  ```

### 供应商服务

#### 获取供应商列表

- **接口**: `GET /api/suppliers`
- **描述**: 获取供应商列表
- **响应数据**:
  ```json
  [
    {
      "id": "number",
      "factoryId": "number",
      "name": "string",
      "description": "string",
      "contactPerson": "string",
      "contactPhone": "string",
      "email": "string",
      "address": {},
      "businessLicense": "string",
      "creditScore": "number",
      "transactionVolume": "number",
      "starRating": "number",
      "onTimeDeliveryRate": "number",
      "products": ["number"],
      "blacklisted": "boolean",
      "blacklistReason": "string",
      "createdAt": "string"
    }
  ]
  ```

#### 获取供应商详情

- **接口**: `GET /api/suppliers/{id}`
- **描述**: 获取供应商详细信息

#### 创建供应商

- **接口**: `POST /api/suppliers`
- **描述**: 创建新供应商

#### 更新供应商信息

- **接口**: `PUT /api/suppliers/{id}`
- **描述**: 更新供应商信息

#### 删除供应商

- **接口**: `DELETE /api/suppliers/{id}`
- **描述**: 删除供应商

#### 更新供应商信用评分

- **接口**: `PUT /api/suppliers/{id}/credit-score`
- **描述**: 更新供应商信用评分
- **请求参数**:
  ```json
  {
    "creditScore": "number"
  }
  ```

#### 将供应商加入黑名单

- **接口**: `PUT /api/suppliers/{id}/blacklist`
- **描述**: 将供应商加入黑名单
- **请求参数**:
  ```json
  {
    "blacklisted": true,
    "blacklistReason": "string"
  }
  ```

#### 将供应商从黑名单移除

- **接口**: `PUT /api/suppliers/{id}/blacklist`
- **描述**: 将供应商从黑名单移除
- **请求参数**:
  ```json
  {
    "blacklisted": false,
    "blacklistReason": ""
  }
  ```

#### 获取供应商评价列表

- **接口**: `GET /api/suppliers/{id}/ratings`
- **描述**: 获取供应商评价列表

### 报告服务

#### 获取行业报告列表

- **接口**: `GET /api/reports/industry`
- **描述**: 获取行业报告列表
- **响应数据**:
  ```json
  [
    {
      "id": "number",
      "title": "string",
      "quarter": "string",
      "summary": "string",
      "pdfUrl": "string",
      "publishedAt": "string",
      "categories": [
        {
          "name": "string",
          "growthRate": "number",
          "marketShare": "number"
        }
      ],
      "regions": [
        {
          "name": "string",
          "demandVolume": "number",
          "growthRate": "number"
        }
      ]
    }
  ]
  ```

#### 获取行业报告详情

- **接口**: `GET /api/reports/industry/{id}`
- **描述**: 获取行业报告详细信息

#### 创建行业报告

- **接口**: `POST /api/reports/industry`
- **描述**: 创建行业报告

#### 更新行业报告

- **接口**: `PUT /api/reports/industry/{id}`
- **描述**: 更新行业报告

#### 删除行业报告

- **接口**: `DELETE /api/reports/industry/{id}`
- **描述**: 删除行业报告

#### 获取统计数据

- **接口**: `GET /api/reports/statistics`
- **描述**: 获取统计数据
- **查询参数**:
  - `startDate`: 开始日期
  - `endDate`: 结束日期
- **响应数据**:
  ```json
  {
    "totalOrders": "number",
    "totalRevenue": "number",
    "totalUsers": {
      "total": "number",
      "individual": "number",
      "business": "number",
      "factory": "number"
    },
    "ordersByStatus": {},
    "revenueByMonth": [
      {
        "month": "string",
        "revenue": "number"
      }
    ],
    "topProducts": [
      {
        "id": "number",
        "name": "string",
        "sales": "number",
        "revenue": "number"
      }
    ],
    "topRegions": [
      {
        "name": "string",
        "orders": "number",
        "revenue": "number"
      }
    ]
  }
  ```

#### 获取天气数据

- **接口**: `GET /api/reports/weather`
- **描述**: 获取天气数据
- **查询参数**:
  - `city`: 城市名称
- **响应数据**:
  ```json
  {
    "city": "string",
    "date": "string",
    "temperature": "number",
    "humidity": "number",
    "weatherType": "string",
    "heatWarningLevel": "none|yellow|orange|red"
  }
  ```

#### 获取热力图数据

- **接口**: `GET /api/reports/heat-map`
- **描述**: 获取热力图数据
- **查询参数**:
  - `region`: 地区名称
- **响应数据**:
  ```json
  [
    {
      "city": "string",
      "location": {
        "longitude": "number",
        "latitude": "number"
      },
      "demandLevel": "number",
      "updatedAt": "string"
    }
  ]
  ```

#### 获取碳足迹报告

- **接口**: `GET /api/reports/carbon-footprint`
- **描述**: 获取碳足迹报告
- **查询参数**:
  - `startDate`: 开始日期
  - `endDate`: 结束日期

### 风控服务

#### 获取风控预警列表

- **接口**: `GET /api/risk-control/alerts`
- **描述**: 获取风控预警列表
- **响应数据**:
  ```json
  [
    {
      "id": "number",
      "type": "price-anomaly|monopoly-risk|malicious-bidding|inventory-warning",
      "severity": "low|medium|high|critical",
      "title": "string",
      "description": "string",
      "affectedArea": ["string"],
      "affectedProducts": ["number"],
      "suggestedActions": ["string"],
      "resolved": "boolean",
      "createdAt": "string",
      "resolvedAt": "string"
    }
  ]
  ```

#### 获取风控预警详情

- **接口**: `GET /api/risk-control/alerts/{id}`
- **描述**: 获取风控预警详细信息

#### 创建风控预警

- **接口**: `POST /api/risk-control/alerts`
- **描述**: 创建风控预警

#### 更新风控预警

- **接口**: `PUT /api/risk-control/alerts/{id}`
- **描述**: 更新风控预警

#### 解决风控预警

- **接口**: `PUT /api/risk-control/alerts/{id}/resolve`
- **描述**: 解决风控预警

#### 获取系统通知列表

- **接口**: `GET /api/risk-control/notifications`
- **描述**: 获取系统通知列表
- **响应数据**:
  ```json
  [
    {
      "id": "number",
      "title": "string",
      "content": "string",
      "type": "info|warning|error|success",
      "targetUserIds": ["number"],
      "read": "boolean",
      "createdAt": "string"
    }
  ]
  ```

#### 创建系统通知

- **接口**: `POST /api/risk-control/notifications`
- **描述**: 创建系统通知

#### 标记通知为已读

- **接口**: `PUT /api/risk-control/notifications/{id}/read`
- **描述**: 标记通知为已读

#### 检测价格异常

- **接口**: `GET /api/risk-control/detect-price-anomaly`
- **描述**: 检测价格异常
- **查询参数**:
  - `region`: 地区
  - `productId`: 产品 ID

#### 检测区域垄断风险

- **接口**: `GET /api/risk-control/detect-monopoly-risk`
- **描述**: 检测区域垄断风险
- **查询参数**:
  - `region`: 地区

#### 检测恶意竞价

- **接口**: `GET /api/risk-control/detect-malicious-bidding`
- **描述**: 检测恶意竞价
- **查询参数**:
  - `supplierId`: 供应商 ID
