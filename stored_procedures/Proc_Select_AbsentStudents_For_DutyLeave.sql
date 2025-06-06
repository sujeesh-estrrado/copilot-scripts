IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Select_AbsentStudents_For_DutyLeave]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Select_AbsentStudents_For_DutyLeave]
            (@Absent_Date datetime, @Duration_Mapping_Id bigint)
        AS
        BEGIN
            SELECT
                CP.Candidate_Fname + '' '' + CP.Candidate_Lname AS CandidateName,
                CR.RollNumber AS RollNo,
                SA.*
            FROM dbo.Tbl_Student_Absence SA
            INNER JOIN dbo.Tbl_Candidate_Personal_Det CP ON CP.Candidate_Id = SA.Candidate_Id
            LEFT JOIN Tbl_Candidate_RollNumber CR ON CR.Candidate_Id = SA.Candidate_Id
            WHERE SA.Absent_Date = @Absent_Date 
                AND SA.Duration_Mapping_Id = @Duration_Mapping_Id
                AND Absent_Type <> ''DL''
        END
    ')
END
