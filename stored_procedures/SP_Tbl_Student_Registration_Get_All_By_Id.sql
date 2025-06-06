IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Student_Registration_Get_All_By_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Student_Registration_Get_All_By_Id] 
        @Candidate_Id bigint
        AS
        BEGIN
            SELECT 
                sr.Student_Reg_Id,
                sr.Candidate_Id,
                sr.Course_Category_Id,
                sr.Department_Id,
                sr.Student_Reg_No,
                sr.Student_Reg_Status,
                cpd.Candidate_Fname + '' '' + cpd.Candidate_Mname + '' '' + cpd.Candidate_Lname AS CandidateName,    
                cc.Course_Category_Id,    
                cc.Course_Category_Name,    
                d.Department_Name,
                d.Department_Id
            FROM Tbl_Student_Registration sr
            INNER JOIN Tbl_Candidate_Personal_Det cpd ON cpd.Candidate_Id = sr.Candidate_Id    
            INNER JOIN Tbl_Department d ON d.Department_Id = sr.Department_Id    
            INNER JOIN Tbl_Course_Category cc ON cc.Course_Category_Id = sr.Course_Category_Id
            WHERE sr.Candidate_Id = @Candidate_Id
        END
    ')
END
