--01. Records’ Count
select count(*) from WizzardDeposits as [Count]
go

--02. Longest Magic Wand
SELECT MAX(MagicWandSize)as  [LongestMagicWand] FROM WizzardDeposits 
GO

--03. Longest Magic Wand per Deposit Groups
SELECT w.DepositGroup, MAX(w.MagicWandSize)as  [LongestMagicWand] FROM WizzardDeposits as w
group by w.DepositGroup
go

--04. Smallest Deposit Group per Magic Wand Size (not
SELECT top 2 w.DepositGroup  FROM WizzardDeposits as w
group by w.DepositGroup
order by AVG(w.MagicWandSize)
go

--05. Deposits Sum
SELECT w.DepositGroup, sum(w.DepositAmount)as [TotalSum] 
FROM WizzardDeposits AS w
group by w.DepositGroup
go

--06. Deposits Sum for Ollivander Family
SELECT w.DepositGroup, sum(w.DepositAmount)as [TotalSum] 
FROM WizzardDeposits AS w
group by w.DepositGroup, w.MagicWandCreator
HAVING w.MagicWandCreator='Ollivander family'
GO

--07. Deposits Filter
SELECT w.DepositGroup, sum(w.DepositAmount)as [TotalSum] 
FROM WizzardDeposits AS w
group by w.DepositGroup, w.MagicWandCreator --w.DepositAmount
HAVING w.MagicWandCreator='Ollivander family'
and sum(w.DepositAmount)<150000
order by TotalSum desc
GO

--08. Deposit Charge
SELECT w.DepositGroup
, w.MagicWandCreator
, MIN(w.DepositCharge) as MinDepositCharge
FROM WizzardDeposits AS w
group by w.DepositGroup, w.MagicWandCreator
GO

--09. Age Groups

select AgeGroup, count(AgeGroup)as WizardCount from(
SELECT Age,
	case 
	when Age between 0 and 10 then '[0-10]'
	when Age between 11 and 20 then '[11-20]'
	when Age between 21 and 30 then '[21-30]'
	when Age between 31 and 40 then '[31-40]'
	when Age between 41 and 50 then '[41-50]'
	when Age between 51 and 60 then '[51-60]'
	when Age >60 then '[61+]'
		else 'A'
	end as AgeGroup
FROM WizzardDeposits
) as ageSubQuery
group by AgeGroup
go

--10. First Letter

select * from(
select SUBSTRING (firstName, 1, 1) as FirstLetter
from WizzardDeposits 
where DepositGroup= 'Troll Chest') as fls
group by fls.FirstLetter

go

--11. Average Interest

select subQ.DepositGroup,subQ.IsDepositExpired, avg(subQ.DepositInterest) from(
select * from WizzardDeposits
where DepositStartDate > '01/01/1985') as subQ
group  by subQ.DepositGroup, subQ.IsDepositExpired
order by subQ.DepositGroup DESC, IsDepositExpired

go

--12. Rich Wizard, Poor Wizard 
select SUM(wz2.DepositAmount-wz1.DepositAmount)as [SumDifference] from WizzardDeposits as wz1
join WizzardDeposits as wz2 ON wz1.Id= wz2.Id +1
go

--13. Departments Total Salaries
SELECT
	DepartmentID,
	--COUNT(*) AS EmployeesIn,
	SUM(Salary) as [TotalSalary]
FROM Employees GROUP BY DepartmentID
	ORDER BY DepartmentID
go

--14. Employees Minimum Salaries
 select sube.DepartmentID,min(subE.Salary)as [MinimumSalary]  from(
select * from Employees as e
where e.DepartmentID in (2,5,7) and
e.HireDate > '01/01/2000') as subE
group by subE.DepartmentID

go

--15. Employees Average Salaries
SELECT * INTO [EmployeesAS] FROM Employees
WHERE [Salary] > 30000
 
DELETE FROM EmployeesAS
WHERE [ManagerID] = 42
 
UPDATE EmployeesAS
SET [Salary] += 5000
WHERE [DepartmentID] = 1
 
SELECT [DepartmentID],
    AVG([Salary]) as [AverageSalary]
FROM EmployeesAS
GROUP BY [DepartmentID]
go

--16. Employees Maximum Salaries
select * from(
select DepartmentID, max(Salary)as maxSalary from Employees
group by DepartmentID) as subM
where subM.maxSalary <30000 or
subM.maxSalary>70000
go

--17. Employees Count Salaries
select count(*)as [Count] from(
select * from Employees
where ManagerID is null)as n







