IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Delete_Subject]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Delete_Subject]
(@Course_Id bigint)

AS
             
IF  EXISTS(select Course_Prequisite from Tbl_New_Course where Course_Prequisite=@Course_Id  and Delete_Status=0)
BEGIN  
   RAISERROR (''Head Name Already Exists.'',16,1);
END
ELSE

BEGIN

        UPDATE [dbo].[Tbl_New_Course]
                SET     Delete_Status = 1,Updated_Date=getdate()
                WHERE  Course_Id = @Course_Id
END
    ')
END
