IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_check_batchcode]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_check_batchcode](@batchcode varchar(500))
as
begin

select * from Tbl_Course_Batch_Duration where Batch_Code=@batchcode and Batch_DelStatus=0;
end

    ')
END
