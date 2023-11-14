-- Initial script to populate the SalaryPackageType table

INSERT INTO "SalaryPackageType"("packageName", "description")
VALUES
('Basic Package', 'Standard salary package with base benefits.'),
('Premium Package', 'Higher salary with extended health and dental benefits.'),
('Executive Package', 'Top-tier salary with full benefits, stock options, and bonus potential.'),
('Part-time Package', 'Adjusted salary for part-time positions.'),
('Freelance Package', 'Pay-per-project or hourly rate, no standard benefits.'),
('Intern Package', 'Stipend or base salary, possibly with limited benefits.'),
('Probationary Package', 'Initial package for new hires, subject to change after probation period.'),
('Seasonal Package', 'Adjusted salary for seasonal positions, may not include standard benefits.');

