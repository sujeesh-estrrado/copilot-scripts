IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Student_Attendance_By_Candidate_Id_Date_Duration_Mapping_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_Get_Student_Attendance_By_Candidate_Id_Date_Duration_Mapping_Id]                
        @Duration_Mapping_Id BIGINT,                    
        @DateofAttendance VARCHAR(30),  
        @Candidate_Id BIGINT                    
    AS                    
    BEGIN            
        SET NOCOUNT ON;
        
        SELECT                     
            ISNULL(R.RollNumber, ROW_NUMBER() OVER (ORDER BY S.Candidate_Id)) AS RollNo,                    
            S.Student_Semester_Id,                    
            S.Candidate_Id,                    
            S.Duration_Mapping_Id,               
            TRIM(
                COALESCE(C.Candidate_Fname, '''') + '' '' + 
                COALESCE(C.Candidate_Mname, '''') + '' '' + 
                COALESCE(C.Candidate_Lname, '''')
            ) AS CandidateName,          
            ISNULL(
                (SELECT 
                    CASE Absent_Type 
                        WHEN ''Both'' THEN ''A'' 
                        WHEN ''FN'' THEN ''FN'' 
                        WHEN ''AN'' THEN ''AN'' 
                        WHEN ''DL'' THEN ''DL'' 
                        ELSE ''P'' 
                    END 
                 FROM Tbl_Student_Absence 
                 WHERE Duration_Mapping_Id = @Duration_Mapping_Id          
                   AND Absent_Date = @DateofAttendance 
                   AND Candidate_Id = S.Candidate_Id
                ), ''P''
            ) AS IsAbsent      
        FROM Tbl_Student_Semester S                    
        INNER JOIN Tbl_Candidate_Personal_Det C ON S.Candidate_Id = C.Candidate_Id                    
        LEFT JOIN Tbl_Candidate_RollNumber R 
            ON S.Candidate_Id = R.Candidate_Id   
            AND S.Duration_Mapping_Id = R.Duration_Mapping_Id                
        WHERE  
            S.Duration_Mapping_Id = @Duration_Mapping_Id 
            AND S.Student_Semester_Delete_Status = 0  
            AND S.Candidate_Id = @Candidate_Id        
        ORDER BY RollNo;                  
    END;
    ');
END;
