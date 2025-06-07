# API 接口测试用例

## 📋 概述

本文档提供了 Front-Logix-Admin 系统主要 API 接口的测试用例和示例代码。

## 🔐 认证模块测试

### 1. 用户登录

```bash
# cURL 示例
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "123456"
  }'

# 预期响应
{
  "status": 200,
  "message": "登录成功",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "userInfo": {
      "id": "1",
      "username": "admin",
      "email": "admin@example.com",
      "roles": ["admin"]
    }
  }
}
```

### 2. 获取用户信息

```bash
# cURL 示例
curl -X GET http://localhost:3000/api/v1/auth/user-info \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."

# 预期响应
{
  "status": 200,
  "data": {
    "id": "1",
    "username": "admin",
    "email": "admin@example.com",
    "roles": ["admin"],
    "permissions": ["user:read", "user:write", "order:read"]
  }
}
```

## 👥 用户管理测试

### 1. 获取用户列表

```bash
# cURL 示例
curl -X GET "http://localhost:3000/api/v1/queryUserList?current=1&pageSize=10&keyword=admin" \
  -H "Authorization: Bearer {token}"

# 预期响应
{
  "status": 200,
  "data": {
    "list": [
      {
        "id": "1",
        "username": "admin",
        "email": "admin@example.com",
        "phone": "13800138000",
        "status": "active",
        "createdAt": "2024-01-01T00:00:00Z"
      }
    ],
    "total": 1,
    "current": 1,
    "pageSize": 10
  }
}
```

### 2. 创建用户

```bash
# cURL 示例
curl -X POST http://localhost:3000/api/v1/user \
  -H "Authorization: Bearer {token}" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "phone": "13900139000",
    "password": "123456",
    "roles": ["user"]
  }'

# 预期响应
{
  "status": 200,
  "message": "用户创建成功",
  "data": {
    "id": "2",
    "username": "testuser",
    "email": "test@example.com"
  }
}
```

## 📦 产品管理测试

### 1. 获取产品列表

```bash
# cURL 示例
curl -X GET "http://localhost:3000/api/v1/products?current=1&pageSize=10" \
  -H "Authorization: Bearer {token}"

# 预期响应
{
  "status": 200,
  "data": {
    "list": [
      {
        "id": "1",
        "title": "工业制冰机",
        "description": "高效节能的工业制冰设备",
        "features": ["节能环保", "自动化控制", "高产能"],
        "applications": ["食品加工", "化工冷却", "医疗保鲜"],
        "specifications": {
          "power": "5kW",
          "capacity": "500kg/day",
          "size": "120x80x150cm"
        }
      }
    ],
    "total": 1,
    "current": 1,
    "pageSize": 10
  }
}
```

### 2. 创建产品

```bash
# cURL 示例
curl -X POST http://localhost:3000/api/v1/products \
  -H "Authorization: Bearer {token}" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "便携式制冰机",
    "description": "小型便携式制冰设备",
    "features": ["便携轻巧", "快速制冰", "低噪音"],
    "applications": ["家庭使用", "办公室", "户外活动"],
    "specifications": {
      "power": "150W",
      "capacity": "12kg/day",
      "size": "35x25x32cm"
    },
    "images": [
      {
        "src": "/images/portable-ice-maker.jpg",
        "alt": "便携式制冰机"
      }
    ]
  }'
```

## 🧊 冰块订单测试

### 1. 获取订单列表

```bash
# cURL 示例
curl -X GET "http://localhost:3000/api/v1/ice-orders?current=1&pageSize=10&status=pending" \
  -H "Authorization: Bearer {token}"

# 预期响应
{
  "status": 200,
  "data": {
    "list": [
      {
        "id": "1",
        "orderNumber": "ICE20240101001",
        "userId": "2",
        "username": "testuser",
        "supplierId": "1",
        "supplierName": "冰雪工厂",
        "items": [
          {
            "id": "1",
            "iceTypeId": "1",
            "iceTypeName": "工业冰块",
            "quantity": 100,
            "size": "10x10x10cm",
            "unitPrice": 2.50,
            "totalPrice": 250.00
          }
        ],
        "totalAmount": 250.00,
        "status": "pending",
        "createdAt": "2024-01-01T10:00:00Z"
      }
    ],
    "total": 1
  }
}
```

