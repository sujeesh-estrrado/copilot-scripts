IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_insert_ActionLog]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE Procedure [dbo].[Sp_insert_ActionLog](@employeeid bigint,@des varchar(max),@refid bigint,@type varchar(max))
as
begin
insert into tbl_EmployeeActionLog(EmployeeID,Description,RefID,Type,LDate) values(@employeeid,@des,@refid,@type,getdate())
end
    ');
END;
