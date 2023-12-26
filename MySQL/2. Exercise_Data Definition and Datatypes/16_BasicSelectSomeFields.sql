USE soft_uni;

SELECT name FROM towns AS t ORDER BY t.name;
SELECT name FROM departments AS d ORDER BY d.name;
SELECT first_name, last_name, job_title, salary FROM employees AS e ORDER BY e.salary DESC;