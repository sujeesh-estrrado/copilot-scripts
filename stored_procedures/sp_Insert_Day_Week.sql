IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Insert_Day_Week]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[sp_Insert_Day_Week] 
    @Dept_Id bigint,             
    @Day_Week_Status varchar(50),             
    @WeekDay_Settings_Id bigint,              
    @Checked_Status bit
AS
BEGIN 

    delete from Tbl_Day_Week 
    where Dept_Id = @Dept_Id  
    AND   WeekDay_Settings_Id = @WeekDay_Settings_Id;
	 

    insert into Tbl_Day_Week (Dept_Id,Day_Week_Status, Day_Id, WeekDay_Settings_Id, Checked_Status, Status, Created_Date, Location_Id)
    values (@Dept_Id,  @Day_Week_Status, 0, @WeekDay_Settings_Id, @Checked_Status, 1, getdate(), 0);

END');
END;
