IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_LMS_Issue_Book_Select_By_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_LMS_Issue_Book_Select_By_Id] 
        @Issue_Book_Id bigint
        AS
        BEGIN
            SET NOCOUNT ON;

            SELECT 
                [Issue_Book_Id],
                BI.[Book_Id],
                [Issue_Date],
                [Due_Date],
                [Is_Returned],
                [Return_Date],
                [Candidate_or_Employee],
                [Candidate_Employee_Id],
                [Issue_Book_Status],

                CASE 
                    WHEN Candidate_or_Employee = 0 
                    THEN (Candidate_Fname + '' '' + Candidate_Mname + '' '' + Candidate_Lname) 
                    ELSE (Employee_FName + '' '' + Employee_LName) 
                END AS Name
            FROM [Tbl_LMS_Issue_Book] BI
            LEFT JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id = BI.Candidate_Employee_Id
            LEFT JOIN Tbl_Employee E ON E.Employee_Id = BI.Candidate_Employee_Id
            WHERE Issue_Book_Id = @Issue_Book_Id
        END
    ')
END
