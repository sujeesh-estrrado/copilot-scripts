IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Student_Shortlist_Get_All]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_Tbl_Student_Shortlist_Get_All]    
    AS    
    BEGIN    
        SELECT    
            ss.Shortlist_Id,    
            ss.Candidate_Id,    
            ss.Course_Category_Id,    
            ss.Department_Id,    
            ss.Shortlist_Status,    
            ss.indexmark,    
            ss.priority,    
            cpd.Candidate_Fname + '' '' + cpd.Candidate_Mname + '' '' + cpd.Candidate_Lname AS CandidateName,   
            cpd.New_Admission_Id,  
            NA.Batch_Id AS BatchID,  
            CBD.Batch_Code AS Batch,    
            cc.Course_Category_Id,        
            cc.Course_Category_Name,        
            d.Department_Name,    
            d.Department_Id    
        FROM Tbl_Student_Shortlist ss    
        INNER JOIN Tbl_Candidate_Personal_Det cpd ON cpd.Candidate_Id = ss.Candidate_Id        
        INNER JOIN Tbl_Department d ON d.Department_Id = ss.Department_Id        
        INNER JOIN Tbl_Course_Category cc ON cc.Course_Category_Id = ss.Course_Category_Id     
        INNER JOIN Tbl_New_Admission NA ON NA.New_Admission_Id = cpd.New_Admission_Id  
        INNER JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = NA.Batch_Id  
        WHERE ss.Shortlist_Status = 0    
        AND cpd.Candidate_Id NOT IN (SELECT Candidate_Id FROM Tbl_Student_Registration) 
        ORDER BY ss.priority, ss.indexmark DESC;
    END
    ')
END
