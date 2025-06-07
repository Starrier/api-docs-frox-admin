# 数据分析 API 文档

## 概述

数据分析模块提供业务看板、报表中心和数据洞察功能。

## 业务看板 API

### 获取仪表板数据

**接口地址：** `GET /api/analytics/dashboard`

**请求参数：**

```typescript
{
  timeRange?: {
    start: string;          // 开始日期
    end: string;            // 结束日期
  };
  modules?: string[];       // 指定模块 ['orders', 'suppliers', 'revenue', 'users']
}
```

**响应示例：**

```json
{
  "status": 200,
  "data": {
    "overview": {
      "totalOrders": 1250,
      "totalRevenue": 125000,
      "totalUsers": 89,
      "totalSuppliers": 45,
      "totalFactories": 12,
      "activeOrders": 23
    },
    "orderStats": {
      "pending": 15,
      "processing": 8,
      "shipped": 12,
      "delivered": 1200,
      "cancelled": 15
    },
    "revenueStats": {
      "today": 5200,
      "thisWeek": 32000,
      "thisMonth": 125000,
      "growth": {
        "daily": 5.2,
        "weekly": 12.8,
        "monthly": 8.5
      }
    },
    "systemHealth": {
      "orderProcessingRate": 95.5,
      "supplierActiveRate": 84.4,
      "systemUptime": 99.9
    }
  }
}
```

### 获取实时数据

**接口地址：** `GET /api/analytics/realtime`

**响应示例：**

```json
{
  "status": 200,
  "data": {
    "activeUsers": 25,
    "ongoingOrders": 8,
    "systemLoad": 65.2,
    "responseTime": 120,
    "errorRate": 0.1,
    "lastUpdated": "2024-01-15T10:30:00Z"
  }
}
```

### 获取关键指标

**接口地址：** `GET /api/analytics/kpi`

**请求参数：**

```typescript
{
  metrics: string[];        // 指标名称数组
  timeRange: {
    start: string;
    end: string;
  };
  granularity?: 'hour' | 'day' | 'week' | 'month';
}
```

## 报表中心 API

### 获取报表列表

**接口地址：** `GET /api/reports`

**请求参数：**

```typescript
{
  category?: string;        // 报表分类
  current?: number;
  pageSize?: number;
}
```

**响应示例：**

```json
{
  "status": 200,
  "data": [
    {
      "id": 1,
      "name": "订单分析报表",
      "description": "订单趋势和状态分析",
      "category": "orders",
      "type": "chart",
      "schedule": "daily",
      "lastGenerated": "2024-01-15T08:00:00Z",
      "status": "active"
    }
  ]
}
```

### 生成报表

**接口地址：** `POST /api/reports/generate`

**请求体：**

```typescript
{
  reportType: string;       // 报表类型
  parameters: {
    timeRange: {
      start: string;
      end: string;
    };
    filters?: Record<string, any>;
    format?: 'json' | 'excel' | 'pdf';
  };
}
```

### 订单分析报表

**接口地址：** `GET /api/reports/orders`

**请求参数：**

```typescript
{
  timeRange: {
    start: string;
    end: string;
  };
  groupBy?: 'day' | 'week' | 'month';
  metrics?: string[];       // ['count', 'revenue', 'avgValue']
}
```

**响应示例：**

```json
{
  "status": 200,
  "data": {
    "summary": {
      "totalOrders": 1250,
      "totalRevenue": 125000,
      "avgOrderValue": 100,
      "completionRate": 95.5
    },
    "trends": [
      {
        "date": "2024-01-01",
        "orders": 45,
        "revenue": 4500,
        "avgValue": 100
      }
    ],
    "statusDistribution": {
      "pending": 15,
      "processing": 8,
      "shipped": 12,
      "delivered": 1200,
      "cancelled": 15
    }
  }
}
```

### 供应商分析报表

**接口地址：** `GET /api/reports/suppliers`

**响应示例：**

```json
{
  "status": 200,
  "data": {
    "summary": {
      "totalSuppliers": 45,
      "activeSuppliers": 38,
      "avgRating": 4.2,
      "avgCreditScore": 78.5
    },
    "topSuppliers": [
      {
        "id": 1,
        "name": "冰雪工厂A",
        "orders": 150,
        "revenue": 15000,
        "rating": 4.8,
        "creditScore": 95
      }
    ],
    "ratingDistribution": {
      "5": 12,
      "4": 18,
      "3": 10,
      "2": 3,
      "1": 2
    }
  }
}
```

