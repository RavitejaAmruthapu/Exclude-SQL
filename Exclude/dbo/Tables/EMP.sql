CREATE TABLE [dbo].[EMP] (
    [EMPNO]    NUMERIC (4)    NOT NULL,
    [ENAME]    VARCHAR (10)   NULL,
    [JOB]      VARCHAR (9)    NULL,
    [MGR]      NUMERIC (4)    NULL,
    [HIREDATE] DATETIME       NULL,
    [SAL]      NUMERIC (7, 2) NULL,
    [COMM]     NUMERIC (7, 2) NULL,
    [DEPTNO]   NUMERIC (2)    NULL
);

