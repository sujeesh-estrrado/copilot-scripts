IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Update_Admission_Variance_Master_By_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Proc_Update_Admission_Variance_Master_By_Id]
(
@variance_level varchar(300),
@variance_fields varchar(300),
@New_Admission_Id bigint,
@variance_id bigint
)
AS
BEGIN

update Tbl_admission_variance_master set  variance_level=@variance_level,variance_fields=@variance_fields,
    New_Admission_Id=@New_Admission_Id where variance_id=@variance_id

END
    ')
END;
