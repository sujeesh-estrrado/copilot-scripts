IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[updateProgrammeReregistrationStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        create procedure [dbo].[updateProgrammeReregistrationStatus](@Department_Id bigint ,@reregistrationstatus bigint)
as begin
Update Tbl_Department set Course_rereg_status=@reregistrationstatus where Department_Id=@Department_Id

end
    ')
END;
