IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Delete_Departmentnew]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Delete_Departmentnew](@Department_Id bigint)

AS

BEGIN
if not exists(select * from Tbl_Course_Batch_Duration where Duration_Id=@Department_Id and Batch_DelStatus=0)
begin
	UPDATE [dbo].[Tbl_Department]
		SET    	Department_Status = 1,
		Delete_Status=1
		WHERE  Department_Id = @Department_Id
END
end



    ')
END
