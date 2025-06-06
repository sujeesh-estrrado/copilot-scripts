IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Delete_Day_Week]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_Delete_Day_Week] 
    @WeekDaySettings_Id bigint ,
    @Dept_Id bigint
AS
BEGIN 

    delete from Tbl_Day_Week 
    where Dept_Id = @Dept_Id  
    AND   WeekDay_Settings_Id = @WeekDaySettings_Id;
     
END
    ')
END
