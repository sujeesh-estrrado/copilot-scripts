IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Checkintakestartand_end]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[Sp_Checkintakestartand_end](@batchid bigint)
as
begin

select * from Tbl_Course_Batch_Duration where GETDATE() between  DATEADD(DAY, 30, Batch_From) and DATEADD(MONTH, 6, Batch_From) and  Batch_Id=@batchid ;

end
    ')
END;
