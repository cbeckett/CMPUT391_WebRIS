SELECT first_name, last_name, address, phone, test_date, diagnosis  
FROM persons, users, radiology_record 
WHERE users.class = 'p' AND  
	persons.person_id = users.person_id AND  
	radiology_record.patient_id = persons.person_id AND
	radiology_record.diagnosis LIKE "%diagnosis%" AND 
	(radiology_record.test_date BETWEEN "startDate" AND "endDate");