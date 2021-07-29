-- 임시 테이블 : '#' 사용해서 만든 temp 테이블

create table zz_table (c1 nvarchar(1))

create index zz_index on zz_table(c1)

select * into #zz_temp_table from zz_table
--create table #zz_temp_table (c1 nvarchar(1))
--create nonclustered index zz_temp_index on #zz_temp_table(c1)
create clustered index zz_temp_index on #zz_temp_table(c1)

create table #zz_temp_table (c1 nvarchar(1), constraint zz_pk primary key clustered(c1))

select * from #zz_temp_table
DROP TABLE #zz_temp_table
DROP TABLE zz_table


-- 테이블 변수 : '@' 사용해서 만든 temp 테이블
DECLARE @TBL TABLE  
( SORT_NO                   INT PRIMARY KEY
	,COLOR                     INT
	,OBJECT_TYPE_CD            NVARCHAR(10)
	,BP_ACCT_GR				NVARCHAR(30)
	,BP_ACCT_CD				NVARCHAR(30) 
	,PY1_YYYY_AMT				NUMERIC(18, 2)
	,Y0_YYYY_AMT				NUMERIC(18, 2)
	,Y1_RSLT_AMT       		NUMERIC(18, 2)
	,Y1_INCR_AMT				NUMERIC(18, 2)
	--,constraint zz_temp_pk primary key clustered (SORT_NO)
)
select * from @TBL




https://m.blog.naver.com/PostView.naver?isHttpsRedirect=true&blogId=islove8587&logNo=220608680181


-- 정리 :
@로 생성한 테이블은 트랜잭션이 끝날 때까지만 살아있고
#로 생성한 테이블은 세션이 끝날 때까지 살아있습니다.

들어가는 데이터가 100건 이상이면 #, 이하면 @가 유리한 것 같네요.