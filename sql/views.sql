-- ============================================
-- VIEWS FOR BUSINESS INTELLIGENCE
-- ============================================

-- View 1: Patient Summary
CREATE OR REPLACE VIEW patient_summary AS
SELECT 
    p.patient_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, p.date_of_birth)) AS age,
    p.blood_type,
    p.insurance_provider,
    COUNT(DISTINCT a.appointment_id) AS total_appointments,
    COUNT(DISTINCT ad.admission_id) AS total_admissions
FROM patients p
LEFT JOIN appointments a ON p.patient_id = a.patient_id
LEFT JOIN admissions ad ON p.patient_id = ad.patient_id
GROUP BY p.patient_id;

-- View 2: Doctor Performance
CREATE OR REPLACE VIEW doctor_performance AS
SELECT 
    d.doctor_id,
    d.first_name || ' ' || d.last_name AS doctor_name,
    d.specialization,
    dep.department_name,
    COUNT(DISTINCT a.appointment_id) AS total_appointments,
    COUNT(DISTINCT a.patient_id) AS unique_patients,
    ROUND(AVG(CASE WHEN a.status = 'Completed' THEN 1 ELSE 0 END) * 100, 1) AS completion_rate_pct
FROM doctors d
JOIN departments dep ON d.department_id = dep.department_id
LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, dep.department_name;

-- View 3: Appointment Status Summary
CREATE OR REPLACE VIEW appointment_summary AS
SELECT 
    a.appointment_date,
    d.first_name || ' ' || d.last_name AS doctor_name,
    p.first_name || ' ' || p.last_name AS patient_name,
    a.appointment_time,
    a.status,
    a.reason
FROM appointments a
JOIN doctors d ON a.doctor_id = d.doctor_id
JOIN patients p ON a.patient_id = p.patient_id
ORDER BY a.appointment_date DESC;

-- View 4: Current Admissions
CREATE OR REPLACE VIEW current_admissions AS
SELECT 
    ad.admission_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    r.room_number,
    r.room_type,
    d.first_name || ' ' || d.last_name AS doctor_name,
    ad.admission_date,
    ad.admission_reason,
    ad.status
FROM admissions ad
JOIN patients p ON ad.patient_id = p.patient_id
JOIN rooms r ON ad.room_id = r.room_id
JOIN doctors d ON ad.doctor_id = d.doctor_id
WHERE ad.status = 'Active';

-- View 5: Billing Summary
CREATE OR REPLACE VIEW billing_summary AS
SELECT 
    b.bill_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    b.bill_date,
    b.total_amount,
    b.paid_amount,
    b.balance,
    b.payment_status,
    b.due_date
FROM bills b
JOIN patients p ON b.patient_id = p.patient_id;

-- View 6: Lab Test Status
CREATE OR REPLACE VIEW lab_test_summary AS
SELECT 
    lt.test_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    lt.test_name,
    lt.test_category,
    lt.status,
    lt.ordered_date,
    lt.completed_date,
    lt.cost
FROM lab_tests lt
JOIN patients p ON lt.patient_id = p.patient_id
ORDER BY lt.ordered_date DESC;
