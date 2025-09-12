-- 1) DDL
DROP TABLE IF EXISTS conversation;
CREATE TABLE conversation (
  senderDeviceType  VARCHAR(20),
  customerId        INT,
  orderId           VARCHAR(10),
  resolution        VARCHAR(10),   -- 'true' / 'false'
  agentId           INT NULL,      -- NULL for customer messages
  messageSentTime   DATETIME,
  cityCode          VARCHAR(6)
);

-- 2) Sample data
-- Order O1001 (single agent, resolved)
INSERT INTO conversation VALUES
('web',    1001, 'O1001', 'false', NULL,   '2025-08-01 09:01:00', 'HYD001'), -- customer starts
('web',    1001, 'O1001', 'false', 101,    '2025-08-01 09:03:00', 'HYD001'),
('mobile', 1001, 'O1001', 'true',  101,    '2025-08-01 09:10:00', 'HYD001'),
('mobile', 1001, 'O1001', 'false', NULL,   '2025-08-01 09:12:00', 'HYD001');

-- Order O1002 (two agents -> reassigned, not resolved)
INSERT INTO conversation VALUES
('web',    1002, 'O1002', 'false', 201,    '2025-08-02 10:00:00', 'DAL123'), -- agent starts
('web',    1002, 'O1002', 'false', NULL,   '2025-08-02 10:02:00', 'DAL123'),
('mobile', 1002, 'O1002', 'false', 202,    '2025-08-02 10:10:00', 'DAL123'),
('mobile', 1002, 'O1002', 'false', NULL,   '2025-08-02 10:12:00', 'DAL123');

-- Order O1003 (single agent, resolved later; multiple customer msgs)
INSERT INTO conversation VALUES
('mobile', 1003, 'O1003', 'false', NULL,   '2025-08-03 08:30:00', 'AUS321'), -- customer starts
('mobile', 1003, 'O1003', 'false', NULL,   '2025-08-03 08:31:30', 'AUS321'),
('web',    1003, 'O1003', 'false', 301,    '2025-08-03 08:35:00', 'AUS321'),
('web',    1003, 'O1003', 'true',  301,    '2025-08-03 08:50:00', 'AUS321');

-- 3) Result query
WITH per_order AS (
  SELECT
    orderId,
    MIN(cityCode)                                       AS city_code,               -- unique per order by assumption
    MIN(CASE WHEN agentId IS NOT NULL THEN messageSentTime END)  AS first_agent_message,
    MIN(CASE WHEN agentId IS NULL     THEN messageSentTime END)  AS first_customer_message,
    SUM(agentId IS NOT NULL)                             AS num_messages_agent,
    SUM(agentId IS NULL)                                 AS num_messages_customer,
    MIN(messageSentTime)                                 AS first_any_msg_time,
    MAX(resolution = 'true')                              AS resolved_flag,          -- 1 if any 'true'
    COUNT(DISTINCT CASE WHEN agentId IS NOT NULL THEN agentId END) AS distinct_agents
  FROM conversation
  GROUP BY orderId
)
SELECT
  orderId AS order_id,
  city_code,
  first_agent_message,
  first_customer_message,
  num_messages_agent,
  num_messages_customer,
  CASE
    WHEN first_any_msg_time = first_agent_message    THEN 'agent'
    ELSE 'customer'
  END                                               AS first_message_by,
  CASE WHEN resolved_flag > 0 THEN 1 ELSE 0 END     AS resolved,
  CASE WHEN distinct_agents > 1 THEN 1 ELSE 0 END   AS reassigned
FROM per_order
ORDER BY order_id;
