SELECT COUNT(*) AS count, 
	YEAR(radiology_record.test_date) AS year, 
	MONTH(radiology_record.test_date) AS month, 
	WEEKOFYEAR(radiology_record.test_date) AS week 
FROM persons, users, radiology_record, pacs_images
WHERE users.class = 'p' AND
persons.person_id = users.person_id AND
radiology_record.patient_id = persons.person_id AND
radiology_record.record_id = pacs_images.record_id AND
persons.first_name LIKE "%%" AND 
persons.last_name LIKE "%%" AND
radiology_record.test_type LIKE "%%" AND
radiology_record.test_date LIKE "%-%-%"
GROUP BY YEAR(radiology_record.test_date), MONTH(radiology_record.test_date), WEEKOFYEAR(radiology_record.test_date)
ORDER BY radiology_record.test_date;