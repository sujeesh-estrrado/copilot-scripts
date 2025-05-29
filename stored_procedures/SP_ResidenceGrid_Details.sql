IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_ResidenceGrid_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_ResidenceGrid_Details]      
(
    @flag BIGINT = 0,    
    @PageSize BIGINT = 10,        
    @CurrentPage BIGINT = 1,        
    @status BIGINT = 1        
)        
AS        
BEGIN        
    IF (@flag = 0) -- Get paginated data        
    BEGIN        
        SELECT 
            ResidenceId,
            Candidate_Id,
            CandidateName,
            AdharNumber,
            CONCAT(D.Course_Code, ''-'', D.Department_Name) AS Department_Name,    
            R.Department_Id,
            cbd.Batch_Code,
            IntakeId,
            Duration,
            Typeofroom,
            CASE 
                WHEN Typeofroom = 1 THEN ''Single share''            
                WHEN Typeofroom = 2 THEN ''Two share''            
                WHEN Typeofroom = 3 THEN ''Three share''          
                WHEN Typeofroom = 4 THEN ''Four share'' 
            END AS TypeofroomName  
        FROM Tbl_ResidenceForm AS R  
        LEFT JOIN Tbl_Department D ON D.Department_Id = R.Department_Id     
        LEFT JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = R.IntakeId  
        ORDER BY ResidenceId  
        OFFSET @PageSize * (@CurrentPage - 1) ROWS        
        FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);        
    END        
        
    IF (@flag = 1) -- Get total count      
    BEGIN        
        SELECT COUNT(*) AS totcount 
        FROM Tbl_ResidenceForm AS R  
        LEFT JOIN Tbl_Department D ON D.Department_Id = R.Department_Id     
        LEFT JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = R.IntakeId;
    END        
END');
END;