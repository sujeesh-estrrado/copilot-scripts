IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_SelectStudentsForRoomAllocation]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_SelectStudentsForRoomAllocation]
        @Duration_Mapping_Ids NVARCHAR(MAX)
        AS
        BEGIN
            SELECT        
                R.RollNumber AS RollNo,      
                -- IsNull(R.RollNumber, ROW_NUMBER() OVER(ORDER BY S.Candidate_Id)) AS RollNo,          
                S.Student_Semester_Id,          
                S.Candidate_Id,          
                S.Duration_Mapping_Id,          
                CONCAT(Candidate_Fname, '' '', Candidate_Mname, '' '', Candidate_Lname) AS [CandidateName]          
            FROM 
                Tbl_Student_Semester S          
            INNER JOIN 
                Tbl_Candidate_Personal_Det C ON S.Candidate_Id = C.Candidate_Id          
            LEFT JOIN 
                Tbl_Candidate_RollNumber R ON S.Candidate_Id = R.Candidate_Id 
                AND S.Duration_Mapping_Id = R.Duration_Mapping_Id          
            WHERE 
                Student_Semester_Delete_Status = 0  
                AND Student_Semester_Current_Status = 1  
                AND S.Duration_Mapping_Id IN (SELECT [value] FROM dbo.Split(@Duration_Mapping_Ids, '',''))      
            ORDER BY  
                S.Duration_Mapping_Id, RollNo    
        END
    ')
END
