IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_UpdateEmployeeAllocation]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_UpdateEmployeeAllocation](@from datetime=null,@to datetime=null,@employeeid bigint=0
,@room bigint=0,@type varchar(100)='''',@Ref_id bigint=0)
as
begin

update Tbl_Employee_Allocations set Allocation_From=@from,Allocation_To=@to,Employee_Id=@employeeid,Room=@room,Type=@type where Reference_id=@Ref_id
--insert into Tbl_Employee_Allocations(Allocation_From,Allocation_To,Employee_Id,Room,Type,Reference_id,Status)
--values(@from,@to,@employeeid,@room,@type,@Ref_id,0)
end
    ')
END;
