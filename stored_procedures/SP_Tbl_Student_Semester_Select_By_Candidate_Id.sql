IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Student_Semester_Select_By_Candidate_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Student_Semester_Select_By_Candidate_Id] 
        @Candidate_Id bigint
        AS
        BEGIN
            SELECT Duration_Mapping_Id 
            FROM Tbl_Student_Semester 
            WHERE Candidate_Id = @Candidate_Id 
            AND Student_Semester_Current_Status = 1;
        END
    ')
END
