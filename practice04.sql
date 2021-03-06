-- 서브쿼리(SUBQUERY) SQL 문제입니다.

-- 문제1.
-- 현재 평균 연봉보다 많은 월급을 받는 직원은 몇 명이나 있습니까? o 
select 
count(*) as "현재 평균연봉보다 많은 월급을 받는 직원 수"
 from salaries 
 where salary > 
 (select avg(salary) from salaries where now() between from_date and to_date)
                        and now() between from_date and to_date;

-- 문제2. 
-- 현재, 각 부서별로 최고의 급여를 받는 사원의 사번, 이름, 부서 연봉을 조회하세요. 
-- 단 조회결과는 연봉의 내림차순으로 정렬되어 나타나야 합니다.  o

SELECT 
    d.dept_name as "부서",
    e.emp_no as "사번",
    CONCAT(e.last_name, ' ', e.first_name) AS '이름',
    s.salary as "사원연봉"
FROM
    employees e
        INNER JOIN
    salaries s ON e.emp_no = s.emp_no
        INNER JOIN
    dept_emp de ON de.emp_no = e.emp_no
        INNER JOIN
    departments d ON d.dept_no = de.dept_no
WHERE
    (d.dept_no , s.salary) IN (SELECT 
            departments.dept_no, MAX(salaries.salary)
        FROM
            employees
                INNER JOIN
            salaries ON employees.emp_no = salaries.emp_no
                INNER JOIN
            dept_emp ON employees.emp_no = dept_emp.emp_no
                INNER JOIN
            departments ON departments.dept_no = dept_emp.dept_no
        WHERE
            salaries.to_date = '9999-01-01'
        GROUP BY departments.dept_no)
        AND s.to_date = '9999-01-01'
ORDER BY s.salary DESC;


-- 문제3. --
-- 현재, 자신의 부서 평균 급여보다 연봉(salary)이 많은 사원의 사번, 이름과 연봉을 조회하세요 

-- 특정 부서(d001)의 평균연봉 select 
select a.avg_salary from
(select 
de.dept_no as departmentno,
avg(s.salary) as avg_salary
from employees e, salaries s, dept_emp de
		where e.emp_no = s.emp_no 
			and e.emp_no = de.emp_no
            and s.to_date = '9999-01-01'
            and de.to_date = '9999-01-01'
group by de.dept_no) a
where a.departmentno = 'd001';

-- 3번문제 답???
select 
e.emp_no as "사번",
 CONCAT(e.last_name, ' ', e.first_name) AS '이름',
s.salary as "연봉"
 from employees e, salaries s,dept_emp d
			where e.emp_no = s.emp_no
				and e.emp_no = d.emp_no
                and s.to_date = '9999-01-01'
                and d.to_date = '9999-01-01'
                and s.salary > (
					select a.avg_salary from
						(select 
							de.dept_no as departmentno,
							avg(s.salary) as avg_salary
								from employees e, salaries s, dept_emp de
									where e.emp_no = s.emp_no 
										and e.emp_no = de.emp_no
										and s.to_date = '9999-01-01'
										and de.to_date = '9999-01-01'
											group by de.dept_no) a
												where a.departmentno = d.dept_no
                
				);







-- 문제4.
-- 현재, 사원들의 사번, 이름, 매니저 이름, 부서 이름으로 출력해 보세요. o

select 
e.emp_no as "사번",
 CONCAT(e.last_name, ' ', e.first_name) AS '이름',
(
select first_name from employees e, dept_manager dm
			where e.emp_no = dm.emp_no
				and dm.to_date = '9999-01-01'
                and dm.dept_no = d.dept_no
) as "매니저 이름",
d.dept_name as "부서명"
 from employees e, dept_emp de,departments d
		where e.emp_no = de.emp_no 
			and de.dept_no = d.dept_no
            and de.to_date = '9999-01-01';


-- 문제5.
-- 현재, 평균연봉이 가장 높은 부서의 사원들의 사번, 이름, 직책, 연봉을 조회하고 연봉 순으로 출력하세요. o 