### 产品分析报表

**接口地址：** `GET /api/reports/products`

**响应示例：**

```json
{
  "status": 200,
  "data": {
    "summary": {
      "totalProducts": 25,
      "totalSales": 15000,
      "avgPrice": 12.5
    },
    "popularProducts": [
      {
        "id": 1,
        "name": "标准冰块",
        "sales": 500,
        "revenue": 25000,
        "growth": 15.2
      }
    ],
    "categoryAnalysis": [
      {
        "category": "标准冰块",
        "sales": 800,
        "revenue": 40000,
        "share": 32.0
      }
    ]
  }
}
```

### 财务分析报表

**接口地址：** `GET /api/reports/financial`

**响应示例：**

```json
{
  "status": 200,
  "data": {
    "revenue": {
      "total": 125000,
      "growth": 8.5,
      "breakdown": {
        "products": 100000,
        "services": 25000
      }
    },
    "costs": {
      "total": 75000,
      "breakdown": {
        "materials": 45000,
        "labor": 20000,
        "overhead": 10000
      }
    },
    "profit": {
      "gross": 50000,
      "net": 40000,
      "margin": 32.0
    }
  }
}
```

## 数据导出 API

### 导出报表

**接口地址：** `POST /api/reports/export`

**请求体：**

```typescript
{
  reportId?: number;        // 报表ID
  reportType?: string;      // 报表类型
  format: 'excel' | 'pdf' | 'csv';
  parameters?: {
    timeRange: {
      start: string;
      end: string;
    };
    filters?: Record<string, any>;
  };
}
```

**响应示例：**

```json
{
  "status": 200,
  "data": {
    "downloadUrl": "https://api.example.com/downloads/report_20240115.xlsx",
    "filename": "订单分析报表_20240115.xlsx",
    "size": 1024000,
    "expiresAt": "2024-01-16T10:30:00Z"
  }
}
```

### 批量导出

**接口地址：** `POST /api/reports/batch-export`

**请求体：**

```typescript
{
  reports: Array<{
    reportType: string;
    parameters: Record<string, any>;
  }>;
  format: 'excel' | 'pdf';
  compression?: boolean;    // 是否压缩
}
```

## 数据洞察 API

### 获取业务洞察

**接口地址：** `GET /api/analytics/insights`

**响应示例：**

```json
{
  "status": 200,
  "data": {
    "insights": [
      {
        "type": "trend",
        "title": "订单量持续增长",
        "description": "过去30天订单量增长15%，主要来自新客户",
        "impact": "positive",
        "confidence": 0.85,
        "recommendations": ["增加库存准备", "优化配送路线"]
      }
    ],
    "alerts": [
      {
        "type": "warning",
        "message": "供应商A库存不足",
        "severity": "medium",
        "actionRequired": true
      }
    ]
  }
}
```

### 预测分析

**接口地址：** `GET /api/analytics/forecast`

**请求参数：**

```typescript
{
  metric: string;           // 预测指标
  horizon: number;          // 预测时间范围(天)
  confidence?: number;      // 置信度
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
| 422    | 业务逻辑错误   |
| 500    | 服务器内部错误 |

## 数据类型定义

### DashboardData 仪表板数据

```typescript
interface DashboardData {
  overview: {
    totalOrders: number;
    totalRevenue: number;
    totalUsers: number;
    totalSuppliers: number;
    totalFactories: number;
    activeOrders: number;
  };
  orderStats: Record<string, number>;
  revenueStats: {
    today: number;
    thisWeek: number;
    thisMonth: number;
    growth: {
      daily: number;
      weekly: number;
      monthly: number;
    };
  };
  systemHealth: {
    orderProcessingRate: number;
    supplierActiveRate: number;
    systemUptime: number;
  };
}
```

### Report 报表

```typescript
interface Report {
  id: number;
  name: string;
  description: string;
  category: string;
  type: 'chart' | 'table' | 'mixed';
  schedule: 'manual' | 'daily' | 'weekly' | 'monthly';
  lastGenerated: string;
  status: 'active' | 'inactive';
  parameters?: Record<string, any>;
}
```
