-- Front-Logix-Admin 数据库建表语句
-- 支持MySQL 8.0+

-- 设置字符集
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ================================
-- 用户认证模块
-- ================================

-- 用户表
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `email` varchar(100) NOT NULL COMMENT '邮箱',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `password_hash` varchar(255) NOT NULL COMMENT '密码哈希',
  `status` enum('active','disabled','pending') DEFAULT 'active' COMMENT '用户状态',
  `last_login_at` timestamp NULL DEFAULT NULL COMMENT '最后登录时间',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  UNIQUE KEY `uk_email` (`email`),
  KEY `idx_status` (`status`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- 角色表
CREATE TABLE `roles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `name` varchar(50) NOT NULL COMMENT '角色名称',
  `description` text COMMENT '角色描述',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色表';

-- 权限表
CREATE TABLE `permissions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '权限ID',
  `name` varchar(50) NOT NULL COMMENT '权限名称',
  `code` varchar(100) NOT NULL COMMENT '权限代码',
  `description` text COMMENT '权限描述',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='权限表';

-- 用户角色关联表
CREATE TABLE `user_roles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint(20) unsigned NOT NULL COMMENT '用户ID',
  `role_id` bigint(20) unsigned NOT NULL COMMENT '角色ID',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_role` (`user_id`, `role_id`),
  KEY `fk_user_roles_role` (`role_id`),
  CONSTRAINT `fk_user_roles_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_user_roles_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户角色关联表';

-- 角色权限关联表
CREATE TABLE `role_permissions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `role_id` bigint(20) unsigned NOT NULL COMMENT '角色ID',
  `permission_id` bigint(20) unsigned NOT NULL COMMENT '权限ID',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_permission` (`role_id`, `permission_id`),
  KEY `fk_role_permissions_permission` (`permission_id`),
  CONSTRAINT `fk_role_permissions_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_role_permissions_permission` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色权限关联表';

-- ================================
-- 产品管理模块
-- ================================

-- 产品表
CREATE TABLE `products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '产品ID',
  `title` varchar(200) NOT NULL COMMENT '产品标题',
  `description` text COMMENT '产品描述',
  `features` json COMMENT '产品特性(JSON数组)',
  `applications` json COMMENT '应用场景(JSON数组)',
  `specifications` json COMMENT '产品规格(JSON对象)',
  `status` enum('active','inactive','draft') DEFAULT 'active' COMMENT '产品状态',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='产品表';

-- 产品图片表
CREATE TABLE `product_images` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '图片ID',
  `product_id` bigint(20) unsigned NOT NULL COMMENT '产品ID',
  `src` varchar(500) NOT NULL COMMENT '图片URL',
  `alt` varchar(200) DEFAULT NULL COMMENT '图片描述',
  `sort_order` int(11) DEFAULT 0 COMMENT '排序',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `fk_product_images_product` (`product_id`),
  KEY `idx_sort_order` (`sort_order`),
  CONSTRAINT `fk_product_images_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='产品图片表';

-- ================================
-- 冰块订单模块
-- ================================

-- 冰块类型表
CREATE TABLE `ice_types` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '冰块类型ID',
  `name` varchar(100) NOT NULL COMMENT '冰块名称',
  `description` text COMMENT '冰块描述',
  `category` enum('industrial','food','cooling') DEFAULT 'food' COMMENT '冰块分类',
  `specifications` json COMMENT '规格信息(JSON对象)',
  `certifications` json COMMENT '认证标识(JSON数组)',
  `images` json COMMENT '图片URL列表(JSON数组)',
  `model_3d` varchar(500) DEFAULT NULL COMMENT '3D模型URL',
  `status` enum('active','inactive') DEFAULT 'active' COMMENT '状态',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_category` (`category`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='冰块类型表';

-- 冰块价格表
CREATE TABLE `ice_type_prices` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '价格ID',
  `ice_type_id` bigint(20) unsigned NOT NULL COMMENT '冰块类型ID',
  `base_price` decimal(10,2) NOT NULL COMMENT '基础价格',
  `unit` varchar(20) NOT NULL COMMENT '价格单位',
  `bulk_discounts` json COMMENT '批量折扣(JSON数组)',
  `seasonal_factors` json COMMENT '季节性因素(JSON数组)',
  `emergency_factor` decimal(5,2) DEFAULT 1.00 COMMENT '紧急情况价格系数',
  `effective_date` date NOT NULL COMMENT '生效日期',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `fk_ice_type_prices_ice_type` (`ice_type_id`),
  KEY `idx_effective_date` (`effective_date`),
  CONSTRAINT `fk_ice_type_prices_ice_type` FOREIGN KEY (`ice_type_id`) REFERENCES `ice_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='冰块价格表';

-- 增强用户表
CREATE TABLE `enhanced_users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `email` varchar(100) NOT NULL COMMENT '邮箱',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `type` enum('individual','business','factory') DEFAULT 'individual' COMMENT '用户类型',
  `business_type` varchar(100) DEFAULT NULL COMMENT '业务类型',
  `credit_score` int(11) DEFAULT 0 COMMENT '信用评分',
  `address` json COMMENT '地址信息(JSON对象)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `last_login_at` timestamp NULL DEFAULT NULL COMMENT '最后登录时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  UNIQUE KEY `uk_email` (`email`),
  KEY `idx_type` (`type`),
  KEY `idx_credit_score` (`credit_score`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='增强用户表';

-- 工厂表
CREATE TABLE `factories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '工厂ID',
  `name` varchar(200) NOT NULL COMMENT '工厂名称',
  `address` json NOT NULL COMMENT '工厂地址(JSON对象)',
  `contact_person` varchar(50) NOT NULL COMMENT '联系人',
  `contact_phone` varchar(20) NOT NULL COMMENT '联系电话',
  `service_area` json COMMENT '服务区域(JSON对象)',
  `capacity` json COMMENT '产能信息(JSON对象)',
  `production_lines` json COMMENT '生产线信息(JSON数组)',
  `certifications` json COMMENT '工厂认证(JSON数组)',
  `rating` decimal(3,2) DEFAULT 0.00 COMMENT '评分',
  `status` enum('active','inactive','maintenance') DEFAULT 'active' COMMENT '状态',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`),
  KEY `idx_rating` (`rating`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='工厂表';

-- 供应商表
CREATE TABLE `suppliers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '供应商ID',
  `factory_id` bigint(20) unsigned NOT NULL COMMENT '工厂ID',
  `name` varchar(200) NOT NULL COMMENT '供应商名称',
  `description` text COMMENT '供应商描述',
  `contact_person` varchar(50) NOT NULL COMMENT '联系人',
  `contact_phone` varchar(20) NOT NULL COMMENT '联系电话',
  `email` varchar(100) NOT NULL COMMENT '邮箱',
  `address` json NOT NULL COMMENT '地址信息(JSON对象)',
  `business_license` varchar(100) NOT NULL COMMENT '营业执照号',
  `credit_score` int(11) DEFAULT 0 COMMENT '信用评分',
  `transaction_volume` decimal(15,2) DEFAULT 0.00 COMMENT '交易量',
  `star_rating` decimal(3,2) DEFAULT 0.00 COMMENT '星级评分',
  `on_time_delivery_rate` decimal(5,2) DEFAULT 0.00 COMMENT '准时交付率',
  `products` json COMMENT '产品ID列表(JSON数组)',
  `blacklisted` tinyint(1) DEFAULT 0 COMMENT '是否黑名单',
  `blacklist_reason` text COMMENT '黑名单原因',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `fk_suppliers_factory` (`factory_id`),
  KEY `idx_credit_score` (`credit_score`),
  KEY `idx_star_rating` (`star_rating`),
  KEY `idx_blacklisted` (`blacklisted`),
  CONSTRAINT `fk_suppliers_factory` FOREIGN KEY (`factory_id`) REFERENCES `factories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='供应商表';

-- 增强订单表
CREATE TABLE `enhanced_orders` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_number` varchar(50) NOT NULL COMMENT '订单编号',
  `user_id` bigint(20) unsigned NOT NULL COMMENT '用户ID',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `supplier_id` bigint(20) unsigned NOT NULL COMMENT '供应商ID',
  `supplier_name` varchar(200) NOT NULL COMMENT '供应商名称',
  `items` json NOT NULL COMMENT '订单项目(JSON数组)',
  `total_amount` decimal(15,2) NOT NULL COMMENT '总金额',
  `delivery_info` json NOT NULL COMMENT '配送信息(JSON对象)',
  `urgency_level` enum('normal','urgent','emergency') DEFAULT 'normal' COMMENT '紧急程度',
  `status` enum('pending','confirmed','processing','shipped','delivered','cancelled') DEFAULT 'pending' COMMENT '订单状态',
  `payment_status` enum('unpaid','paid','refunded') DEFAULT 'unpaid' COMMENT '支付状态',
  `payment_method` enum('alipay','wechat','bank-transfer','cash') DEFAULT NULL COMMENT '支付方式',
  `logistics_info` json COMMENT '物流信息(JSON对象)',
  `insurance` json COMMENT '保险信息(JSON对象)',
  `contract` json COMMENT '合同信息(JSON对象)',
  `carbon_footprint` json COMMENT '碳足迹信息(JSON对象)',
  `notes` text COMMENT '备注',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_number` (`order_number`),
  KEY `fk_enhanced_orders_user` (`user_id`),
  KEY `fk_enhanced_orders_supplier` (`supplier_id`),
  KEY `idx_status` (`status`),
  KEY `idx_payment_status` (`payment_status`),
  KEY `idx_urgency_level` (`urgency_level`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `fk_enhanced_orders_user` FOREIGN KEY (`user_id`) REFERENCES `enhanced_users` (`id`),
  CONSTRAINT `fk_enhanced_orders_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='增强订单表';

-- ================================
-- 监控报表模块
-- ================================

-- 用户行为轨迹表
CREATE TABLE `user_behavior_tracks` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '轨迹ID',
  `user_id` varchar(50) DEFAULT NULL COMMENT '用户ID',
  `session_id` varchar(100) NOT NULL COMMENT '会话ID',
  `timestamp` bigint(20) NOT NULL COMMENT '时间戳',
  `page` varchar(200) NOT NULL COMMENT '页面路径',
  `action` varchar(100) NOT NULL COMMENT '操作类型',
  `duration` int(11) DEFAULT 0 COMMENT '停留时长(秒)',
  `referrer` varchar(500) DEFAULT NULL COMMENT '来源页面',
  `user_agent` text COMMENT '用户代理',
  `ip` varchar(45) DEFAULT NULL COMMENT 'IP地址',
  `location` varchar(100) DEFAULT NULL COMMENT '地理位置',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_session_id` (`session_id`),
  KEY `idx_timestamp` (`timestamp`),
  KEY `idx_page` (`page`),
  KEY `idx_action` (`action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户行为轨迹表';

-- 用户会话表
CREATE TABLE `user_sessions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '会话ID',
  `session_id` varchar(100) NOT NULL COMMENT '会话标识',
  `user_id` varchar(50) DEFAULT NULL COMMENT '用户ID',
  `start_time` bigint(20) NOT NULL COMMENT '开始时间',
  `end_time` bigint(20) DEFAULT NULL COMMENT '结束时间',
  `duration` int(11) DEFAULT 0 COMMENT '会话时长(秒)',
  `page_views` int(11) DEFAULT 0 COMMENT '页面浏览数',
  `actions` int(11) DEFAULT 0 COMMENT '操作次数',
  `entry_page` varchar(200) DEFAULT NULL COMMENT '入口页面',
  `exit_page` varchar(200) DEFAULT NULL COMMENT '退出页面',
  `device` varchar(100) DEFAULT NULL COMMENT '设备类型',
  `browser` varchar(100) DEFAULT NULL COMMENT '浏览器',
  `location` varchar(100) DEFAULT NULL COMMENT '地理位置',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_session_id` (`session_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_start_time` (`start_time`),
  KEY `idx_duration` (`duration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户会话表';

-- UV/PV统计表
CREATE TABLE `uv_pv_stats` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '统计ID',
  `date` date NOT NULL COMMENT '统计日期',
  `hour` tinyint(4) DEFAULT NULL COMMENT '小时(0-23)',
  `page` varchar(200) DEFAULT NULL COMMENT '页面路径',
  `pv` int(11) DEFAULT 0 COMMENT '页面浏览量',
  `uv` int(11) DEFAULT 0 COMMENT '独立访客数',
  `new_users` int(11) DEFAULT 0 COMMENT '新用户数',
  `bounce_rate` decimal(5,2) DEFAULT 0.00 COMMENT '跳出率',
  `avg_session_duration` int(11) DEFAULT 0 COMMENT '平均会话时长(秒)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_date_hour_page` (`date`, `hour`, `page`),
  KEY `idx_date` (`date`),
  KEY `idx_page` (`page`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='UV/PV统计表';

-- 页面访问统计表
CREATE TABLE `page_stats` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '统计ID',
  `page` varchar(200) NOT NULL COMMENT '页面路径',
  `title` varchar(200) DEFAULT NULL COMMENT '页面标题',
  `pv` int(11) DEFAULT 0 COMMENT '页面浏览量',
  `uv` int(11) DEFAULT 0 COMMENT '独立访客数',
  `avg_duration` int(11) DEFAULT 0 COMMENT '平均停留时长(秒)',
  `bounce_rate` decimal(5,2) DEFAULT 0.00 COMMENT '跳出率',
  `date` date NOT NULL COMMENT '统计日期',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_page_date` (`page`, `date`),
  KEY `idx_date` (`date`),
  KEY `idx_pv` (`pv`),
  KEY `idx_uv` (`uv`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='页面访问统计表';

-- 设备统计表
CREATE TABLE `device_stats` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '统计ID',
  `device_type` varchar(50) NOT NULL COMMENT '设备类型',
  `browser` varchar(100) DEFAULT NULL COMMENT '浏览器',
  `os` varchar(100) DEFAULT NULL COMMENT '操作系统',
  `count` int(11) DEFAULT 0 COMMENT '访问次数',
  `percentage` decimal(5,2) DEFAULT 0.00 COMMENT '占比',
  `date` date NOT NULL COMMENT '统计日期',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_device_browser_os_date` (`device_type`, `browser`, `os`, `date`),
  KEY `idx_date` (`date`),
  KEY `idx_device_type` (`device_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='设备统计表';

-- 地域统计表
CREATE TABLE `region_stats` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '统计ID',
  `region` varchar(100) NOT NULL COMMENT '地区名称',
  `country` varchar(100) DEFAULT NULL COMMENT '国家',
  `province` varchar(100) DEFAULT NULL COMMENT '省份',
  `city` varchar(100) DEFAULT NULL COMMENT '城市',
  `count` int(11) DEFAULT 0 COMMENT '访问次数',
  `percentage` decimal(5,2) DEFAULT 0.00 COMMENT '占比',
  `date` date NOT NULL COMMENT '统计日期',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_region_date` (`region`, `date`),
  KEY `idx_date` (`date`),
  KEY `idx_country` (`country`),
  KEY `idx_province` (`province`),
  KEY `idx_city` (`city`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='地域统计表';

-- 系统监控数据表
CREATE TABLE `system_monitoring_data` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '监控ID',
  `timestamp` bigint(20) NOT NULL COMMENT '时间戳',
  `event_type` varchar(50) NOT NULL COMMENT '事件类型',
  `device_type` varchar(50) DEFAULT NULL COMMENT '设备类型',
  `user_id` varchar(50) DEFAULT NULL COMMENT '用户ID',
  `session_id` varchar(100) DEFAULT NULL COMMENT '会话ID',
  `page` varchar(200) DEFAULT NULL COMMENT '页面',
  `action` varchar(100) DEFAULT NULL COMMENT '操作',
  `duration` int(11) DEFAULT 0 COMMENT '持续时间',
  `error_message` text COMMENT '错误信息',
  `metadata` json COMMENT '元数据(JSON对象)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_timestamp` (`timestamp`),
  KEY `idx_event_type` (`event_type`),
  KEY `idx_device_type` (`device_type`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_session_id` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统监控数据表';

-- 系统监控统计表
CREATE TABLE `system_monitoring_statistics` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '统计ID',
  `date` date NOT NULL COMMENT '统计日期',
  `total_events` int(11) DEFAULT 0 COMMENT '总事件数',
  `error_events` int(11) DEFAULT 0 COMMENT '错误事件数',
  `warning_events` int(11) DEFAULT 0 COMMENT '警告事件数',
  `info_events` int(11) DEFAULT 0 COMMENT '信息事件数',
  `avg_response_time` decimal(10,2) DEFAULT 0.00 COMMENT '平均响应时间(ms)',
  `max_response_time` decimal(10,2) DEFAULT 0.00 COMMENT '最大响应时间(ms)',
  `uptime_percentage` decimal(5,2) DEFAULT 100.00 COMMENT '系统可用性(%)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_date` (`date`),
  KEY `idx_date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统监控统计表';

-- ================================
-- 报告模块
-- ================================

-- 行业报告表
CREATE TABLE `industry_reports` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '报告ID',
  `title` varchar(200) NOT NULL COMMENT '报告标题',
  `quarter` varchar(20) NOT NULL COMMENT '季度',
  `summary` text COMMENT '报告摘要',
  `pdf_url` varchar(500) DEFAULT NULL COMMENT 'PDF文件URL',
  `published_at` timestamp NULL DEFAULT NULL COMMENT '发布时间',
  `categories` json COMMENT '分类数据(JSON数组)',
  `regions` json COMMENT '地区数据(JSON数组)',
  `status` enum('draft','published','archived') DEFAULT 'draft' COMMENT '状态',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_quarter` (`quarter`),
  KEY `idx_status` (`status`),
  KEY `idx_published_at` (`published_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='行业报告表';

-- 天气数据表
CREATE TABLE `weather_data` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '天气ID',
  `city` varchar(100) NOT NULL COMMENT '城市名称',
  `date` date NOT NULL COMMENT '日期',
  `temperature` decimal(5,2) NOT NULL COMMENT '温度(°C)',
  `humidity` decimal(5,2) DEFAULT NULL COMMENT '湿度(%)',
  `weather_type` varchar(50) DEFAULT NULL COMMENT '天气类型',
  `heat_warning_level` enum('none','yellow','orange','red') DEFAULT 'none' COMMENT '高温预警级别',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_city_date` (`city`, `date`),
  KEY `idx_date` (`date`),
  KEY `idx_temperature` (`temperature`),
  KEY `idx_heat_warning_level` (`heat_warning_level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='天气数据表';

-- 热力图数据表
CREATE TABLE `heat_map_data` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '热力图ID',
  `city` varchar(100) NOT NULL COMMENT '城市名称',
  `longitude` decimal(10,6) NOT NULL COMMENT '经度',
  `latitude` decimal(10,6) NOT NULL COMMENT '纬度',
  `demand_level` int(11) NOT NULL COMMENT '需求级别',
  `date` date NOT NULL COMMENT '日期',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_city_date` (`city`, `date`),
  KEY `idx_date` (`date`),
  KEY `idx_demand_level` (`demand_level`),
  KEY `idx_location` (`longitude`, `latitude`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='热力图数据表';

-- ================================
-- 风控模块
-- ================================

-- 风控预警表
CREATE TABLE `risk_control_alerts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '预警ID',
  `type` enum('price-anomaly','monopoly-risk','malicious-bidding','inventory-warning') NOT NULL COMMENT '预警类型',
  `severity` enum('low','medium','high','critical') DEFAULT 'medium' COMMENT '严重程度',
  `title` varchar(200) NOT NULL COMMENT '预警标题',
  `description` text COMMENT '预警描述',
  `affected_area` json COMMENT '影响区域(JSON数组)',
  `affected_products` json COMMENT '影响产品(JSON数组)',
  `suggested_actions` json COMMENT '建议措施(JSON数组)',
  `resolved` tinyint(1) DEFAULT 0 COMMENT '是否已解决',
  `resolved_at` timestamp NULL DEFAULT NULL COMMENT '解决时间',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_type` (`type`),
  KEY `idx_severity` (`severity`),
  KEY `idx_resolved` (`resolved`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='风控预警表';

-- 系统通知表
CREATE TABLE `system_notifications` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '通知ID',
  `title` varchar(200) NOT NULL COMMENT '通知标题',
  `content` text NOT NULL COMMENT '通知内容',
  `type` enum('info','warning','error','success') DEFAULT 'info' COMMENT '通知类型',
  `target_user_ids` json COMMENT '目标用户ID列表(JSON数组)',
  `read_status` json COMMENT '阅读状态(JSON对象)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_type` (`type`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统通知表';

-- ================================
-- 系统管理模块
-- ================================

-- 操作日志表
CREATE TABLE `operation_logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `user_id` bigint(20) unsigned DEFAULT NULL COMMENT '操作用户ID',
  `username` varchar(50) DEFAULT NULL COMMENT '操作用户名',
  `module` varchar(50) NOT NULL COMMENT '模块名称',
  `action` varchar(100) NOT NULL COMMENT '操作类型',
  `description` text COMMENT '操作描述',
  `ip` varchar(45) DEFAULT NULL COMMENT 'IP地址',
  `user_agent` text COMMENT '用户代理',
  `request_data` json COMMENT '请求数据(JSON对象)',
  `response_data` json COMMENT '响应数据(JSON对象)',
  `status` enum('success','failed','error') DEFAULT 'success' COMMENT '操作状态',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_module` (`module`),
  KEY `idx_action` (`action`),
  KEY `idx_status` (`status`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作日志表';

-- 系统配置表
CREATE TABLE `system_config` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `key` varchar(100) NOT NULL COMMENT '配置键',
  `value` text COMMENT '配置值',
  `description` varchar(200) DEFAULT NULL COMMENT '配置描述',
  `type` enum('string','number','boolean','json') DEFAULT 'string' COMMENT '配置类型',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置表';

-- 设置外键检查
SET FOREIGN_KEY_CHECKS = 1;
