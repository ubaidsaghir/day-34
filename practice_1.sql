CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(50),
    city VARCHAR(50)
);


CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(50),
    specialization VARCHAR(50)
);

CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    fee INT,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);


CREATE TABLE treatments (
    treatment_id INT PRIMARY KEY,
    appointment_id INT,
    treatment_name VARCHAR(50),
    cost INT,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);


INSERT INTO patients VALUES
(1,'Ali','Karachi'),
(2,'Sara','Lahore'),
(3,'Ahmed','Karachi'),
(4,'Fatima','Islamabad');


INSERT INTO doctors VALUES
(1,'Dr. Khan','Cardiology'),
(2,'Dr. Ahmed','Dermatology'),
(3,'Dr. Sara','Neurology');


INSERT INTO appointments VALUES
(1,1,1,'2024-01-01',500),
(2,2,2,'2024-01-02',400),
(3,3,1,'2024-01-03',600),
(4,4,3,'2024-01-04',700),
(5,1,2,'2024-02-01',450),
(6,2,1,'2024-02-02',550);


INSERT INTO treatments VALUES
(1,1,'ECG',300),
(2,2,'Skin Test',200),
(3,3,'Echo',400),
(4,4,'MRI',800),
(5,5,'Allergy Test',250),
(6,6,'Heart Checkup',350);






-- TASK 1:
-- HIGH REVENUE DOCTORS

WITH doctor_revenue AS(
SELECT d.doctor_name,
SUM(a.fee + t.cost) AS total_revenue
FROM doctors d
JOIN appointments a
ON d.doctor_id = a.doctor_id
JOIN treatments t 
ON a.appointment_id = t.appointment_id
GROUP BY d.doctor_name
)
SELECT *
FROM doctor_revenue
WHERE total_revenue > 1000;


-- TASK 2:
-- Average Treatment Cost Per Doctor

WITH doctor_treatment AS (
SELECT 
d.doctor_name,
t.cost
FROM doctors d
JOIN appointments a ON d.doctor_id = a.doctor_id
JOIN treatments t ON a.appointment_id = t.appointment_id
)
SELECT 
doctor_name,
ROUND(AVG(cost),2) AS avg_cost
FROM doctor_treatment
GROUP BY doctor_name;

-- TASK 3:
-- Top Doctors per Specialization

WITH revenue AS (
SELECT 
d.doctor_name,
d.specialization,
SUM(a.fee + t.cost) AS total
FROM doctors d
JOIN appointments a ON d.doctor_id = a.doctor_id
JOIN treatments t ON a.appointment_id = t.appointment_id
GROUP BY d.doctor_name, d.specialization
)
SELECT *
FROM (
    SELECT *,
    RANK() OVER(PARTITION BY specialization ORDER BY total DESC) AS rank
    FROM revenue
) t
WHERE rank = 1;

-- TASK 4:
-- Monthly Revenue

WITH monthly AS (
SELECT 
DATE_TRUNC('month', appointment_date) AS month,
SUM(fee) AS total
FROM appointments
GROUP BY month
)
SELECT *
FROM monthly;


-- TASk 5:
-- Above Average Patients

WITH patient_total AS (
SELECT 
p.patient_name,
SUM(a.fee) AS total
FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id
GROUP BY p.patient_name
)
SELECT *
FROM patient_total
WHERE total > (SELECT AVG(total) FROM patient_total);
