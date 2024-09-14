USE project_fincorp_lending;

# Q1- Write basic SQL queries to select data from the loans table, 
#such as selecting all columns for all records, and specific columns like loan amount and type.

SELECT * FROM loans;
SELECT loan_id, loan_type, loan_amount, interest_rate, term_months FROM loans;
SELECT customer_id, employment_status, annual_income, credit_score FROM loans WHERE region="West";
SELECT customer_id, employment_status, annual_income, credit_score FROM loans WHERE (loan_amount="West" AND loan_type="Education");

# Q2- Apply SQL commands to sort loans by issue date and filter loans by criteria such as loan type (e.g., Personal, Home)
SELECT loan_id, issue_date FROM loans ORDER BY issue_date ASC;
SELECT loan_id as "Top five loans", issue_date, loan_amount FROM loans WHERE (loan_type=("personal" AND "home")) ORDER BY issue_date ASC LIMIT 5;

# Q3- Use SQL to calculate aggregates like the total number of loans, average loan amount, and the maximum and minimum loan amounts.
SELECT COUNT(loan_id) as "Total number of loans" FROM loans;
SELECT AVG(loan_amount) FROM loans WHERE loan_amount> (1,00,000);
SELECT AVG(loan_amount), loan_type FROM loans GROUP BY loan_type;
SELECT AVG(loan_amount), loan_type FROM loans GROUP BY loan_type HAVING loan_type="Education";
SELECT loan_id, loan_amount FROM loans ORDER BY loan_amount DESC;
SELECT loan_id, loan_amount FROM loans ORDER BY loan_amount ASC;

# Q4- Perform basic joins, for example, joining the loans table with a customers table 
# (assuming such a table exists or is created for this task) on the customer ID to retrieve combined information.
# Retrive all important loan and customer information attributes for all customers.

#loans- loan_id, loan_amount, loan_type
#customers- customer_name, customer_address, loan_application_date
#common table= customer_id

SELECT c.customer_id, l.loan_id, l.loan_amount, l.loan_type, c.customer_name, c.customer_address, c.loan_application_date
FROM loans as l LEFT JOIN  customers as c 
ON l.customer_id=c.customer_id 
ORDER BY c. customer_id ASC;

# Q5- Create SQL views to simplify access to frequently needed queries, such as a view for all active loans.

CREATE VIEW customer_info AS 
SELECT customer_id, loan_amount, interest_rate, region, loan_type 
FROM loans;

CREATE VIEW customer_financial_position_info AS 
SELECT customer_id, payment_status, employment_status, annual_income, credit_score, 
no_of_dependents, previous_loan_amount, previous_loan_status, housing_status
FROM loans WHERE(region=("west" AND "east"));

# Q6-  

# A. Find the average loan amount, and average interest rate for each type of loan
SELECT AVG(loan_amount, interest_rate), loan_type FROM loans GROUP BY loan_type;

# B. Identify customers with loans in more than one category
SELECT COUNT(customer_id), loan_type FROM loans 
WHERE (SELECT customer_id, loan_type FROM loans WHERE COUNT(DISTINCT(l.customer_id)>1))
GROUP BY loan_type;

SELECT customer_id
FROM loans
GROUP BY customer_id
HAVING COUNT(DISTINCT loan_type) > 1;

# Q7-
# Group data by various attributes such as loan type or region, and use the HAVING clause to filter groups based on aggregate conditions, 
# like regions with average loan amounts above a certain threshold.

SELECT AVG(loan_amount) AS "avg_loan_amount", loan_type, region FROM loans 
GROUP BY loan_type, region HAVING (AVG(loan_amount)< 50,000);

# Question 8- 
# Implement CASE statements in SQL to perform conditional logic, 
# such as categorizing loan risk based on interest rates or repayment terms.

#Creation of new column based on single condition-[credit_score]
SELECT credit_score, 
	CASE WHEN credit_score>700 THEN "Good" 
		 WHEN credit_score>650 THEN "Acceptable" 
		 WHEN credit_score<=650 THEN "Bad" 
		 ELSE "Worst" 
	END AS "crdit_score_categories"
FROM loans;

#Creation of new column based on multiple conditions-[employment_status, previous_loan_status]
SELECT customer_id, loan_id, employment_status, previous_loan_status, 
	CASE WHEN employment_status = "employed" AND previous_loan_status = "paid_off" THEN "low_risk"
		 WHEN employment_status = "self_employed" AND previous_loan_status = "none" THEN "mid_risk"
         WHEN employment_status = "unemployed" AND previous_loan_status = "delaulted" THEN "high_risk"
		 ELSE "further_risk_assessment_required" 
	END AS "loan_risk_status"
FROM loans;