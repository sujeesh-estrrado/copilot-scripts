IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_AddEventEmployee]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_AddEventEmployee]
@allemp bigint,
@SelectedEventId bigint,
@SelectedDepartmentid varchar(150),
@SelectedRoleid varchar(150),
@SelectedEmployeeid varchar(150)
as
begin 
insert into Tbl_EventEmployee(Event_Id,AllEmployee,Department_Id,Role_Id,CreatedDate,DelStatus,SelectedEmp_Id)
values(@SelectedEventId,@allemp,@SelectedDepartmentid,@SelectedRoleid,GETDATE(),0,@SelectedEmployeeid)
end

   ')
END;
