IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Delete_New_Admission]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Delete_New_Admission](@New_Admission_Id bigint)

AS

BEGIN

    UPDATE dbo.tbl_New_Admission
        SET    Admission_Status  = 0
        WHERE  New_Admission_Id=@New_Admission_Id
END

    ')
END
