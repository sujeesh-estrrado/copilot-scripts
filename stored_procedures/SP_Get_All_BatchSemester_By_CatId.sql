IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_BatchSemester_By_CatId]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Get_All_BatchSemester_By_CatId]    
        @Course_Category_Id BIGINT 
        AS                
        BEGIN   
            SELECT *                      
            FROM                           
            (               
                SELECT       
                    ROW_NUMBER() OVER (PARTITION BY cs.Semester_Id ORDER BY cs.Semester_Id) AS num,
                    cs.Semester_Id,
                    ccat.Course_Category_Name, 
                    cd.Course_Department_Id, 
                    cd.Department_Id,       
                    cd.Course_Category_Id,       
                    d.Department_Name,
                    cdm.Duration_Mapping_Id,      
                    cbd.Batch_Code + '' - '' + cs.Semester_Code AS BatchSemester 
                FROM         
                    dbo.Tbl_Department d
                    INNER JOIN dbo.Tbl_Course_Department cd
                        ON d.Department_Id = cd.Department_Id 
                    INNER JOIN dbo.Tbl_Course_Category ccat
                        ON cd.Course_Category_Id = ccat.Course_Category_Id 
                    INNER JOIN dbo.Tbl_Course_Duration_Mapping cdm
                        ON cdm.Course_Department_Id = cd.Course_Department_Id 
                    INNER JOIN Tbl_Course_Duration_PeriodDetails cdp
                        ON cdm.Duration_Period_Id = cdp.Duration_Period_Id      
                    INNER JOIN Tbl_Course_Batch_Duration cbd
                        ON cbd.Batch_Id = cdp.Batch_Id       
                    INNER JOIN Tbl_Course_Semester cs
                        ON cs.Semester_Id = cdp.Semester_Id
                WHERE 
                    cd.Course_Department_Status = 0 AND      
                    ccat.Course_Category_Status = 0 AND      
                    d.Department_Status = 0 AND 
                    cd.Course_Category_Id = @Course_Category_Id 
            ) AS tbl                        
            WHERE tbl.num = 1          
            ORDER BY tbl.Course_Category_Name 
        END
    ')
END
GO
