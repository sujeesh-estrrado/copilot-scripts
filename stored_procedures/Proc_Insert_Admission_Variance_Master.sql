IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_Admission_Variance_Master]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Proc_Insert_Admission_Variance_Master]
(
@variance_level varchar(300),
@variance_fields varchar(300),
@New_Admission_Id bigint
)
AS
BEGIN

insert into Tbl_admission_variance_master (variance_level,variance_fields,New_Admission_Id) values

(@variance_level,@variance_fields,@New_Admission_Id)


select SCOPE_IDENTITY()

END
    ')
END;
