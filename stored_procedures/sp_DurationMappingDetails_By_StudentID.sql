IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_DurationMappingDetails_By_StudentID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_DurationMappingDetails_By_StudentID]           
        @StudentID BIGINT          
        AS          
        BEGIN   
            SELECT        
                dbo.Tbl_Student_Semester.Candidate_Id,  
                D.Department_Id AS ProgramID, 
                CDM.Duration_Mapping_Id, 
                cd.Duration_Period_Id, 
                cd.Batch_Id, 
                cd.Semester_Id, 
                CONVERT(VARCHAR(50), cd.Duration_Period_From, 103) AS Duration_Period_From, 
                CONVERT(VARCHAR(50), cd.Duration_Period_To, 103) AS Duration_Period_To, 
                cd.Duration_Period_Status,           
                cs.Semester_Name, 
                bd.Batch_Code, 
                CONVERT(VARCHAR(50), cd.Closing_Date, 103) AS Closing_Date, 
                D.Department_Name AS Program,           
                D.Course_Code AS ProgramCode          
            FROM            
                dbo.Tbl_Student_Semester 
            INNER JOIN          
                dbo.Tbl_Course_Duration_Mapping AS CDM 
                ON dbo.Tbl_Student_Semester.Duration_Mapping_Id = CDM.Duration_Mapping_Id 
            RIGHT OUTER JOIN          
                dbo.Tbl_Course_Duration_PeriodDetails AS cd 
            LEFT OUTER JOIN          
                dbo.Tbl_Course_Batch_Duration AS bd 
                ON cd.Batch_Id = bd.Batch_Id 
            LEFT OUTER JOIN          
                dbo.Tbl_Course_Semester AS cs 
                ON cs.Semester_Id = cd.Semester_Id 
            ON CDM.Duration_Period_Id = cd.Duration_Period_Id 
            LEFT OUTER JOIN          
                dbo.Tbl_Course_Department AS Cdep 
                ON Cdep.Department_Id = CDM.Course_Department_Id 
            LEFT OUTER JOIN          
                dbo.Tbl_Department AS D 
                ON D.Department_Id = Cdep.Department_Id          
            WHERE        
                (cd.Duration_Period_Status = 0) 
                AND (dbo.Tbl_Student_Semester.Candidate_Id = @StudentID)  
        END
    ')
END
