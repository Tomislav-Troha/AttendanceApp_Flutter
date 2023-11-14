-- Initial script to populate the UserContractType table

INSERT INTO "ContractType"("contractTypeName", "description")
VALUES
('Basic Membership', 'Provides access to the swimming facility during standard hours.'),
('Premium Membership', 'Access to swimming, spa, and sauna facilities. Includes one free swimming lesson per month.'),
('Family Membership', 'Allows access for a family of up to 4. Swimming + childrens area access.'),
('Student Membership', 'Special discounted rate for students. Provides standard swimming facility access.'),
('Senior Membership', 'Special rates for seniors. Provides standard swimming facility access along with spa.'),
('Short-term Membership', 'Suitable for tourists or visitors. Lasts for a week or a month.'),
('Full-time Contract', 'Permanent employment with benefits and standard working hours.'),
('Part-time Contract', 'Employment for a limited number of hours per week.'),
('Seasonal Contract', 'Temporary employment during peak seasons or specific months.'),
('Freelance Contract', 'On a per-task or per-project basis. Suitable for trainers who come for special workshops.'),
('Probationary Contract', 'An initial period (like 3 or 6 months) to evaluate the performance of a new employee.'),
('Internship Contract', 'Short-term employment for trainees or interns, often with a focus on training and learning.')
;
