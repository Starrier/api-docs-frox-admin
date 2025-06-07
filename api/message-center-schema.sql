-- 消息中心数据库建表语句
-- 支持MySQL 8.0+

-- 设置字符集
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ================================
-- 消息中心模块
-- ================================

-- 消息表
CREATE TABLE `messages` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  `title` varchar(200) NOT NULL COMMENT '消息标题',
  `content` text NOT NULL COMMENT '消息内容',
  `platform` enum('douyin','xiaohongshu','wechat','sms','email','all') NOT NULL COMMENT '推送平台',
  `template_id` bigint(20) unsigned DEFAULT NULL COMMENT '模板ID',
  `status` enum('draft','scheduled','sending','sent','failed','cancelled') DEFAULT 'draft' COMMENT '消息状态',
  `priority` enum('low','normal','high','urgent') DEFAULT 'normal' COMMENT '优先级',
  `target_audience` json NOT NULL COMMENT '目标受众(JSON对象)',
  `scheduled_time` timestamp NULL DEFAULT NULL COMMENT '定时发送时间',
  `sent_time` timestamp NULL DEFAULT NULL COMMENT '实际发送时间',
  `statistics` json COMMENT '统计数据(JSON对象)',
  `created_by` bigint(20) unsigned NOT NULL COMMENT '创建者ID',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `fk_messages_template` (`template_id`),
  KEY `fk_messages_creator` (`created_by`),
  KEY `idx_platform` (`platform`),
  KEY `idx_status` (`status`),
  KEY `idx_priority` (`priority`),
  KEY `idx_scheduled_time` (`scheduled_time`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `fk_messages_template` FOREIGN KEY (`template_id`) REFERENCES `message_templates` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_messages_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='消息表';

-- 消息模板表
CREATE TABLE `message_templates` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '模板ID',
  `name` varchar(100) NOT NULL COMMENT '模板名称',
  `description` text COMMENT '模板描述',
  `platform` enum('douyin','xiaohongshu','wechat','sms','email','all') NOT NULL COMMENT '适用平台',
  `category` enum('marketing','notification','alert','system') DEFAULT 'notification' COMMENT '模板分类',
  `content` text NOT NULL COMMENT '模板内容',
  `variables` json COMMENT '变量定义(JSON数组)',
  `status` enum('active','inactive','draft') DEFAULT 'draft' COMMENT '模板状态',
  `usage_count` int(11) DEFAULT 0 COMMENT '使用次数',
  `created_by` bigint(20) unsigned NOT NULL COMMENT '创建者ID',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `fk_message_templates_creator` (`created_by`),
  KEY `idx_platform` (`platform`),
  KEY `idx_category` (`category`),
  KEY `idx_status` (`status`),
  KEY `idx_usage_count` (`usage_count`),
  CONSTRAINT `fk_message_templates_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='消息模板表';

-- 推送策略表
CREATE TABLE `push_strategies` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '策略ID',
  `name` varchar(100) NOT NULL COMMENT '策略名称',
  `description` text COMMENT '策略描述',
  `platform` enum('douyin','xiaohongshu','wechat','sms','email','all') NOT NULL COMMENT '适用平台',
  `rules` json NOT NULL COMMENT '推送规则(JSON数组)',
  `frequency` json NOT NULL COMMENT '推送频率配置(JSON对象)',
  `retry_policy` json COMMENT '重试策略(JSON对象)',
  `status` enum('active','inactive') DEFAULT 'active' COMMENT '策略状态',
  `created_by` bigint(20) unsigned NOT NULL COMMENT '创建者ID',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `fk_push_strategies_creator` (`created_by`),
  KEY `idx_platform` (`platform`),
  KEY `idx_status` (`status`),
  CONSTRAINT `fk_push_strategies_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='推送策略表';

-- 消息发送记录表
CREATE TABLE `message_send_records` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `message_id` bigint(20) unsigned NOT NULL COMMENT '消息ID',
  `user_id` bigint(20) unsigned NOT NULL COMMENT '接收用户ID',
  `platform` enum('douyin','xiaohongshu','wechat','sms','email') NOT NULL COMMENT '发送平台',
  `status` enum('pending','sent','delivered','read','clicked','failed') DEFAULT 'pending' COMMENT '发送状态',
  `sent_time` timestamp NULL DEFAULT NULL COMMENT '发送时间',
  `delivered_time` timestamp NULL DEFAULT NULL COMMENT '送达时间',
  `read_time` timestamp NULL DEFAULT NULL COMMENT '阅读时间',
  `clicked_time` timestamp NULL DEFAULT NULL COMMENT '点击时间',
  `error_message` text COMMENT '错误信息',
  `retry_count` int(11) DEFAULT 0 COMMENT '重试次数',
  `external_id` varchar(100) DEFAULT NULL COMMENT '外部平台消息ID',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `fk_message_send_records_message` (`message_id`),
  KEY `fk_message_send_records_user` (`user_id`),
  KEY `idx_platform` (`platform`),
  KEY `idx_status` (`status`),
  KEY `idx_sent_time` (`sent_time`),
  KEY `idx_external_id` (`external_id`),
  CONSTRAINT `fk_message_send_records_message` FOREIGN KEY (`message_id`) REFERENCES `messages` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_message_send_records_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='消息发送记录表';

-- 用户推送偏好表
CREATE TABLE `user_push_preferences` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '偏好ID',
  `user_id` bigint(20) unsigned NOT NULL COMMENT '用户ID',
  `platforms` json NOT NULL COMMENT '平台偏好(JSON对象)',
  `categories` json NOT NULL COMMENT '分类偏好(JSON对象)',
  `quiet_hours` json COMMENT '免打扰时间(JSON对象)',
  `frequency` json COMMENT '频率设置(JSON对象)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_id` (`user_id`),
  CONSTRAINT `fk_user_push_preferences_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户推送偏好表';

-- 消息统计表
CREATE TABLE `message_statistics` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '统计ID',
  `date` date NOT NULL COMMENT '统计日期',
  `platform` enum('douyin','xiaohongshu','wechat','sms','email','all') NOT NULL COMMENT '平台',
  `total_messages` int(11) DEFAULT 0 COMMENT '总消息数',
  `total_sent` int(11) DEFAULT 0 COMMENT '总发送数',
  `total_delivered` int(11) DEFAULT 0 COMMENT '总送达数',
  `total_read` int(11) DEFAULT 0 COMMENT '总阅读数',
  `total_clicked` int(11) DEFAULT 0 COMMENT '总点击数',
  `total_failed` int(11) DEFAULT 0 COMMENT '总失败数',
  `delivery_rate` decimal(5,2) DEFAULT 0.00 COMMENT '送达率',
  `read_rate` decimal(5,2) DEFAULT 0.00 COMMENT '阅读率',
  `click_rate` decimal(5,2) DEFAULT 0.00 COMMENT '点击率',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_date_platform` (`date`, `platform`),
  KEY `idx_date` (`date`),
  KEY `idx_platform` (`platform`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='消息统计表';

-- 平台配置表
CREATE TABLE `platform_configs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `platform` enum('douyin','xiaohongshu','wechat','sms','email') NOT NULL COMMENT '平台名称',
  `config_key` varchar(100) NOT NULL COMMENT '配置键',
  `config_value` text COMMENT '配置值',
  `description` varchar(200) DEFAULT NULL COMMENT '配置描述',
  `is_encrypted` tinyint(1) DEFAULT 0 COMMENT '是否加密',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_platform_key` (`platform`, `config_key`),
  KEY `idx_platform` (`platform`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='平台配置表';

-- 消息队列表
CREATE TABLE `message_queue` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '队列ID',
  `message_id` bigint(20) unsigned NOT NULL COMMENT '消息ID',
  `user_id` bigint(20) unsigned NOT NULL COMMENT '用户ID',
  `platform` enum('douyin','xiaohongshu','wechat','sms','email') NOT NULL COMMENT '发送平台',
  `priority` enum('low','normal','high','urgent') DEFAULT 'normal' COMMENT '优先级',
  `scheduled_time` timestamp NOT NULL COMMENT '计划发送时间',
  `status` enum('pending','processing','completed','failed','cancelled') DEFAULT 'pending' COMMENT '队列状态',
  `retry_count` int(11) DEFAULT 0 COMMENT '重试次数',
  `max_retries` int(11) DEFAULT 3 COMMENT '最大重试次数',
  `error_message` text COMMENT '错误信息',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `fk_message_queue_message` (`message_id`),
  KEY `fk_message_queue_user` (`user_id`),
  KEY `idx_platform` (`platform`),
  KEY `idx_priority` (`priority`),
  KEY `idx_scheduled_time` (`scheduled_time`),
  KEY `idx_status` (`status`),
  CONSTRAINT `fk_message_queue_message` FOREIGN KEY (`message_id`) REFERENCES `messages` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_message_queue_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='消息队列表';

-- 消息内容审核表
CREATE TABLE `message_content_audit` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '审核ID',
  `message_id` bigint(20) unsigned NOT NULL COMMENT '消息ID',
  `content` text NOT NULL COMMENT '审核内容',
  `audit_status` enum('pending','approved','rejected','reviewing') DEFAULT 'pending' COMMENT '审核状态',
  `audit_result` json COMMENT '审核结果(JSON对象)',
  `auditor_id` bigint(20) unsigned DEFAULT NULL COMMENT '审核员ID',
  `audit_time` timestamp NULL DEFAULT NULL COMMENT '审核时间',
  `reject_reason` text COMMENT '拒绝原因',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `fk_message_content_audit_message` (`message_id`),
  KEY `fk_message_content_audit_auditor` (`auditor_id`),
  KEY `idx_audit_status` (`audit_status`),
  KEY `idx_audit_time` (`audit_time`),
  CONSTRAINT `fk_message_content_audit_message` FOREIGN KEY (`message_id`) REFERENCES `messages` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_message_content_audit_auditor` FOREIGN KEY (`auditor_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='消息内容审核表';

-- 设置外键检查
SET FOREIGN_KEY_CHECKS = 1;
