IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_bindintake]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_bindintake](@Bid int)
as
begin
select CONCAT(Department_Id,''#'',Batch_Id) AS intakeid,Department_Name from View_intake_new where New_Admission_Id=@Bid;
end 
    ')
END;
