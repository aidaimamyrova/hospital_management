-- ============================================
-- HOSPITAL MANAGEMENT SYSTEM - SCHEMA
-- ============================================

DROP TABLE IF EXISTS audit_logs CASCADE;
DROP TABLE IF EXISTS bill_items CASCADE;
DROP TABLE IF EXISTS bills CASCADE;
DROP TABLE IF EXISTS lab_tests CASCADE;
DROP TABLE IF EXISTS prescriptions CASCADE;
DROP TABLE IF EXISTS medical_records CASCADE;
DROP TABLE IF EXISTS admissions CASCADE;
DROP TABLE IF EXISTS appointments CASCADE;
DROP TABLE IF EXISTS staff CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS rooms CASCADE;
DROP TABLE IF EXISTS doctors CASCADE;
DROP TABLE IF EXISTS patients CASCADE;
DROP TABLE IF EXISTS departments CASCADE;

CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    floor_number INTEGER,
    phone_extension VARCHAR(15),
    head_doctor_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    specialization VARCHAR(100),
    license_number VARCHAR(50) UNIQUE NOT NULL,
    department_id INTEGER REFERENCES departments(department_id),
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE departments 
ADD CONSTRAINT fk_head_doctor 
FOREIGN KEY (head_doctor_id) REFERENCES doctors(doctor_id);

CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F', 'O')),
    email VARCHAR(100),
    phone VARCHAR(20) NOT NULL,
    address TEXT,
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(20),
    blood_type VARCHAR(3),
    insurance_provider VARCHAR(100),
    insurance_id VARCHAR(50),
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE appointments (
    appointment_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id) NOT NULL,
    doctor_id INTEGER REFERENCES doctors(doctor_id) NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status VARCHAR(20) CHECK (status IN ('Scheduled', 'Completed', 'Cancelled', 'No Show')),
    reason TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_appointment UNIQUE (doctor_id, appointment_date, appointment_time)
);

CREATE TABLE medical_records (
    record_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id) NOT NULL,
    doctor_id INTEGER REFERENCES doctors(doctor_id) NOT NULL,
    appointment_id INTEGER REFERENCES appointments(appointment_id),
    diagnosis TEXT,
    symptoms TEXT,
    treatment_plan TEXT,
    notes TEXT,
    record_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE prescriptions (
    prescription_id SERIAL PRIMARY KEY,
    record_id INTEGER REFERENCES medical_records(record_id) NOT NULL,
    medication_name VARCHAR(200) NOT NULL,
    dosage VARCHAR(100),
    frequency VARCHAR(100),
    duration VARCHAR(100),
    notes TEXT,
    prescribed_date DATE DEFAULT CURRENT_DATE,
    is_active BOOLEAN DEFAULT true
);

CREATE TABLE rooms (
    room_id SERIAL PRIMARY KEY,
    room_number VARCHAR(10) UNIQUE NOT NULL,
    room_type VARCHAR(20) CHECK (room_type IN ('General', 'Private', 'ICU', 'Emergency', 'Surgery')),
    floor_number INTEGER,
    is_available BOOLEAN DEFAULT true,
    daily_rate DECIMAL(10,2),
    department_id INTEGER REFERENCES departments(department_id)
);

CREATE TABLE admissions (
    admission_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id) NOT NULL,
    room_id INTEGER REFERENCES rooms(room_id) NOT NULL,
    doctor_id INTEGER REFERENCES doctors(doctor_id) NOT NULL,
    admission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    discharge_date TIMESTAMP,
    admission_reason TEXT,
    discharge_summary TEXT,
    status VARCHAR(20) CHECK (status IN ('Active', 'Discharged', 'Transferred'))
);

CREATE TABLE bills (
    bill_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id) NOT NULL,
    admission_id INTEGER REFERENCES admissions(admission_id),
    bill_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(12,2),
    paid_amount DECIMAL(12,2) DEFAULT 0,
    balance DECIMAL(12,2),
    due_date DATE,
    payment_status VARCHAR(20) DEFAULT 'Unpaid',
    CONSTRAINT check_payment_status CHECK (payment_status IN ('Paid', 'Partial', 'Unpaid', 'Overdue'))
);

CREATE TABLE bill_items (
    item_id SERIAL PRIMARY KEY,
    bill_id INTEGER REFERENCES bills(bill_id) NOT NULL,
    description VARCHAR(255),
    amount DECIMAL(10,2),
    item_type VARCHAR(50) CHECK (item_type IN ('Consultation', 'Medicine', 'Room', 'Procedure', 'Lab Test', 'Other'))
);

CREATE TABLE lab_tests (
    test_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id) NOT NULL,
    doctor_id INTEGER REFERENCES doctors(doctor_id) NOT NULL,
    test_name VARCHAR(200) NOT NULL,
    test_category VARCHAR(100),
    ordered_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_date TIMESTAMP,
    results TEXT,
    is_abnormal BOOLEAN DEFAULT false,
    cost DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'Ordered',
    CONSTRAINT check_test_status CHECK (status IN ('Ordered', 'In Progress', 'Completed', 'Cancelled'))
);

CREATE TABLE staff (
    staff_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    position VARCHAR(100),
    department_id INTEGER REFERENCES departments(department_id),
    hire_date DATE,
    salary DECIMAL(10,2),
    shift VARCHAR(20) CHECK (shift IN ('Morning', 'Evening', 'Night')),
    is_active BOOLEAN DEFAULT true
);

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) CHECK (role IN ('Admin', 'Doctor', 'Nurse', 'Receptionist', 'Patient')),
    associated_id INTEGER,
    is_active BOOLEAN DEFAULT true,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE audit_logs (
    log_id SERIAL PRIMARY KEY,
    table_name VARCHAR(50),
    record_id INTEGER,
    action VARCHAR(10),
    old_data JSONB,
    new_data JSONB,
    changed_by INTEGER REFERENCES users(user_id),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

