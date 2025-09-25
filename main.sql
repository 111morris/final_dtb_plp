-- hospital_management_system
-- Hospital (Clinic) Management System - Complete Database Schema
-- This SQL file creates a relational database for managing hospital/clinic operations.
-- Includes core tables, constraints, relationships, sample data, and example queries.

-- Clean setup: Drop database if exists 
DROP DATABASE IF EXISTS HospitalDB;

-- Create the database
CREATE DATABASE HospitalDB;
USE HospitalDB;

-- Drop tables in reverse dependency order for clean recreation
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Prescriptions;
DROP TABLE IF EXISTS MedicalRecords;
DROP TABLE IF EXISTS Appointments;
DROP TABLE IF EXISTS DoctorServices;
DROP TABLE IF EXISTS Services;
DROP TABLE IF EXISTS Doctors;
DROP TABLE IF EXISTS Patients;
DROP TABLE IF EXISTS Clinics;
DROP TABLE IF EXISTS Rooms;
DROP TABLE IF EXISTS Departments;

-- 1. Departments Table: Medical specialties
CREATE TABLE Departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- 2. Clinics Table: Different clinic locations 
CREATE TABLE Clinics (
    clinic_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(200) NOT NULL
);

-- 3. Patients Table: Patient registration and personal info
CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    gender ENUM('M', 'F', 'Other'),
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    address TEXT,
    registration_date DATE DEFAULT CURRENT_DATE
);

-- 4. Doctors Table: Doctor profiles linked to departments
CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialization VARCHAR(100),
    dept_id INT NOT NULL,
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    hire_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id) ON DELETE RESTRICT
);

-- 5. Services Table: Medical services offered (e.g., lab tests, consultations)
CREATE TABLE Services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL
);

-- 6. DoctorServices Junction Table: Many-to-Many relationship between Doctors and Services
CREATE TABLE DoctorServices (
    doctor_id INT NOT NULL,
    service_id INT NOT NULL,
    PRIMARY KEY (doctor_id, service_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES Services(service_id) ON DELETE CASCADE
);

-- 7. Rooms Table: Bonus - Hospital rooms for appointments (linked to departments)
CREATE TABLE Rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(20) NOT NULL UNIQUE,
    dept_id INT,
    capacity INT DEFAULT 1,
    availability BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id) ON DELETE SET NULL
);

-- 8. Appointments Table: Scheduled meetings between patients and doctors
CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    clinic_id INT,
    room_id INT,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    notes TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE RESTRICT,
    FOREIGN KEY (clinic_id) REFERENCES Clinics(clinic_id) ON DELETE SET NULL,
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id) ON DELETE SET NULL,
    UNIQUE KEY unique_appointment (doctor_id, appointment_date, appointment_time)
);

-- 9. Prescriptions Table: One-to-One with Appointments
CREATE TABLE Prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL UNIQUE,
    medication VARCHAR(200) NOT NULL,
    dosage VARCHAR(100),
    frequency VARCHAR(100),
    instructions TEXT,
    prescribed_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE CASCADE
);

-- 10. MedicalRecords Table: Patient health history 
CREATE TABLE MedicalRecords (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    appointment_id INT,
    diagnosis TEXT,
    notes TEXT,
    record_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE SET NULL
);

-- 11. Payments Table: One-to-Many with Appointments (multiple payments per appointment possible)
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date DATE DEFAULT CURRENT_DATE,
    payment_method ENUM('Cash', 'Card', 'Insurance', 'Online') DEFAULT 'Cash',
    status ENUM('Pending', 'Paid', 'Refunded') DEFAULT 'Pending',
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE CASCADE
);

-- Indexes for performance 
CREATE INDEX idx_appointments_date ON Appointments(appointment_date);
CREATE INDEX idx_patients_email ON Patients(email);
CREATE INDEX idx_doctors_dept ON Doctors(dept_id);

-- ===============================
-- Sample Data Insertion
-- ==========================

-- Insert Departments
INSERT INTO Departments (name, description) VALUES
('Cardiology', 'Heart and cardiovascular diseases'),
('Pediatrics', 'Child healthcare'),
('Orthopedics', 'Bone and joint treatments');

-- Insert Clinics
INSERT INTO Clinics (name, location) VALUES
('Main Clinic', '123 Health St, City A'),
('Branch Clinic', '456 Wellness Ave, City B');

-- Insert Services
INSERT INTO Services (name, description, price) VALUES
('Consultation', 'General doctor consultation', 50.00),
('ECG Test', 'Electrocardiogram test', 100.00),
('Blood Test', 'Basic blood analysis', 75.00);

