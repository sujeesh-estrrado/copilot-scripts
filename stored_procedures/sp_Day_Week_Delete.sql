IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Day_Week_Delete]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE PROCEDURE [dbo].[sp_Day_Week_Delete] 
    @Dept_Id BIGINT
AS
BEGIN 

    delete from Tbl_Day_Week 
    where Dept_Id = @Dept_Id   
     
      
END
    ')
END
