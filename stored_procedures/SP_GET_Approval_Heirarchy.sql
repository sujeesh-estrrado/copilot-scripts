IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_Approval_Heirarchy]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GET_Approval_Heirarchy]

(@Type varchar(50))

as begin

select AuthorityUserId,Name,Type,Priority
from dbo.Tbl_Approval_Hierarchy where delstatus=0 and Type=@Type

end


   ')
END;
