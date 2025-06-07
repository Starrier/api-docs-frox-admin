# 冰块订单管理 API 接口文档

## 基础信息

- **Base URL**: `/api/ice-orders`
- **Content-Type**: `application/json`
- **认证方式**: Bearer Token (在请求头中添加 `Authorization: Bearer <token>`)

## 通用响应格式

```typescript
interface ApiResponse<T> {
  code: number; // 状态码：200=成功，-1=网络错误，其他=业务错误
  message: string; // 响应消息
  data: T | null; // 响应数据
  success: boolean; // 是否成功
}
```

## 1. 获取订单列表

### 请求信息

- **URL**: `GET /api/ice-orders`
- **方法**: GET
- **参数**: 无

### 前端调用

```typescript
// 前端调用方式
import { getOrderList } from '@/services/iceOrder/iceOrderService';

const response = await getOrderList();
```

### 期望的后端响应

```json
{
  "code": 200,
  "message": "获取成功",
  "success": true,
  "data": [
    {
      "id": 1,
      "userId": 1,
      "username": "张三",
      "items": [
        {
          "id": 1,
          "iceTypeId": 1,
          "iceTypeName": "方冰",
          "size": "大",
          "quantity": 10,
          "price": 50.0
        }
      ],
      "deliveryDateTime": "2024-01-15T10:00:00Z",
      "deliveryAddress": "北京市朝阳区xxx街道xxx号",
      "contactPerson": "李四",
      "contactPhone": "13800138000",
      "status": "PENDING",
      "createdAt": "2024-01-10T08:00:00Z",
      "updatedAt": "2024-01-10T08:00:00Z"
    }
  ]
}
```

## 2. 获取订单详情

### 请求信息

- **URL**: `GET /api/ice-orders/{id}`
- **方法**: GET
- **路径参数**:
  - `id` (number): 订单 ID

### 前端调用

```typescript
// 前端调用方式
import { getOrderDetail } from '@/services/iceOrder/iceOrderService';

const response = await getOrderDetail(1);
```

### 期望的后端响应

```json
{
  "code": 200,
  "message": "获取成功",
  "success": true,
  "data": {
    "id": 1,
    "userId": 1,
    "username": "张三",
    "items": [
      {
        "id": 1,
        "iceTypeId": 1,
        "iceTypeName": "方冰",
        "size": "大",
        "quantity": 10,
        "price": 50.0
      }
    ],
    "deliveryDateTime": "2024-01-15T10:00:00Z",
    "deliveryAddress": "北京市朝阳区xxx街道xxx号",
    "contactPerson": "李四",
    "contactPhone": "13800138000",
    "status": "PENDING",
    "createdAt": "2024-01-10T08:00:00Z",
    "updatedAt": "2024-01-10T08:00:00Z"
  }
}
```

## 3. 创建订单

### 请求信息

- **URL**: `POST /api/ice-orders`
- **方法**: POST
- **请求体**:

### 前端发送的参数

```typescript
// 前端调用方式
import { createOrder } from '@/services/iceOrder/iceOrderService';

const orderData = {
  userId: 1,
  username: '张三',
  items: [
    {
      iceTypeId: 1,
      quantity: 10,
      size: '大',
    },
  ],
  deliveryDateTime: '2024-01-15T10:00:00Z',
  deliveryAddress: '北京市朝阳区xxx街道xxx号',
  contactPerson: '李四',
  contactPhone: '13800138000',
  status: 'PENDING',
};

const response = await createOrder(orderData);
```

### 期望的后端接收参数

```json
{
  "userId": 1,
  "username": "张三",
  "items": [
    {
      "iceTypeId": 1,
      "quantity": 10,
      "size": "大"
    }
  ],
  "deliveryDateTime": "2024-01-15T10:00:00Z",
  "deliveryAddress": "北京市朝阳区xxx街道xxx号",
  "contactPerson": "李四",
  "contactPhone": "13800138000",
  "status": "PENDING"
}
```

### 期望的后端响应

```json
{
  "code": 200,
  "message": "创建成功",
  "success": true,
  "data": {
    "id": 1,
    "userId": 1,
    "username": "张三",
    "items": [
      {
        "id": 1,
        "iceTypeId": 1,
        "iceTypeName": "方冰",
        "size": "大",
        "quantity": 10,
        "price": 50.0
      }
    ],
    "deliveryDateTime": "2024-01-15T10:00:00Z",
    "deliveryAddress": "北京市朝阳区xxx街道xxx号",
    "contactPerson": "李四",
    "contactPhone": "13800138000",
    "status": "PENDING",
    "createdAt": "2024-01-10T08:00:00Z",
    "updatedAt": "2024-01-10T08:00:00Z"
  }
}
```

## 4. 更新订单

### 请求信息

- **URL**: `PUT /api/ice-orders/{id}`
- **方法**: PUT
- **路径参数**:
  - `id` (number): 订单 ID

### 前端发送的参数

```typescript
// 前端调用方式
import { updateOrder } from '@/services/iceOrder/iceOrderService';

const orderData = {
  userId: 1,
  username: '张三',
  items: [
    {
      iceTypeId: 1,
      quantity: 15, // 修改数量
      size: '大',
    },
  ],
  deliveryDateTime: '2024-01-16T10:00:00Z', // 修改时间
  deliveryAddress: '北京市朝阳区xxx街道xxx号',
  contactPerson: '李四',
  contactPhone: '13800138000',
  status: 'CONFIRMED', // 修改状态
};

const response = await updateOrder(1, orderData);
```

## 5. 更新订单状态

### 请求信息

- **URL**: `PUT /api/ice-orders/{id}/status`
- **方法**: PUT
- **路径参数**:
  - `id` (number): 订单 ID

### 前端发送的参数

```typescript
// 前端调用方式
import { updateOrderStatus } from '@/services/iceOrder/iceOrderService';

const response = await updateOrderStatus(1, 'CONFIRMED');
```

### 期望的后端接收参数

```json
{
  "status": "CONFIRMED"
}
```

## 6. 删除订单

### 请求信息

- **URL**: `DELETE /api/ice-orders/{id}`
- **方法**: DELETE
- **路径参数**:
  - `id` (number): 订单 ID

### 前端调用

```typescript
// 前端调用方式
import { deleteOrder } from '@/services/iceOrder/iceOrderService';

const response = await deleteOrder(1);
```

### 期望的后端响应

```json
{
  "code": 200,
  "message": "删除成功",
  "success": true,
  "data": null
}
```

## 订单状态枚举

```typescript
enum OrderStatus {
  PENDING = 'PENDING', // 待处理
  CONFIRMED = 'CONFIRMED', // 已确认
  PROCESSING = 'PROCESSING', // 处理中
  SHIPPED = 'SHIPPED', // 已发货
  DELIVERED = 'DELIVERED', // 已送达
  CANCELLED = 'CANCELLED', // 已取消
}
```

## 错误处理

### 网络错误 (code: -1)

```json
{
  "code": -1,
  "message": "网络连接失败",
  "success": false,
  "data": null
}
```

### 业务错误示例

```json
{
  "code": 400,
  "message": "订单数据验证失败",
  "success": false,
  "data": null
}
```

```json
{
  "code": 404,
  "message": "订单不存在",
  "success": false,
  "data": null
}
```

```json
{
  "code": 401,
  "message": "未授权访问",
  "success": false,
  "data": null
}
```
