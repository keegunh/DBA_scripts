/*
	�ó�����: 
		1. �׽�Ʈ ������ ���� �÷��� ���� SQL Baseline Plan���� ��ϵǾ� �ִ�. (Automatic STS Capture�� Baseline �����)
			���� �÷��� �� ó�� Baseline plan���� ��ϵƱ� ������ ACCEPTED='YES' ������.
		2. �׽�Ʈ ������ ���� �÷��� ���� ����ż� Baseline plan�� ��ϵȴ�.
			�� �� ���� �÷��� ACCEPTED='NO' ���·� �߰���.
			���� ID�� ������ PLAN�� Baseline�� 2�� ������ �ش� ���� ���� �� ACCEPTED='YES' ������ �÷��� ���󰣴�.
		
		��������� Ư�� SQL�� ���� �÷��� dba_sql_plan_baselines�� �� ��ϵǾ� �ִٸ� ���� ȯ���� �ٲ�� ���� �÷����� ����Ǵ��� 
		���� �÷� ������ 2�� �̻� ����ǰų� Auto STS Capture Task JOB���� ���� dba_sql_plan_baselines�� ��ϵǱ⸸ �Ѵٸ�
		�� SQL�� ������ ACCEPTED='YES' ������ ���� �÷����� Ǯ��.
			
		* Baseline plan�� ��ϵȴٴ� ���� �ش� ������ �÷��� DBA_SQL_PLAN_BASELINES�� ENABLED='YES' ���·� �Էµȴٴ� ��.
*/



ALTER SYSTEM FLUSH BUFFER_CACHE;
ALTER SYSTEM FLUSH SHARED_POOL;
ALTER SESSION SET STATISTICS_LEVEL=ALL;


--------------------------------------------------------------------------
-- #06. Test ���� 1��° ���� (Good Performance)
--------------------------------------------------------------------------
alter session set optimizer_ignore_hints = true; --> �Ʒ� SQL���� ��Ʈ�� ���� Plan ���� Ǯ���� ���̰�, �̸� �����ϱ� ���� ignore ..

select /* ddd */ /*+ USE_NL(t1) LEADING(t2 t1) */ sum(t2.amount)
  from sales_area1 t1, 
       sales_area2 t2
 where t1.sale_code = t2.sale_code
   and t1.sale_type = 1;


--------------------------------------------------------------------------
-- #07. �ռ� ������ SQL�� Plan �� Ȯ��
--------------------------------------------------------------------------
SELECT SQL_ID, CHILD_NUMBER, SQL_TEXT, SQL_PLAN_BASELINE
  FROM V$SQL 
 WHERE SQL_TEXT LIKE '%/* ddd */%'
   AND SQL_TEXT NOT LIKE '%V$SQL%';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('bttmzny8pwuhm', NULL, 'ADVANCED ALLSTATS LAST'));








--------------------------------------------------------------------------
-- #13. Test ������ 2��° ���� (������ �������� ����)
--------------------------------------------------------------------------
alter session set optimizer_ignore_hints = false; --> ������ Plan ���� ����ǵ��� ...

select /* ddd */ /*+ USE_NL(t1) LEADING(t2 t1) */ sum(t2.amount)
  from sales_area1 t1, 
       sales_area2 t2
 where t1.sale_code = t2.sale_code
   and t1.sale_type = 1;
        ---> !!! Auto SPM ���ణ���� 1�ð������̱� ������ 1�ð��� ������ baseline ���� ��ϵǰ� �׶����� ������.
        ---> !!! baseline ���� ��ϵǾ����� dba_sql_plan_baselines ���� �ֱ������� Ȯ���� �Ŀ� ������ �����ϸ� ��.

--------------------------------------------------------------------------
-- #15. Test ������ 3��° ���� (baseline �� ��ϵǾ ���� �������� ����)
--------------------------------------------------------------------------
select /* ddd */ /*+ USE_NL(t1) LEADING(t2 t1) */ sum(t2.amount)
  from sales_area1 t1, 
       sales_area2 t2
 where t1.sale_code = t2.sale_code
   and t1.sale_type = 1;