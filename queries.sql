-- ============================================
-- BASIC QUERIES
-- ============================================

-- 1. Show all patients with blood type A+
SELECT first_name, last_name, blood_type, phone 
FROM patients 
WHERE blood_type = 'A+';

-- 2. All appointments with patient and doctor names
SELECT 
    p.first_name || ' ' || p.last_name AS patient_name,
    d.first_name || ' ' || d.last_name AS doctor_name,
    a.appointment_date,
    a.appointment_time,
    a.status
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
ORDER BY a.appointment_date;

-- 3. Count appointments by status
SELECT status, COUNT(*) AS total
FROM appointments
GROUP BY status;

-- 4. Find doctors and their departments
SELECT d.first_name, d.last_name, dep.department_name
FROM doctors d
JOIN departments dep ON d.department_id = dep.department_id;

-- 5. Patients who have had appointments
SELECT DISTINCT p.first_name, p.last_name
FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id;

-- ============================================
-- ADVANCED QUERIES
-- ============================================

-- 6. Patient visit ranking (Window Function)
SELECT 
    p.first_name || ' ' || p.last_name AS patient_name,
    a.appointment_date,
    a.status,
    ROW_NUMBER() OVER (PARTITION BY p.patient_id ORDER BY a.appointment_date) AS visit_number
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
ORDER BY p.patient_id, a.appointment_date;

-- 7. Department workload (CTE - Common Table Expression)
WITH dept_stats AS (
    SELECT 
        dep.department_name,
        COUNT(a.appointment_id) AS total_appointments,
        COUNT(DISTINCT a.patient_id) AS unique_patients
    FROM departments dep
    JOIN doctors d ON dep.department_id = d.department_id
    LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
    GROUP BY dep.department_name
)
SELECT *, 
    RANK() OVER (ORDER BY total_appointments DESC) AS workload_rank
FROM dept_stats;

-- 8. Monthly appointment breakdown (Pivot-style query)
SELECT 
    d.first_name || ' ' || d.last_name AS doctor_name,
    COUNT(CASE WHEN EXTRACT(MONTH FROM a.appointment_date) = 1 THEN 1 END) AS January,
    COUNT(CASE WHEN EXTRACT(MONTH FROM a.appointment_date) = 2 THEN 1 END) AS February,
    COUNT(CASE WHEN EXTRACT(MONTH FROM a.appointment_date) = 3 THEN 1 END) AS March,
    COUNT(*) AS Total
FROM doctors d
LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
    AND a.appointment_date BETWEEN '2024-01-01' AND '2024-03-31'
GROUP BY d.doctor_id, d.first_name, d.last_name
ORDER BY Total DESC;
