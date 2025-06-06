IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetAll_NotesReply_by_Note_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetAll_NotesReply_by_Note_Id]
            @Note_Id BIGINT
        AS
        BEGIN
            SET NOCOUNT ON;

            SELECT NP.Note_Reply_id,
                   NP.Reply_Comments,
                   NP.Note_Id,
                   NP.Reply_Date,
                   NP.Student_employee_id,
                   NP.Student_employee_status,
                   CASE 
                       WHEN NP.Student_employee_status = 0 
                       THEN C.Candidate_Fname + '' '' + C.Candidate_Mname + '' '' + C.Candidate_Lname
                       ELSE E.Employee_FName + '' '' + E.Employee_LName 
                   END AS [User]
            FROM LMS_Tbl_Notes_Reply NP
            LEFT JOIN Tbl_Candidate_Personal_Det C 
                ON C.Candidate_Id = NP.Student_employee_id
            LEFT JOIN Tbl_Employee E 
                ON E.Employee_Id = NP.Student_employee_id
            WHERE NP.Note_Id = @Note_Id;
        END
    ')
END;
