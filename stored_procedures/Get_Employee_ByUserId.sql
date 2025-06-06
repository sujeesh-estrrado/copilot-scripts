-- Check if the procedure 'Get_Employee_ByUserId' exists before creating
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Employee_ByUserId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[Get_Employee_ByUserId](@User_Id bigint)
as
Begin
select Employee_Id from dbo.Tbl_Employee_User where User_Id=@User_Id
end
    ')
END;
GO
