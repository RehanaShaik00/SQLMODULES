DROP TABLE IF EXISTS adverse_reactions;
DROP TABLE IF EXISTS prescriptions;
DROP TABLE IF EXISTS medications;
DROP TABLE IF EXISTS patients;

-- Patients
CREATE TABLE patients (
  patient_id INT PRIMARY KEY,
  name       VARCHAR(20) NOT NULL,
  age        INT NOT NULL,
  gender     VARCHAR(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO patients (patient_id, name, age, gender) VALUES
  (1, 'John Doe',     35, 'Male'),
  (2, 'Jane Smith',   45, 'Female'),
  (3, 'Alice Johnson',25, 'Female');

-- Medications
CREATE TABLE medications (
  medication_id   INT PRIMARY KEY,
  medication_name VARCHAR(20) NOT NULL,
  manufacturer    VARCHAR(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO medications (medication_id, medication_name, manufacturer) VALUES
  (1, 'Aspirin', 'Pfizer'),
  (2, 'Tylenol', 'Johnson & Johnson'),
  (3, 'Lipitor', 'Pfizer');

-- Prescriptions
CREATE TABLE prescriptions (
  prescription_id   INT PRIMARY KEY,
  patient_id        INT NOT NULL,
  medication_id     INT NOT NULL,
  prescription_date DATE NOT NULL,
  CONSTRAINT fk_presc_patient    FOREIGN KEY (patient_id)    REFERENCES patients(patient_id),
  CONSTRAINT fk_presc_medication FOREIGN KEY (medication_id) REFERENCES medications(medication_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO prescriptions (prescription_id, patient_id, medication_id, prescription_date) VALUES
  (1, 1, 1, '2023-01-01'),
  (2, 1, 2, '2023-02-15'),
  (3, 2, 1, '2023-03-10'),
  (4, 3, 3, '2023-04-20');

-- Adverse reactions
CREATE TABLE adverse_reactions (
  reaction_id          INT PRIMARY KEY,
  patient_id           INT NOT NULL,
  reaction_description VARCHAR(20) NOT NULL,
  reaction_date        DATE NOT NULL,
  CONSTRAINT fk_rxn_patient FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO adverse_reactions (reaction_id, patient_id, reaction_description, reaction_date) VALUES
  (1, 1, 'Nausea',    '2023-01-05'),
  (2, 2, 'Headache',  '2023-03-20'),
  (3, 3, 'Dizziness', '2023-05-01'),
  (4, 1, 'Rash',      '2023-01-20');
  
/*
In the field of pharmacovigilance, it's crucial to monitor and assess adverse reactions 
that patients may experience after taking certain medications. 
Adverse reactions, also known as side effects, can range from mild to severe and can impact the safety 
and efficacy of a medication.
For each medication, count the number of adverse reactions reported within the first 30 days 
of the prescription being issued. 
Assume that the prescription date in the Prescriptions table represents the start date of the 
medication usage, display the output in ascending order of medication name.
*/
SELECT m.medication_name,COUNT(reaction_id)
FROM medications m
JOIN prescriptions p
ON m.medication_id=p.medication_id
LEFT JOIN adverse_reactions a
ON a.patient_id=p.patient_id
AND reaction_date BETWEEN prescription_date AND DATE_FORMAT(DATE_ADD(prescription_date ,INTERVAL 30 DAY),'%Y-%m-%d')
GROUP BY m.medication_name
ORDER BY m.medication_name ASC



