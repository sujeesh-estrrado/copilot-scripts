IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Incentive_Management_Get]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_Incentive_Management_Get]

@FromDate  DATETIME,
@ToDate    DATETIME

AS
BEGIN
        SELECT distinct
                CounselorEmployee_id,
                ISNULL(E.Employee_FName,'''') +'' ''+ ISNULL(E.Employee_LName,'''')  AS ''Councellor Name'',
               (SELECT count(*) FROM Tbl_Candidate_Personal_Det WHERE CounselorEmployee_id=E.Employee_Id) AS ''Total Registration'',
                ''250'' AS ''Incentive''
        FROM dbo.Tbl_Employee E inner join Tbl_Candidate_Personal_Det CPD on CPD.CounselorEmployee_id=E.Employee_Id
        WHERE 
             CPD.RegDate  between @FromDate and @ToDate
       

END

    ');
END;
