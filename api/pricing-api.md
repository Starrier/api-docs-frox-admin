# 定价管理 API 文档

## 概述

定价管理模块提供动态定价策略、智能检索和价格分析功能。

## 定价策略 API

### 获取定价策略列表

**接口地址：** `GET /api/pricing/strategies`

**请求参数：**

```typescript
{
  productType?: string;    // 产品类型
  current?: number;        // 当前页码
  pageSize?: number;       // 每页数量
  status?: string;         // 策略状态
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
      "productType": "standard_ice",
      "basePrice": 10.0,
      "tierPricing": [
        {
          "minQuantity": 1,
          "maxQuantity": 100,
          "price": 10.0
        },
        {
          "minQuantity": 101,
          "maxQuantity": 500,
          "price": 9.5
        }
      ],
      "seasonalFactors": {
        "summer": 1.2,
        "winter": 0.8
      },
      "emergencyMultiplier": 1.5,
      "status": "active",
      "createdAt": "2024-01-01T00:00:00Z"
    }
  ]
}
```

### 获取定价策略详情

**接口地址：** `GET /api/pricing/strategies/{id}`

### 创建定价策略

**接口地址：** `POST /api/pricing/strategies`

**请求体：**

```typescript
{
  productType: string;      // 产品类型
  basePrice: number;        // 基础价格
  tierPricing: Array<{      // 阶梯定价
    minQuantity: number;
    maxQuantity: number;
    price: number;
  }>;
  seasonalFactors: {        // 季节性系数
    spring?: number;
    summer?: number;
    autumn?: number;
    winter?: number;
  };
  emergencyMultiplier: number; // 紧急情况倍数
}
```

### 更新定价策略

**接口地址：** `PUT /api/pricing/strategies/{id}`

### 删除定价策略

**接口地址：** `DELETE /api/pricing/strategies/{id}`

### 价格计算

**接口地址：** `POST /api/pricing/calculate`

**请求体：**

```typescript
{
  productType: string;      // 产品类型
  quantity: number;         // 数量
  urgency?: 'normal' | 'urgent' | 'emergency'; // 紧急程度
  season?: 'spring' | 'summer' | 'autumn' | 'winter'; // 季节
  deliveryDate?: string;    // 交付日期
}
```

**响应示例：**

```json
{
  "status": 200,
  "data": {
    "basePrice": 10.0,
    "quantity": 150,
    "tierPrice": 9.5,
    "seasonalFactor": 1.0,
    "urgencyMultiplier": 1.0,
    "finalPrice": 1425.0,
    "unitPrice": 9.5,
    "breakdown": {
      "baseAmount": 1500.0,
      "tierDiscount": -75.0,
      "seasonalAdjustment": 0.0,
      "urgencyAdjustment": 0.0
    }
  }
}
```

## 智能检索 API

### 产品搜索

**接口地址：** `GET /api/search/products`

**请求参数：**

```typescript
{
  keyword?: string;         // 搜索关键词
  filters?: {
    priceRange?: [number, number]; // 价格范围
    urgency?: string;       // 紧急程度
    transportMethod?: string; // 运输方式
    certifications?: string[]; // 认证标识
    rating?: number;        // 最低评分
    location?: string;      // 地理位置
  };
  sort?: {
    field: string;          // 排序字段
    order: 'asc' | 'desc';  // 排序方向
  };
  current?: number;
  pageSize?: number;
}
```

**响应示例：**

```json
{
  "status": 200,
  "data": {
    "list": [
      {
        "id": 1,
        "name": "标准冰块",
        "description": "高质量标准冰块",
        "price": 10.0,
        "supplier": {
          "id": 1,
          "name": "冰雪工厂A",
          "rating": 4.5
        },
        "certifications": ["ISO9001", "HACCP"],
        "transportMethods": ["truck", "express"],
        "urgencySupport": ["normal", "urgent"],
        "location": "北京",
        "stock": 1000
      }
    ],
    "total": 1,
    "current": 1,
    "pageSize": 10
  }
}
```

### 供应商搜索

**接口地址：** `GET /api/search/suppliers`

**请求参数：**

```typescript
{
  keyword?: string;
  filters?: {
    rating?: number;        // 最低评分
    creditScore?: number;   // 最低信用分
    serviceAreas?: string[]; // 服务区域
    certifications?: string[]; // 认证
  };
  current?: number;
  pageSize?: number;
}
```

### 高级搜索

**接口地址：** `POST /api/search/advanced`

**请求体：**

```typescript
{
  searchType: 'products' | 'suppliers' | 'both';
  criteria: {
    keyword?: string;
    location?: {
      city: string;
      radius?: number;      // 搜索半径(km)
    };
    priceRange?: [number, number];
    qualityRequirements?: {
      minRating: number;
      certifications: string[];
    };
    deliveryRequirements?: {
      urgency: string;
      maxDeliveryTime: number; // 最大交付时间(小时)
    };
  };
}
```

## 价格分析 API

### 价格趋势分析

**接口地址：** `GET /api/pricing/trends`

**请求参数：**

```typescript
{
  productType?: string;
  timeRange: {
    start: string;          // 开始日期
    end: string;            // 结束日期
  };
  granularity?: 'day' | 'week' | 'month'; // 时间粒度
}
```

**响应示例：**

```json
{
  "status": 200,
  "data": {
    "productType": "standard_ice",
    "trends": [
      {
        "date": "2024-01-01",
        "avgPrice": 10.0,
        "minPrice": 9.0,
        "maxPrice": 12.0,
        "volume": 1000
      }
    ],
    "summary": {
      "avgPrice": 10.2,
      "priceChange": 0.2,
      "changePercent": 2.0,
      "totalVolume": 30000
    }
  }
}
```

### 竞争对手价格分析

**接口地址：** `GET /api/pricing/competitive-analysis`

### 价格优化建议

**接口地址：** `GET /api/pricing/optimization-suggestions`

**请求参数：**

```typescript
{
  productType: string;
  targetMargin?: number;    // 目标利润率
  competitorPrices?: number[]; // 竞争对手价格
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

### PricingStrategy 定价策略

```typescript
interface PricingStrategy {
  id: number;
  productType: string;
  basePrice: number;
  tierPricing: TierPrice[];
  seasonalFactors: SeasonalFactors;
  emergencyMultiplier: number;
  status: 'active' | 'inactive';
  createdAt: string;
  updatedAt: string;
}

interface TierPrice {
  minQuantity: number;
  maxQuantity: number;
  price: number;
}

interface SeasonalFactors {
  spring?: number;
  summer?: number;
  autumn?: number;
  winter?: number;
}
```

### SearchResult 搜索结果

```typescript
interface SearchResult {
  products?: ProductSearchItem[];
  suppliers?: SupplierSearchItem[];
  total: number;
  current: number;
  pageSize: number;
}

interface ProductSearchItem {
  id: number;
  name: string;
  description: string;
  price: number;
  supplier: {
    id: number;
    name: string;
    rating: number;
  };
  certifications: string[];
  transportMethods: string[];
  urgencySupport: string[];
  location: string;
  stock: number;
}
```