### 2. 创建订单

```bash
# cURL 示例
curl -X POST http://localhost:3000/api/v1/ice-orders \
  -H "Authorization: Bearer {token}" \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "2",
    "supplierId": "1",
    "items": [
      {
        "iceTypeId": "1",
        "quantity": 50,
        "size": "10x10x10cm"
      }
    ],
    "deliveryInfo": {
      "type": "delivery",
      "address": {
        "province": "北京市",
        "city": "北京市",
        "district": "朝阳区",
        "detail": "三里屯街道1号"
      },
      "contactPerson": "张三",
      "contactPhone": "13800138000",
      "expectedDeliveryTime": "2024-01-02T14:00:00Z"
    },
    "urgencyLevel": "normal"
  }'
```

## 📊 监控报表测试

### 1. 获取 UV/PV 统计

```bash
# cURL 示例
curl -X GET "http://localhost:3000/api/v1/monitoring/uv-pv/stats?startTime=1704067200000&endTime=1704153600000" \
  -H "Authorization: Bearer {token}"

# 预期响应
{
  "status": 200,
  "data": [
    {
      "date": "2024-01-01",
      "pv": 1250,
      "uv": 320,
      "newUsers": 45,
      "bounceRate": 35.2,
      "avgSessionDuration": 180
    }
  ]
}
```

### 2. 获取用户行为轨迹

```bash
# cURL 示例
curl -X GET "http://localhost:3000/api/v1/monitoring/user-behavior/tracks?current=1&pageSize=20" \
  -H "Authorization: Bearer {token}"

# 预期响应
{
  "status": 200,
  "data": {
    "list": [
      {
        "id": "1",
        "userId": "user123",
        "sessionId": "session456",
        "timestamp": 1704067200000,
        "page": "/dashboard",
        "action": "page_view",
        "duration": 120,
        "referrer": "/login",
        "location": "北京市"
      }
    ],
    "total": 100
  }
}
```

## 💬 消息中心测试

### 1. 获取消息列表

```bash
# cURL 示例
curl -X GET "http://localhost:3000/api/v1/message/list?current=1&pageSize=10&status=sent" \
  -H "Authorization: Bearer {token}"

# 预期响应
{
  "status": 200,
  "data": {
    "list": [
      {
        "id": "1",
        "title": "系统维护通知",
        "content": "系统将于今晚22:00-24:00进行维护",
        "platform": "all",
        "status": "sent",
        "targetAudience": {
          "type": "all"
        },
        "statistics": {
          "sent": 1000,
          "delivered": 980,
          "read": 750,
          "clicked": 120
        },
        "sentTime": "2024-01-01T14:00:00Z"
      }
    ],
    "total": 1
  }
}
```

### 2. 创建消息

```bash
# cURL 示例
curl -X POST http://localhost:3000/api/v1/message \
  -H "Authorization: Bearer {token}" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "新功能上线通知",
    "content": "我们很高兴地宣布新的订单管理功能已经上线！",
    "platform": "all",
    "targetAudience": {
      "type": "all"
    },
    "scheduledTime": "2024-01-02T10:00:00Z",
    "priority": "normal"
  }'
```

### 3. 发送消息

```bash
# cURL 示例
curl -X POST http://localhost:3000/api/v1/message/1/send \
  -H "Authorization: Bearer {token}"

# 预期响应
{
  "status": 200,
  "message": "消息发送成功",
  "data": {
    "messageId": "1",
    "sentCount": 1000,
    "estimatedDeliveryTime": "2024-01-02T10:05:00Z"
  }
}
```

## 🔧 增强服务测试

### 1. 获取增强用户列表

