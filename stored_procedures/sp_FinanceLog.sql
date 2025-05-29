IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_FinanceLog]')
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[sp_FinanceLog]
(
@flag bigint =0,
@EmployeeID bigint =0,
@RefID bigint =0,
@Description varchar(max)=''''
)
as
begin
    if(@flag = 1)
    begin
        INSERT INTO [dbo].[tbl_FinanceActionLog]
           ([EmployeeID]
           ,[Description]
           ,[RefID]
           ,[LDate])
        VALUES
           (@EmployeeID ,@Description,@RefID,GETDATE())
    end

end
    ')
END
