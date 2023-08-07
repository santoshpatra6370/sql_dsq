

CREATE DATABASE TENANT;
GO


-----Write a query to get Profile ID, Full Name and Contact Number of the tenant who has stayed 
---with us for the longest time period in the past   ....?


---  1

SELECT 
    P.first_name,
    P.last_name,
    P.phone,
    TH.profile_id
FROM 
    Profiles P
JOIN 
    Tenancy_histories TH ON P.profile_id = TH.profile_id;


-------Write a query to get the Full name, email id, phone of tenants who are married and paying 
------rent > 9000 using subqueries  ....?


-----  2
SELECT 
    P.first_name,
    P.last_name,
    P.phone,
    P.email_id,
    P.marital_status,
    TH.rent
FROM 
    Profiles P
JOIN 
    Tenancy_histories TH ON P.profile_id = TH.profile_id
WHERE
    TH.rent > 9000;


------  Write a query to display profile id, full name, phone, email id, city , house id, move_in_date , 
------  move_out date, rent, total number of referrals made, latest employer and the occupational 
------  category of all the tenants living in Bangalore or Pune in the time period of jan 2015 to jan 
-----   2016 sorted by their rent in descending order  ....?



	---------  3

select Profiles.profile_id, first_name + ' ' + last_name as FullName,email_id, phone,city,house_id,move_in_date,move_out_date,rent,latest_employer,occupational_category,
sum(Referrals.referral_valid) as totalreferralmade
from Profiles
inner join Tenancy_histories
on Profiles.profile_id = Tenancy_histories.profile_id
inner join Employment_details
on Profiles.profile_id = Employment_details.profile_id
inner join Referrals
on Profiles.profile_id = Referrals.profile_id
where (city = 'Bangalore' or city ='Pune') and ( move_in_date>= '01 Jan 2015' and move_in_date<= '01 Jan 2016'
and move_out_date>= '01 Jan 2015' and move_out_date<= '01 Jan 2016')
group by Profiles.profile_id,first_name,last_name, email_id,phone,city,house_id,move_in_date,move_out_date,rent,latest_employer,occupational_category




--------     Write a sql snippet to find the full_name, email_id, phone number and referral code of all 
--------     the tenants who have referred more than once. 
--------     Also find the total bonus amount they should receive given that the bonus gets calculated 
--------     only for valid referrals      ......?






--------    4

	SELECT
    p.first_name,
    p.last_name,
    p.email_id,
    p.phone,
    p.referral_code,
    COUNT(r.referral_valid) AS total_referrals,
    SUM(CASE WHEN r.referral_valid = 1 THEN r.referrer_bonus_amount ELSE 0 END) AS total_bonus_amount
FROM
    Profiles p
INNER JOIN
    referrals r ON p.profile_id = r.profile_id
GROUP BY
    p.first_name,
    p.last_name,
    p.email_id,
    p.phone,
    p.referral_code
HAVING
    COUNT(r.referral_valid) > 1;





----------    Write a query to find the rent generated from each city and also the total of all cities       .....?

	
------5
	Select Distinct
	  p.city,
	  SUM (TH.rent)
	  AS total_rent
	  from 
	  Profiles p
	  Join
	  Tenancy_histories TH ON p.profile_id = TH.profile_id
	  group by  p.city 





--------    Create a view 'vw_tenant' find 
--------    profile_id,rent,move_in_date,house_type,beds_vacant,description and city of tenants who 
--------    shifted on/after 30th april 2015 and are living in houses having vacant beds and its address     ....?


-------  6

CREATE VIEW vw_tenant AS
SELECT
    th.profile_id,
    th.rent,
    th.move_in_date,
    h.house_type,
    h.beds_vacant,
    a.description,
    a.city
FROM
    Tenancy_histories th
JOIN
    Houses h ON th.house_id = h.house_id
JOIN
    Addresses a ON h.house_id = a.house_id
WHERE
    th.move_in_date >= '2015-04-30'
    AND h.beds_vacant > 0;


	
	select * from vw_tenant






	
-------       Write a code to extend the valid_till date for a month of tenants who have referred more 
-------       than two times    ...?



------7

SELECT [profile_id], COUNT([profile_id]) AS referral_count
FROM referrals
GROUP BY [profile_id]
HAVING COUNT([profile_id]) > 2;


SELECT DATEADD(MM, 1, valid_till) 
FROM   referrals
WHERE  profile_id IN (SELECT   profile_id
                       FROM     referrals
                       GROUP BY profile_id
                       HAVING   COUNT(*) > 2)

UPDATE referrals 
SET    valid_till = DATEADD(MM, 1, valid_till) 
WHERE  profile_id IN (SELECT   profile_id
                       FROM     referrals
                       GROUP BY profile_id
                       HAVING   COUNT(*) > 2)

select * from referrals



--------      Write a query to get Profile ID, Full Name , Contact Number of the tenants along with a new 
--------      column 'Customer Segment' wherein if the tenant pays rent greater than 10000, tenant falls 
--------      in Grade A segment, if rent is between 7500 to 10000, tenant falls in Grade B else in Grade C       ....?




------  8


SELECT
    P.profile_id,
    P.first_name,
    P.last_name,
    P.phone,
    CASE
        WHEN TH.rent > 10000 THEN 'Grade A'
        WHEN TH.rent BETWEEN 7500 AND 10000 THEN 'Grade B'
        ELSE 'Grade C'
    END AS 'Customer Segment'
FROM
    Profiles P
JOIN
    Tenancy_histories TH ON P.profile_id = TH.profile_id;

	
--------      Write a query to get Fullname, Contact, City and House Details of the tenants who have not 
--------      referred even once         .....?



-----  9
SELECT
    p.first_name,
    p.last_name,
    p.phone,
    p.city,
    h.house_type,
    h.bhk_type,
    h.bed_count,
    h.furnishing_type,
    h.beds_vacant,
    h.house_id
  
FROM
    Profiles p
INNER JOIN
    houses h ON p.profile_id = h.house_id
INNER JOIN
    referrals r ON p.profile_id = r.profile_id
WHERE
    r.referral_valid <> 0;







 --------       Write a query to get the house details of the house having highest occupancy       ......?



 ---  10
	SELECT
    h.house_type,
    h.bhk_type,
    h.bed_count,
    h.furnishing_type,
    h.beds_vacant,
    h.house_id,
    e.occupational_category
FROM
    Houses h
JOIN
    Employment_details e ON h.house_id = e.profile_id
WHERE
    e.occupational_category = 'working';