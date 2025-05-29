IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Delete_Admission_Variance_Master_By_New_Admission_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Proc_Delete_Admission_Variance_Master_By_New_Admission_Id] 
(
@New_Admission_Id bigint
)
AS

begin

delete from dbo.Tbl_admission_variance_master where New_Admission_Id=@New_Admission_Id

end
    ')
END;
