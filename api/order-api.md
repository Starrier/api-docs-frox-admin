# 冰块订单服务 API 文档

## 订单状态说明

```typescript
enum OrderStatus {
  PENDING = 'pending', // 待处理
  PROCESSING = 'processing', // 处理中
  SHIPPED = 'shipped', // 已发货
  DELIVERED = 'delivered', // 已送达
  CANCELLED = 'cancelled', // 已取消
}
```

## 获取订单列表

**请求方式**: GET  
**路径**: /api/orders

### 请求参数

| 参数名 | 类型   | 必填 | 说明               |
| ------ | ------ | ---- | ------------------ |
| userId | number | 否   | 过滤指定用户的订单 |

### 响应示例

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "userId": 123,
      "iceType": "block",
      "quantity": 10,
      "status": "processing",
      "createdAt": "2023-01-01T00:00:00Z"
    }
  ],
  "total": 15
}
```

## 获取订单详情

**请求方式**: GET  
**路径**: /api/orders/{id}

### 路径参数

| 参数名 | 类型   | 必填 | 说明    |
| ------ | ------ | ---- | ------- |
| id     | number | 是   | 订单 ID |

### 响应示例

```json
{
  "success": true,
  "data": {
    "id": 1,
    "userId": 123,
    "iceType": "block",
    "quantity": 10,
    "status": "processing",
    "details": {
      "shippingAddress": "北京市朝阳区",
      "contactPhone": "13800138000"
    },
    "createdAt": "2023-01-01T00:00:00Z"
  }
}
```

## 创建订单

**请求方式**: POST  
**路径**: /api/orders

### 请求体参数

| 参数名   | 类型   | 必填 | 说明     |
| -------- | ------ | ---- | -------- |
| userId   | number | 是   | 用户 ID  |
| iceType  | string | 是   | 冰块类型 |
| quantity | number | 是   | 数量     |
| details  | object | 否   | 订单详情 |

### 请求示例

```json
{
  "userId": 123,
  "iceType": "block",
  "quantity": 10,
  "details": {
    "shippingAddress": "北京市朝阳区",
    "contactPhone": "13800138000"
  }
}
```

## 更新订单

**请求方式**: PUT  
**路径**: /api/orders/{id}

### 路径参数

| 参数名 | 类型   | 必填 | 说明    |
| ------ | ------ | ---- | ------- |
| id     | number | 是   | 订单 ID |

### 请求体参数

支持部分更新，可只传需要修改的字段

## 更新订单状态

**请求方式**: PUT  
**路径**: /api/orders/{id}/status

### 路径参数

| 参数名 | 类型   | 必填 | 说明    |
| ------ | ------ | ---- | ------- |
| id     | number | 是   | 订单 ID |

### 查询参数

| 参数名 | 类型   | 必填 | 说明     |
| ------ | ------ | ---- | -------- |
| status | string | 是   | 新状态值 |

## 删除订单

**请求方式**: DELETE  
**路径**: /api/orders/{id}

### 路径参数

| 参数名 | 类型   | 必填 | 说明    |
| ------ | ------ | ---- | ------- |
| id     | number | 是   | 订单 ID |
