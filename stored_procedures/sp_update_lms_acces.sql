IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_update_lms_acces]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[sp_update_lms_acces]
    (@User_Id int ,@Lmsaccess varchar)
      
AS
BEGIN 
    

    update Tbl_Employee_User set LMS_access=@Lmsaccess where User_Id=@User_Id
        

select Scope_Identity()

END
    ')
END;
