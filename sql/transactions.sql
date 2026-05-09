-- ============================================
-- TRANSACTIONS DEMONSTRATION
-- ============================================

-- Transaction 1: Book an appointment with conflict checking
CREATE OR REPLACE FUNCTION book_appointment(
    p_patient_id INTEGER,
    p_doctor_id INTEGER,
    p_appointment_date DATE,
    p_appointment_time TIME,
    p_reason TEXT
) RETURNS TEXT AS $$
DECLARE
    v_conflict_count INTEGER;
    v_appointment_id INTEGER;
BEGIN
    -- Check for time slot conflicts
    SELECT COUNT(*) INTO v_conflict_count
    FROM appointments
    WHERE doctor_id = p_doctor_id
        AND appointment_date = p_appointment_date
        AND appointment_time = p_appointment_time
        AND status != 'Cancelled';
    
    IF v_conflict_count > 0 THEN
        RETURN 'ERROR: Time slot is already booked!';
    END IF;
    
    -- Check if doctor is active
    IF NOT EXISTS (SELECT 1 FROM doctors WHERE doctor_id = p_doctor_id AND is_active = true) THEN
        RETURN 'ERROR: Doctor is not available!';
    END IF;
    
    -- Insert the appointment
    INSERT INTO appointments (
        patient_id, doctor_id, appointment_date, 
        appointment_time, status, reason
    ) VALUES (
        p_patient_id, p_doctor_id, p_appointment_date,
        p_appointment_time, 'Scheduled', p_reason
    ) RETURNING appointment_id INTO v_appointment_id;
    
    RETURN 'SUCCESS: Appointment booked! ID = ' || v_appointment_id;
END;
$$ LANGUAGE plpgsql;


-- Transaction 2: Admit a patient
CREATE OR REPLACE FUNCTION admit_patient(
    p_patient_id INTEGER,
    p_room_id INTEGER,
    p_doctor_id INTEGER,
    p_reason TEXT
) RETURNS TEXT AS $$
DECLARE
    v_admission_id INTEGER;
BEGIN
    -- Check if room is available
    IF NOT EXISTS (SELECT 1 FROM rooms WHERE room_id = p_room_id AND is_available = true) THEN
        RETURN 'ERROR: Room is not available!';
    END IF;
    
    -- Create admission record
    INSERT INTO admissions (
        patient_id, room_id, doctor_id, 
        admission_reason, status
    ) VALUES (
        p_patient_id, p_room_id, p_doctor_id,
        p_reason, 'Active'
    ) RETURNING admission_id INTO v_admission_id;
    
    -- Mark room as unavailable
    UPDATE rooms SET is_available = false WHERE room_id = p_room_id;
    
    -- Create initial bill
    INSERT INTO bills (patient_id, admission_id, due_date, payment_status)
    VALUES (p_patient_id, v_admission_id, CURRENT_DATE + INTERVAL '30 days', 'Unpaid');
    
    RETURN 'SUCCESS: Patient admitted! Admission ID = ' || v_admission_id;
END;
$$ LANGUAGE plpgsql;


-- Transaction 3: Discharge patient and calculate bill
CREATE OR REPLACE FUNCTION discharge_patient(
    p_admission_id INTEGER,
    p_days_stayed INTEGER
) RETURNS TEXT AS $$
DECLARE
    v_room_id INTEGER;
    v_daily_rate DECIMAL;
    v_total DECIMAL;
    v_bill_id INTEGER;
BEGIN
    -- Check if admission exists and is active
    IF NOT EXISTS (SELECT 1 FROM admissions WHERE admission_id = p_admission_id AND status = 'Active') THEN
        RETURN 'ERROR: No active admission found!';
    END IF;
    
    -- Get room info
    SELECT room_id INTO v_room_id FROM admissions WHERE admission_id = p_admission_id;
    SELECT daily_rate INTO v_daily_rate FROM rooms WHERE room_id = v_room_id;
    
    v_total := v_daily_rate * p_days_stayed;
    
    -- Update admission
    UPDATE admissions 
    SET discharge_date = CURRENT_TIMESTAMP, 
        status = 'Discharged',
        discharge_summary = 'Patient discharged after ' || p_days_stayed || ' days.'
    WHERE admission_id = p_admission_id;
    
    -- Free the room
    UPDATE rooms SET is_available = true WHERE room_id = v_room_id;
    
    -- Update bill
    SELECT bill_id INTO v_bill_id FROM bills WHERE admission_id = p_admission_id;
    
    INSERT INTO bill_items (bill_id, description, amount, item_type)
    VALUES (v_bill_id, 'Room charge for ' || p_days_stayed || ' days', v_total, 'Room');
    
    UPDATE bills 
    SET total_amount = (SELECT COALESCE(SUM(amount), 0) FROM bill_items WHERE bill_id = v_bill_id),
        balance = (SELECT COALESCE(SUM(amount), 0) FROM bill_items WHERE bill_id = v_bill_id)
    WHERE bill_id = v_bill_id;
    
    RETURN 'SUCCESS: Patient discharged! Total charge: $' || v_total;
END;
$$ LANGUAGE plpgsql;


-- ============================================
-- TEST THE TRANSACTIONS
-- ============================================

-- Test 1: Book a new appointment
SELECT book_appointment(3, 1, '2024-04-10', '14:00', 'Chest pain follow-up');

-- Test 2: Try to double-book (should fail)
SELECT book_appointment(5, 1, '2024-04-10', '14:00', 'Regular checkup');

-- Test 3: Admit a patient
SELECT admit_patient(4, 1, 5, 'Severe dehydration');

-- Test 4: Discharge the patient
SELECT discharge_patient(1, 3);

-- Test 5: Check updated records
SELECT * FROM appointments WHERE appointment_date = '2024-04-10';
SELECT * FROM rooms WHERE room_id = 1;
SELECT * FROM bills;

