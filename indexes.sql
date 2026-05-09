-- ============================================
-- INDEXES FOR PERFORMANCE OPTIMIZATION
-- ============================================

-- Patient search indexes
CREATE INDEX idx_patients_name ON patients(last_name, first_name);
CREATE INDEX idx_patients_phone ON patients(phone);

-- Appointment indexes
CREATE INDEX idx_appointments_date ON appointments(appointment_date);
CREATE INDEX idx_appointments_doctor ON appointments(doctor_id, appointment_date);
CREATE INDEX idx_appointments_patient ON appointments(patient_id);
CREATE INDEX idx_appointments_status ON appointments(status);

-- Doctor indexes
CREATE INDEX idx_doctors_specialization ON doctors(specialization);
CREATE INDEX idx_doctors_department ON doctors(department_id);

-- Medical records indexes
CREATE INDEX idx_medical_records_patient ON medical_records(patient_id);
CREATE INDEX idx_medical_records_date ON medical_records(record_date);

-- Prescription indexes
CREATE INDEX idx_prescriptions_active ON prescriptions(is_active);

-- Admission indexes
CREATE INDEX idx_admissions_patient ON admissions(patient_id);
CREATE INDEX idx_admissions_status ON admissions(status);

-- Billing indexes
CREATE INDEX idx_bills_patient ON bills(patient_id);
CREATE INDEX idx_bills_status ON bills(payment_status);
CREATE INDEX idx_bills_due_date ON bills(due_date);

-- Lab test indexes
CREATE INDEX idx_lab_tests_patient ON lab_tests(patient_id);
CREATE INDEX idx_lab_tests_status ON lab_tests(status);
