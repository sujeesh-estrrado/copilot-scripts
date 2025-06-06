IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Tset_For_Getting_batchid]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_Tset_For_Getting_batchid]
AS
BEGIN
select Batch_Id,Batch_Code,Study_Mode from Tbl_test_for_batch_sem_mapping_02 as tb
left join dbo.Tbl_Course_Batch_Duration as cbd on cbd.Batch_Code=tb.intake and cbd.Study_Mode=tb.Mode
left join dbo.Tbl_Course_Department as cd on cd.Course_Department_Code=tb.code
END
    ')
END
