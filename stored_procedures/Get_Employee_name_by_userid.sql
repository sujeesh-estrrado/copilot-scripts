-- Check if the procedure exists before creating it
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Employee_name_by_userid]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Get_Employee_name_by_userid] 
    -- Add the parameters for the stored procedure here
    @UserId bigint=0

AS
BEGIN
    
    select e.Employee_FName,e.Employee_LName from Tbl_Employee_User eu left join Tbl_Employee e on e.Employee_Id= eu.employee_id
where eu.User_Id=@UserId


END
    ')
END;
GO