```bash
# cURL 示例
curl -X GET http://localhost:3000/api/enhanced-users \
  -H "Authorization: Bearer {token}"

# 预期响应
{
  "status": 200,
  "data": [
    {
      "id": 1,
      "username": "factory_user",
      "email": "factory@example.com",
      "type": "factory",
      "businessType": "制冰工厂",
      "creditScore": 85,
      "address": {
        "province": "北京市",
        "city": "北京市",
        "district": "朝阳区",
        "detail": "工业园区A区",
        "location": {
          "longitude": 116.4074,
          "latitude": 39.9042
        }
      }
    }
  ]
}
```

### 2. 获取工厂列表

```bash
# cURL 示例
curl -X GET http://localhost:3000/api/factories \
  -H "Authorization: Bearer {token}"

# 预期响应
{
  "status": 200,
  "data": [
    {
      "id": 1,
      "name": "北京冰雪制造厂",
      "address": {
        "province": "北京市",
        "city": "北京市",
        "district": "大兴区",
        "detail": "工业开发区18号",
        "location": {
          "longitude": 116.3380,
          "latitude": 39.7280
        }
      },
      "contactPerson": "李经理",
      "contactPhone": "010-12345678",
      "capacity": {
        "dailyProduction": 5000,
        "currentInventory": 2000,
        "maxInventory": 8000
      },
      "rating": 4.5
    }
  ]
}
```

## 🧪 JavaScript 测试示例

### 使用 Axios 进行 API 测试

```javascript
// 配置 axios 实例
const api = axios.create({
  baseURL: 'http://localhost:3000/api/v1',
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json',
  },
});

// 添加请求拦截器
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// 登录测试
async function testLogin() {
  try {
    const response = await api.post('/auth/login', {
      username: 'admin',
      password: '123456',
    });

    console.log('登录成功:', response.data);
    localStorage.setItem('token', response.data.data.token);
    return response.data;
  } catch (error) {
    console.error('登录失败:', error.response?.data || error.message);
  }
}

// 获取用户列表测试
async function testGetUsers() {
  try {
    const response = await api.get('/queryUserList', {
      params: {
        current: 1,
        pageSize: 10,
        keyword: '',
      },
    });

    console.log('用户列表:', response.data);
    return response.data;
  } catch (error) {
    console.error('获取用户列表失败:', error.response?.data || error.message);
  }
}

// 创建订单测试
async function testCreateOrder() {
  try {
    const orderData = {
      userId: '2',
      supplierId: '1',
      items: [
        {
          iceTypeId: '1',
          quantity: 100,
          size: '10x10x10cm',
        },
      ],
      deliveryInfo: {
        type: 'delivery',
        address: {
          province: '北京市',
          city: '北京市',
          district: '朝阳区',
          detail: '三里屯街道1号',
        },
        contactPerson: '张三',
        contactPhone: '13800138000',
        expectedDeliveryTime: '2024-01-02T14:00:00Z',
      },
      urgencyLevel: 'normal',
    };

    const response = await api.post('/ice-orders', orderData);
    console.log('订单创建成功:', response.data);
    return response.data;
  } catch (error) {
    console.error('创建订单失败:', error.response?.data || error.message);
  }
}

// 运行所有测试
async function runAllTests() {
  console.log('开始API测试...');

  await testLogin();
  await testGetUsers();
  await testCreateOrder();

  console.log('API测试完成');
}

// 执行测试
runAllTests();
```

## 📝 测试注意事项

### 1. 环境准备

- 确保后端服务正在运行
- 数据库已正确初始化
- 测试数据已准备就绪

### 2. 认证要求

- 大部分 API 需要有效的 JWT Token
- Token 需要在请求头中正确设置
- 注意 Token 的过期时间

### 3. 数据格式

- 请求数据必须是有效的 JSON 格式
- 日期时间使用 ISO 8601 格式
- 数值类型注意精度要求

### 4. 错误处理

- 检查 HTTP 状态码
- 解析错误响应中的详细信息
- 实现适当的重试机制

### 5. 性能测试

- 监控 API 响应时间
- 测试并发请求处理能力
- 验证大数据量查询性能

---

> 💡 **提示**: 建议使用 Postman 或类似工具创建完整的 API 测试集合，便于团队协作和自动化测试。
