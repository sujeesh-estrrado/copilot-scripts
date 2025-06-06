IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Batch_Semester_By_Duration_Mapping_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Get_Batch_Semester_By_Duration_Mapping_Id]  
            @Course_Duration_Mapping_Id BIGINT       
        AS        
        BEGIN        
            SELECT         
                Duration_Mapping_Id,        
                Batch_Code + ''-'' + Semester_Code AS BatchSemester,
                cdp.*      
            FROM 
                Tbl_Course_Duration_Mapping cdm         
            INNER JOIN 
                Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id        
            INNER JOIN 
                Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = cdp.Batch_Id         
            INNER JOIN 
                Tbl_Course_Semester cs ON cs.Semester_Id = cdp.Semester_Id        
            WHERE 
                cdm.Duration_Mapping_Id = @Course_Duration_Mapping_Id;   
        END
    ')
END
