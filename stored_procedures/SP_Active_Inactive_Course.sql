IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Active_Inactive_Course]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Active_Inactive_Course]
(@Course_Id bigint)

AS

BEGIN
Declare @Active_Status Varchar(MAX)
set @Active_Status=(select Active_Status from Tbl_New_Course WHERE  Course_Id = @Course_Id)
if(@Active_Status=''Active'')
Begin
        UPDATE [dbo].[Tbl_New_Course]
                SET     Active_Status=''InActive''
                WHERE  Course_Id = @Course_Id
End
else
begin
UPDATE [dbo].[Tbl_New_Course]
                SET     Active_Status=''Active''
                WHERE  Course_Id = @Course_Id
End
END
    ')
END