select 
distinct e.emp_no as "사번",
CONCAT(e.last_name, ' ', e.first_name) AS '이름',
t.title  as "직책",
s.salary  as "연봉"
 from employees e inner join salaries s 
				on e.emp_no = s.emp_no inner join titles t 
					on t.emp_no = e.emp_no inner join dept_emp de 
						on de.emp_no = e.emp_no inner join departments d
							on d.dept_no = de.dept_no
                            where d.dept_no = 
(
select d.dept_no from employees e inner join salaries s
				on e.emp_no = s.emp_no inner join dept_emp de
					on de.emp_no = e.emp_no inner join departments d
						on d.dept_no = de.dept_no
                        where s.to_date = '9999-01-01'
group by d.dept_no order by avg(salary) desc limit 1
)
and s.to_date = '9999-01-01' order by s.salary desc
;


-- 1등 부서 번호
select d.dept_no, avg(salary) from employees e inner join salaries s
				on e.emp_no = s.emp_no inner join dept_emp de
					on de.emp_no = e.emp_no inner join departments d
						on d.dept_no = de.dept_no
                        where s.to_date = '9999-01-01'
group by d.dept_no order by avg(salary) desc limit 1;




-- 문제6. --
-- 평균 연봉이 가장 높은 부서는?  o 
SELECT 
    d.dept_no, d.dept_name, AVG(s.salary)
FROM
    employees e
        INNER JOIN
    salaries s ON e.emp_no = s.emp_no
        INNER JOIN
    dept_emp de ON de.emp_no = e.emp_no
        INNER JOIN
    departments d ON de.dept_no = d.dept_no
GROUP BY d.dept_no , d.dept_name
ORDER BY AVG(s.salary) DESC
LIMIT 1;


-- 문제7.
-- 평균 연봉이 가장 높은 직책? o 
select title,avg(salary) from employees e inner join salaries s 
					on e.emp_no = s.emp_no inner join titles t
						on e.emp_no = t.emp_no group by title order by avg(salary) desc limit 1;

-- 문제8.
-- 현재 자신의 매니저보다 높은 연봉을 받고 있는 직원은?
-- 부서이름, 사원이름, 연봉, 매니저 이름, 메니저 연봉 순으로 출력합니다.


-- 특정 부서별 매니저의 연봉 select
select avg_salary from
(select 
dm.dept_no,
avg(s.salary) as avg_salary
 from employees e, salaries s, dept_manager dm
			where e.emp_no = s.emp_no 
				and e.emp_no = dm.emp_no
                and s.to_date = '9999-01-01'
                and dm.to_date = '9999-01-01'
group by dm.dept_no) a
where a.dept_no = 'd001';

-- 8번답??
SELECT 
    d.dept_name,
    e.first_name,
    s.salary,
    (SELECT 
            avg_salary
        FROM
            (SELECT 
                dm.dept_no, AVG(s.salary) AS avg_salary
            FROM
                employees e, salaries s, dept_manager dm
            WHERE
                e.emp_no = s.emp_no
                    AND e.emp_no = dm.emp_no
                    AND s.to_date = '9999-01-01'
                    AND dm.to_date = '9999-01-01'
            GROUP BY dm.dept_no) a
        WHERE
            a.dept_no = de.dept_no) AS '매니저 연봉'
FROM
    employees e,
    salaries s,
    dept_emp de,
    departments d
WHERE
    e.emp_no = s.emp_no
        AND e.emp_no = de.emp_no
        AND de.dept_no = d.dept_no
        AND s.to_date = '9999-01-01'
        AND de.to_date = '9999-01-01'
        AND s.salary > (SELECT 
            avg_salary
        FROM
            (SELECT 
                dm.dept_no, AVG(s.salary) AS avg_salary
            FROM
                employees e, salaries s, dept_manager dm
            WHERE
                e.emp_no = s.emp_no
                    AND e.emp_no = dm.emp_no
                    AND s.to_date = '9999-01-01'
                    AND dm.to_date = '9999-01-01'
            GROUP BY dm.dept_no) a
        WHERE
            a.dept_no = de.dept_no);






