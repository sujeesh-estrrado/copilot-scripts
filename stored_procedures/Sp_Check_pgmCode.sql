IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Check_pgmCode]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[Sp_Check_pgmCode](@pgmcode varchar(200)='''',@departmentid bigint=0)
as
begin
select * from Tbl_Department where Course_Code=@pgmcode and Delete_Status=0 and Department_Id!=@departmentid;
end
    ')
END
