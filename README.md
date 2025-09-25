# Clinic Booking System Database

## Overview

This project contains the SQL schema and sample data for a Clinic Booking System. It models the core entities and relationships needed to manage patients, doctors, appointments, clinics, services, payments, prescriptions, and medical records.

---

## Database Schema

The database consists of the following tables:

- **Departments**: Medical specialties.
- **Clinics**: Clinic locations.
- **Patients**: Patient information.
- **Doctors**: Doctor details linked to departments.
- **Services**: Medical services offered.
- **Staff**: Clinic staff members.
- **Appointments**: Bookings between patients and doctors.
- **Payments**: Payment records for appointments.
- **Prescriptions**: Medication prescribed during appointments.
- **MedicalRecords**: Patient health records.

---

## Setup Instructions

1. **Create the database and tables**

   Run the `main.sql` file (provided) in your MySQL environment to create the database schema:

   ```bash
   mysql -u your_username -p < clinic_booking_system.sql

2. **Insert sample data**

    Execute the `main.sql` file to populate the database with example data 

    ```bash
    mysql -u your_username -p ClinicBookingSystem < sample_data.sql


## Example Queries
   Here are some useful queries to test and explore the database:
- **List upcoming appointments with patient and doctor names.
- **Get patients assigned to a specific doctor.
- **Total payments received per clinic.
- **Find prescriptions for a patient.
- **Count appointments per doctor.
 (Refer to the `main.sql file` for full query details.)


## Requirements

- **MySQL 5.7+ or compatible SQL database server.
- **MySQL Workbench or any SQL client to run the scripts.


## Contact

For any questions or feedback, please reach out to me at [mulandimorris1@gmail.com]