-- Insert Patients
INSERT INTO Patients (first_name, last_name, date_of_birth, gender, phone, email, address) VALUES
('John', 'Voke', '1980-05-15', 'M', '123-456-7890', 'jontefresh.voke@email.com', '789 Oak Ave'),
('Jane', 'Smith', '1990-08-22', 'F', '098-765-4321', 'jane.smith@email.com', '101 Pine St');

-- Insert Doctors
INSERT INTO Doctors (first_name, last_name, specialization, dept_id, phone, email) VALUES
('Dr. Alice', 'Johnson', 'Cardiologist', 1, '111-222-3333', 'alice.j@email.com'),
('Dr. Bob', 'Lee', 'Pediatrician', 2, '444-555-6666', 'bob.l@email.com');

-- Insert DoctorServices (many-to-many)
INSERT INTO DoctorServices (doctor_id, service_id) VALUES
(1, 1), (1, 2),  -- Dr. Johnson offers Consultation and ECG
(2, 1), (2, 3);  -- Dr. Lee offers Consultation and Blood Test

-- Insert Rooms (bonus)
INSERT INTO Rooms (room_number, dept_id, capacity) VALUES
('Room 101', 1, 1),
('Room 202', 2, 2);

-- Insert Appointments
INSERT INTO Appointments (patient_id, doctor_id, clinic_id, room_id, appointment_date, appointment_time, status) VALUES
(1, 1, 1, 1, '2023-10-15', '10:00:00', 'Scheduled'),
(2, 2, 2, 2, '2023-10-16', '14:30:00', 'Completed');

-- Insert Prescriptions (one per appointment)
INSERT INTO Prescriptions (appointment_id, medication, dosage, frequency, instructions) VALUES
(1, 'Aspirin', '100mg', 'Daily', 'Take after meals'),
(2, 'Antibiotic', '500mg', 'Twice daily', 'Complete full course');

-- Insert MedicalRecords
INSERT INTO MedicalRecords (patient_id, appointment_id, diagnosis, notes) VALUES
(1, 1, 'Hypertension', 'Patient reports chest pain'),
(2, 2, 'Fever', 'Child has mild symptoms');

-- Insert Payments (multiple possible per appointment)
INSERT INTO Payments (appointment_id, amount, payment_method, status) VALUES
(1, 50.00, 'Card', 'Paid'),
(2, 75.00, 'Cash', 'Paid');

-- ==================
-- Example Queries
-- ===============================

-- 1. List upcoming appointments with patient and doctor names
SELECT 
    a.appointment_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    a.appointment_date,
    a.appointment_time,
    a.status
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
WHERE a.appointment_date >= CURDATE() AND a.status = 'Scheduled'
ORDER BY a.appointment_date, a.appointment_time;

-- 2. Get all patients assigned to a specific doctor (e.g., doctor_id = 1)
SELECT 
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    COUNT(a.appointment_id) AS total_appointments
FROM Doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
JOIN Patients p ON a.patient_id = p.patient_id
WHERE d.doctor_id = 1
GROUP BY d.doctor_id, patient_name;

-- 3. Find prescriptions for a specific patient (e.g., patient_id = 1)
SELECT 
    pr.prescription_id,
    pr.medication,
    pr.dosage,
    a.appointment_date
FROM Prescriptions pr
JOIN Appointments a ON pr.appointment_id = a.appointment_id
JOIN Patients p ON a.patient_id = p.patient_id
WHERE p.patient_id = 1;

-- 4. Total payments received per doctor
SELECT 
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    SUM(pm.amount) AS total_payments,
    COUNT(pm.payment_id) AS payment_count
FROM Doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
JOIN Payments pm ON a.appointment_id = pm.appointment_id
WHERE pm.status = 'Paid'
GROUP BY d.doctor_id
ORDER BY total_payments DESC;

-- 5. Count of appointments per department
SELECT 
    dept.name AS department,
    COUNT(a.appointment_id) AS appointment_count
FROM Departments dept
JOIN Doctors d ON dept.dept_id = d.dept_id
JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY dept.dept_id
ORDER BY appointment_count DESC;

-- 6. Services offered by a doctor (e.g., doctor_id = 1)
SELECT 
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    s.name AS service_name,
    s.price
FROM Doctors d
JOIN DoctorServices ds ON d.doctor_id = ds.doctor_id
JOIN Services s ON ds.service_id = s.service_id
WHERE d.doctor_id = 1;

