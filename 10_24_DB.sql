select * from oct_snack WHERE s_maker = '롯데';

-- 문자열 포함 검색 : like '패턴'
--	%
--	%온 : 온으로 끝남
--	오% : 오로 시작함
--	%해% : 해가 포함 됨

select avg(s_price) as avg_price from OCT_SNACK where s_name like '%새콤달콤%';

SELECT s_name,s_maker,s_price FROM oct_snack WHERE s_name like '%몽쉘%'

SELECT s_name,s_price FROM oct_snack WHERE s_name like '%몽쉘%' or s_maker like '농심'

SELECT s_name,s_price FROM oct_snack WHERE s_price >= 1000 and s_price <= 5000;

SELECT s_name,s_price,s_maker FROM oct_snack WHERE s_price = (select max(s_price) from oct_snack);

SELECT s_maker FROM oct_snack WHERE s_price = (SELECT min(s_price) FROM oct_snack);

SELECT count(s_number) as avg_price FROM oct_snack WHERE s_price >= (SELECT avg(s_price) FROM oct_snack);



SELECT distinct s_maker FROM oct_snack;

CREATE SEQUENCE oct24_maker_seq;

DROP SEQUENCE oct24_maker;

CREATE TABLE oct24_maker(
	m_number number(4) primary key,
	m_name varchar2(20 char) not null,
	m_address varchar2(50 char) not null,
	m_employee number(4) not null
);

DROP TABLE oct24_maker cascade constraint purge;

SELECT * FROM oct_snack;

SELECT * FROM oct24_maker;

INSERT INTO OCT_SNACK VALUES(oct23_snack_seq.nextval,'초코파이','크라운',3000,sysdate)
INSERT INTO OCT_SNACK VALUES(oct23_snack_seq.nextval,'엄마손파이','크라운',3600,sysdate)
INSERT INTO OCT_SNACK VALUES(oct23_snack_seq.nextval,'쌀과자','크라운',2200,sysdate)

INSERT INTO oct24_maker VALUES(oct24_maker_seq.nextval,'롯데','서울',250);
INSERT INTO oct24_maker VALUES(oct24_maker_seq.nextval,'해태','인천',850);
INSERT INTO oct24_maker VALUES(oct24_maker_seq.nextval,'크라운','광주',680);
INSERT INTO oct24_maker VALUES(oct24_maker_seq.nextval,'오리온','부산',374);
INSERT INTO oct24_maker VALUES(oct24_maker_seq.nextval,'농심','대구',850);
INSERT INTO oct24_maker VALUES(oct24_maker_seq.nextval,'해외','미주리',1200);

SELECT m_name,s_name,s_price FROM oct24_maker,oct_snack WHERE m_employee in (SELECT min(m_employee) FROM oct24_maker) and m_name = s_maker;

-- 다중 서브 쿼리 : 결과값이 여러개 나올 수 있음. = 대신 in 사용 가능.


-- 제일 비싼 과자를 만드는 회사는 어디에 있는지 조회?
SELECT m_name,m_address FROM oct24_maker WHERE m_name = (SELECT s_maker FROM oct_snack WHERE s_price = (SELECT max(s_price) FROM oct_snack));

-- 광주에 있는 회사에서 만드는 과자 평균가
SELECT avg(s_price) FROM oct_snack WHERE s_maker = (SELECT m_name FROM oct24_maker WHERE m_address = '광주');

-- 평균가 이상의 과자를 만드는 회사 이름,위치
SELECT m_name,m_address FROM oct24_maker WHERE m_name in (SELECT distinct s_maker FROM oct_snack WHERE s_price >= (SELECT avg(s_price) FROM oct_snack));

-- SELECT [distinct] [컬럼명], [컬럼명 as 별명 || 컬럼명 별명], [연산자], [통계함수],...
-- FROM [테이블명] 
-- WHERE [조건] 
-- GROUP BY [그룹 대상] 
-- HAVING [함수 조건] 
-- ORDER BY [ASC/DESC] 

-- 산술 연산자
--		Dual 테이블
--		1. Oracle 자체에서 제공해주는 더미테이블
--		2. 간단하게 함수 이용해서 계산한 결과값 화긴에 사용

SELECT 2+5 as TEST FROM dual;
SELECT 1 + '4' FROM dual;

-- 대부분의 언어들은 [문자 우선] > 1 + '4' = 14
-- Oracle [숫자 우선] > 5 (오라클 내에서는 연산자가 숫자[만] 연산 해줌.)

-- 다른 프로그래밍 언어처럼 문자 + 숫자를 사용하지 못함.
SELECT 1 + 'a' FROM dual

-- 문자도 더해주는 연산자 : ||
SELECT 1 || 'a' FROM dual

-- 날짜 / 시간 함수
-- YYYY : 4자리 년도
-- YYY, YY, Y : 각각 4자리 연도의 마지막 3자리,2자리,1자리
-- MM : 월
-- DD : 일
-- DAY : 요일(월요일~일요일)
-- DY : 요일(월~일)
-- HH, HH12 : 12시간제 / AM or PM : 오전 오후
-- HH24 : 24시간제
-- MI : 분
-- SS : 초
-- sysdate : 현재 날짜, 시간 반환

-- to_date(문자열, 패턴) : 문자형 데이터를 날짜형으로 변환
SELECT to_date('2023-10-24 오후 03:03:03', 'YYYY-MM-DD PM HH:MI:SS') from dual;

-- to_char(date,패턴) : 날짜형 데이터를 문자로 변환
SELECT to_char(sysdate,'YYYY.MM.DD') as now from dual;

