CREATE TABLE electricity_bill (
    bill_id         INT PRIMARY KEY,
    household_id    INT,
    billing_period  VARCHAR(7),          -- 'YYYY-MM'
    consumption_kwh DECIMAL(10,2),
    total_cost      DECIMAL(10,2)
);

-- =========================
-- Household 101 - Year 2023
-- =========================
INSERT INTO electricity_bill (bill_id, household_id, billing_period, consumption_kwh, total_cost) VALUES
(1, 101, '2023-01', 410.00, 73.80),
(2, 101, '2023-02', 390.00, 70.20),
(3, 101, '2023-03', 405.00, 72.90),
(4, 101, '2023-04', 420.00, 75.60),
(5, 101, '2023-05', 450.00, 81.00),
(6, 101, '2023-06', 470.00, 84.60),
(7, 101, '2023-07', 520.00, 93.60),
(8, 101, '2023-08', 510.00, 91.80),
(9, 101, '2023-09', 480.00, 86.40),
(10, 101, '2023-10', 460.00, 82.80),
(11, 101, '2023-11', 430.00, 77.40),
(12, 101, '2023-12', 415.00, 74.70);

-- =========================
-- Household 101 - Year 2024
-- =========================
INSERT INTO electricity_bill (bill_id, household_id, billing_period, consumption_kwh, total_cost) VALUES
(13, 101, '2024-01', 400.00, 72.00),
(14, 101, '2024-02', 380.00, 68.40),
(15, 101, '2024-03', 395.00, 71.10),
(16, 101, '2024-04', 410.00, 73.80),
(17, 101, '2024-05', 440.00, 79.20),
(18, 101, '2024-06', 460.00, 82.80),
(19, 101, '2024-07', 500.00, 90.00),
(20, 101, '2024-08', 495.00, 89.10),
(21, 101, '2024-09', 470.00, 84.60),
(22, 101, '2024-10', 450.00, 81.00),
(23, 101, '2024-11', 425.00, 76.50),
(24, 101, '2024-12', 405.00, 72.90);

-- =========================
-- Household 102 - Year 2023
-- =========================
INSERT INTO electricity_bill (bill_id, household_id, billing_period, consumption_kwh, total_cost) VALUES
(25, 102, '2023-01', 300.00, 54.00),
(26, 102, '2023-02', 280.00, 50.40),
(27, 102, '2023-03', 290.00, 52.20),
(28, 102, '2023-04', 310.00, 55.80),
(29, 102, '2023-05', 330.00, 59.40),
(30, 102, '2023-06', 360.00, 64.80),
(31, 102, '2023-07', 380.00, 68.40),
(32, 102, '2023-08', 370.00, 66.60),
(33, 102, '2023-09', 340.00, 61.20),
(34, 102, '2023-10', 320.00, 57.60),
(35, 102, '2023-11', 310.00, 55.80),
(36, 102, '2023-12', 305.00, 54.90);

-- =========================
-- Household 102 - Year 2024
-- =========================
INSERT INTO electricity_bill (bill_id, household_id, billing_period, consumption_kwh, total_cost) VALUES
(37, 102, '2024-01', 295.00, 53.10),
(38, 102, '2024-02', 275.00, 49.50),
(39, 102, '2024-03', 285.00, 51.30),
(40, 102, '2024-04', 300.00, 54.00),
(41, 102, '2024-05', 320.00, 57.60),
(42, 102, '2024-06', 340.00, 61.20),
(43, 102, '2024-07', 360.00, 64.80),
(44, 102, '2024-08', 355.00, 63.90),
(45, 102, '2024-09', 335.00, 60.30),
(46, 102, '2024-10', 315.00, 56.70),
(47, 102, '2024-11', 305.00, 54.90),
(48, 102, '2024-12', 290.00, 52.20);

-- =========================
-- Household 103 - Year 2023
-- =========================
INSERT INTO electricity_bill (bill_id, household_id, billing_period, consumption_kwh, total_cost) VALUES
(49, 103, '2023-01', 520.00, 93.60),
(50, 103, '2023-02', 500.00, 90.00),
(51, 103, '2023-03', 480.00, 86.40),
(52, 103, '2023-04', 460.00, 82.80),
(53, 103, '2023-05', 440.00, 79.20),
(54, 103, '2023-06', 420.00, 75.60),
(55, 103, '2023-07', 410.00, 73.80),
(56, 103, '2023-08', 400.00, 72.00),
(57, 103, '2023-09', 390.00, 70.20),
(58, 103, '2023-10', 380.00, 68.40),
(59, 103, '2023-11', 370.00, 66.60),
(60, 103, '2023-12', 360.00, 64.80);

-- =========================
-- Household 103 - Year 2024
-- =========================
INSERT INTO electricity_bill (bill_id, household_id, billing_period, consumption_kwh, total_cost) VALUES
(61, 103, '2024-01', 530.00, 95.40),
(62, 103, '2024-02', 510.00, 91.80),
(63, 103, '2024-03', 490.00, 88.20),
(64, 103, '2024-04', 470.00, 84.60),
(65, 103, '2024-05', 450.00, 81.00),
(66, 103, '2024-06', 430.00, 77.40),
(67, 103, '2024-07', 420.00, 75.60),
(68, 103, '2024-08', 410.00, 73.80),
(69, 103, '2024-09', 400.00, 72.00),
(70, 103, '2024-10', 390.00, 70.20),
(71, 103, '2024-11', 380.00, 68.40),
(72, 103, '2024-12', 370.00, 66.60);

/*
You have access to data from an electricity billing system,
detailing the electricity usage and cost for specific households over billing periods in the years 2023
and 2024. Your objective is to present the total electricity consumption, total cost and average monthly
 consumption for each household per year display the output in ascending order of each household id &
 year of the bill.*/
 
 SELECT household_id,SUM(consumption_kwh),SUM(total_cost),AVG(consumption_kwh),LEFT(billing_period,4)
 FROM electricity_bill
 WHERE LEFT(billing_period,4) = 2023 OR LEFT(billing_period,4) = 2024
 GROUP BY household_id,LEFT(billing_period,4)
 ORDER BY household_id ASC,LEFT(billing_period,4) ASC;
