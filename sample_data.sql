-- ============================================
-- SAMPLE DATA
-- ============================================

-- Insert Departments
INSERT INTO departments (department_name, floor_number, phone_extension) VALUES
('Cardiology', 1, '1001'),
('Neurology', 2, '1002'),
('Pediatrics', 3, '1003'),
('Orthopedics', 1, '1004'),
('Emergency', 1, '1005');

-- Insert Doctors
INSERT INTO doctors (first_name, last_name, email, phone, specialization, license_number, department_id, hire_date, salary) VALUES
('John', 'Smith', 'john.smith@hospital.com', '555-0101', 'Cardiologist', 'MED001', 1, '2020-01-15', 250000.00),
('Sarah', 'Johnson', 'sarah.johnson@hospital.com', '555-0102', 'Neurologist', 'MED002', 2, '2019-03-20', 240000.00),
('Michael', 'Brown', 'michael.brown@hospital.com', '555-0103', 'Pediatrician', 'MED003', 3, '2021-06-01', 200000.00),
('Emily', 'Davis', 'emily.davis@hospital.com', '555-0104', 'Orthopedic Surgeon', 'MED004', 4, '2018-09-10', 280000.00),
('David', 'Wilson', 'david.wilson@hospital.com', '555-0105', 'Emergency Medicine', 'MED005', 5, '2020-11-15', 260000.00);

-- Update head doctors for departments
UPDATE departments SET head_doctor_id = 1 WHERE department_id = 1;
UPDATE departments SET head_doctor_id = 2 WHERE department_id = 2;
UPDATE departments SET head_doctor_id = 3 WHERE department_id = 3;
UPDATE departments SET head_doctor_id = 4 WHERE department_id = 4;
UPDATE departments SET head_doctor_id = 5 WHERE department_id = 5;

-- Insert Patients
INSERT INTO patients (first_name, last_name, date_of_birth, gender, email, phone, address, emergency_contact_name, emergency_contact_phone, blood_type, insurance_provider, insurance_id) VALUES
('Alice', 'Williams', '1985-05-15', 'F', 'alice.w@email.com', '555-0201', '123 Main St, City', 'Bob Williams', '555-0202', 'A+', 'Blue Cross', 'BC123456'),
('Robert', 'Miller', '1990-08-20', 'M', 'robert.m@email.com', '555-0203', '456 Oak Ave, City', 'Mary Miller', '555-0204', 'O-', 'Aetna', 'AE789012'),
('Jennifer', 'Garcia', '1975-12-10', 'F', 'jennifer.g@email.com', '555-0205', '789 Pine Rd, City', 'Carlos Garcia', '555-0206', 'B+', 'United', 'UN345678'),
('James', 'Lee', '2000-03-25', 'M', 'james.l@email.com', '555-0207', '321 Elm St, City', 'Lisa Lee', '555-0208', 'AB+', 'Cigna', 'CI901234'),
('Maria', 'Lopez', '1988-07-30', 'F', 'maria.l@email.com', '555-0209', '654 Maple Dr, City', 'Jose Lopez', '555-0210', 'A-', 'Blue Cross', 'BC567890');

-- Insert Rooms
INSERT INTO rooms (room_number, room_type, floor_number, is_available, daily_rate, department_id) VALUES
('101', 'General', 1, true, 500.00, 1),
('102', 'General', 1, true, 500.00, 1),
('201', 'Private', 2, true, 1500.00, 2),
('202', 'Private', 2, true, 1500.00, 2),
('ICU1', 'ICU', 1, true, 5000.00, 5),
('ER1', 'Emergency', 1, true, 1000.00, 5),
('OR1', 'Surgery', 2, true, 3000.00, 4);

-- Insert Appointments
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status, reason) VALUES
(1, 1, '2024-01-20', '09:00', 'Completed', 'Annual heart checkup'),
(1, 1, '2024-03-15', '10:00', 'Scheduled', 'Follow-up'),
(2, 2, '2024-01-21', '11:00', 'Completed', 'Migraine consultation'),
(3, 4, '2024-01-22', '14:00', 'Cancelled', 'Flu symptoms'),
(4, 3, '2024-02-10', '09:30', 'Scheduled', 'Child wellness check'),
(5, 5, '2024-02-12', '15:00', 'Scheduled', 'Chest pain'),
(2, 1, '2024-02-15', '11:00', 'Scheduled', 'Heart palpitations'),
(3, 5, '2024-03-01', '08:00', 'Scheduled', 'Emergency follow-up');

-- Insert Medical Records
INSERT INTO medical_records (patient_id, doctor_id, appointment_id, diagnosis, symptoms, treatment_plan) VALUES
(1, 1, 1, 'Mild hypertension', 'High blood pressure, occasional headaches', 'Prescribed beta blockers, recommend low-sodium diet'),
(2, 2, 3, 'Chronic migraine', 'Severe headaches, light sensitivity', 'Prescribed sumatriptan, follow up in 2 months');

-- Insert Prescriptions
INSERT INTO prescriptions (record_id, medication_name, dosage, frequency, duration) VALUES
(1, 'Atenolol', '50mg', 'Once daily', '30 days'),
(2, 'Sumatriptan', '100mg', 'As needed', '30 days');

-- Insert Lab Tests
INSERT INTO lab_tests (patient_id, doctor_id, test_name, test_category, status, cost) VALUES
(1, 1, 'Complete Blood Count', 'Hematology', 'Completed', 150.00),
(1, 1, 'Lipid Panel', 'Chemistry', 'Completed', 200.00),
(2, 2, 'MRI Brain', 'Radiology', 'Ordered', 3000.00),
(5, 5, 'Chest X-Ray', 'Radiology', 'Ordered', 500.00),
(3, 4, 'Rapid Flu Test', 'Microbiology', 'Completed', 100.00);

-- Insert Staff
INSERT INTO staff (first_name, last_name, email, phone, position, department_id, hire_date, salary, shift) VALUES
('Patricia', 'Taylor', 'patricia.t@hospital.com', '555-0301', 'Head Nurse', 1, '2019-05-10', 80000.00, 'Morning'),
('Kevin', 'Anderson', 'kevin.a@hospital.com', '555-0302', 'Receptionist', 1, '2022-01-15', 40000.00, 'Morning'),
('Linda', 'Martinez', 'linda.m@hospital.com', '555-0303', 'Lab Technician', 5, '2020-08-20', 55000.00, 'Evening');

-- Insert Users
INSERT INTO users (username, password_hash, role, associated_id) VALUES
('admin', 'hashed_password_admin', 'Admin', NULL),
('dr.smith', 'hashed_password_smith', 'Doctor', 1),
('dr.johnson', 'hashed_password_johnson', 'Doctor', 2),
('nurse.taylor', 'hashed_password_taylor', 'Nurse', 1),
('alice.w', 'hashed_password_alice', 'Patient', 1);
