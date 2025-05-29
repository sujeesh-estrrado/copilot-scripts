IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_InsertEmployeeAllocation]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_InsertEmployeeAllocation](@from datetime=null,@to datetime=null,@employeeid bigint=0
,@room bigint=0,@type varchar(100)='''',@Ref_id bigint=0)
as
begin
insert into Tbl_Employee_Allocations(Allocation_From,Allocation_To,Employee_Id,Room,Type,Reference_id,Status)
values(@from,@to,@employeeid,@room,@type,@Ref_id,0)
end
    ');
END;