-- 특정 값만 받아오고싶다면?
SELECT to_char(to_date('2023-10-23','YYYY-MM-DD'),'YYYY.MM.DD') as yesterady FROM dual;

SELECT to_char(sysdate,'YYYY') || '년' AS years FROM dual;

-- 오늘날짜 기준 월,일 조회
SELECT to_char(sysdate,'MM') || '월' AS 월, to_char(sysdate,'DD') || '일' AS 일 FROM dual;

-- 현재 시간 기준 시, 분 조회
SELECT to_char(sysdate,'HH24') || '시' AS 시, to_char(sysdate,'MI') || '분' AS 분 FROM dual;

-- 지금이 오전인지 오후인지 조회
--	별명에 띄어쓰기, 특문이 들어가는 경우 : 별명을 "" 로.
SELECT to_char(sysdate,'AM') "오전/오후" FROM dual;


-- NULL 관련 함수
--		보통 제약조건에 NOT NULL로 설정해서 무조건 데이터 입력하게 해놓음.
--		NULL : 확인되지 않은 값이나 아직 적용되지 않은 값 / 0 or "" 아님.

-- NVL 함수 : NULL일때 지정한 값으로 대치함
--	NUL(값,NULL일 때)
SELECT NVL(null,'-') FROM 테이블명;

-- NVL2 함수 : NULL의 여부에 따라 지정한 값으로 대치
--	NUL2(값,값이 있을때 대치값,NULL일 때 대치값)
SELECT NVL2(null,'A','B') FROM 테이블명;

-- 웹사이트에서 게시판에 대한 테이블과 이를 참조하는 게시판 댓글 테이블을 만들려고 함. (FOREIGN KEY)
-- FOREIGN KEY
--	다른 테이블의 특정 컬럼을 조회해서 동일한 데이터가 있는 경우에만 적용 허용.
--	참조하는 테이블은 PK, Unique로 지정된 컬럼만 FK로 가능.
--	외래키 설정을 위해서는 참조받는 테이블이 먼저 생서오디야 하고 FK 테이블이 이후에 생성되어야 함. 외래키는 이름 중복 X

-- CONSTRAINT FK명 FOREIGN KEY(컬럼명) REFERENCES 대상테이블명(대상테이블 컬럼명) ON DELETE CASCADE or ON DELETE SET NULL
-- 참조 테이블에서 해당 행이 지워졌을 시 같이 지울지, NULL값으로 대체할 지 선택

CREATE SEQUENCE board_seq;
DROP SEQUENCE board_seq;
CREATE SEQUENCE board_reply_seq;
DROP SEQUENCE board_reply_seq;

truncate TABLE oct24_board;
truncate TABLE oct24_board_reply;

CREATE TABLE oct24_board(
	b_num NUMBER(5) primary key,
	b_name varchar2(10 char) not null,
	b_field varchar2(500 char) not null,
	b_date date not null
);

CREATE TABLE oct24_board_reply(
	r_num NUMBER(5) primary key,
	r_b_num number(5) not null,
	r_name varchar2(10 char) not null,
	r_field varchar2(500 char) not null,
	r_date date not null,
	CONSTRAINT f_num FOREIGN KEY(r_b_num) references oct24_board(b_num) ON DELETE CASCADE
);

INSERT INTO oct24_board VALUES(board_seq.nextval,'실험용 1','게시판 실험용 첫 글입니다.',sysdate);
INSERT INTO oct24_board VALUES(board_seq.nextval,'졸리다 ...','게시판 실험용 두번째 글입니다.',sysdate);

INSERT INTO oct24_board_reply VALUES(board_reply_seq.nextval,1,'테스터1','테스트중입니다',sysdate);
INSERT INTO oct24_board_reply VALUES(board_reply_seq.nextval,1,'테스터2','테스트',sysdate);
INSERT INTO oct24_board_reply VALUES(board_reply_seq.nextval,2,'지병천','허리아프당',sysdate);
INSERT INTO oct24_board_reply VALUES(board_reply_seq.nextval,2,'안종근','ㅠㅠ',sysdate);

SELECT * FROM oct24_board;
SELECT * FROM oct24_board_reply;

DROP TABLE oct24_board;
DROP TABLE oct24_board_reply;

DELETE FROM oct24_board WHERE b_num < 5;

CREATE TABLE oct24_major(
	m_code number(4) primary key, m_name varchar2(10 char) not null
);

INSERT INTO oct24_major values(1001,'컴퓨터공학과');
INSERT INTO oct24_major values(2001,'경영학과');
INSERT INTO oct24_major values(3001,'법학과');
INSERT INTO oct24_major values(4001,'정보통신과');
INSERT INTO oct24_major values(5001,'경찰행정학과');

SELECT * FROM oct24_major;

CREATE TABLE oct24_student(
	s_no NUMBER(3) primary key,
	s_name VARCHAR2(10 char) not null,
	s_code NUMBER(4) NOT NULL,
	CONSTRAINT f_code FOREIGN KEY(s_code) REFERENCES oct24_major(m_code) ON DELETE CASCADE
);

CREATE SEQUENCE student_number;

INSERT INTO oct24_student VALUES(student_number.nextval,'지병천',1001);
INSERT INTO oct24_student VALUES(student_number.nextval,'엄홍익',2001);
INSERT INTO oct24_student VALUES(student_number.nextval,'안종근',3001);
INSERT INTO oct24_student VALUES(student_number.nextval,'조재형',4001);
INSERT INTO oct24_student VALUES(student_number.nextval,'차수인',5001);

SELECT * FROM oct24_student;

DELETE FROM oct24_major WHERE m_code = 2001;