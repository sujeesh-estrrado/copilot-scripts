IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Employee_IdNo]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Update_Employee_IdNo]
(
@Employee_Id bigint,
@Employee_Id_Card_No varchar(20)
)
as

begin

Update dbo.Tbl_Employee set Employee_Id_Card_No=@Employee_Id_Card_No where Employee_Id=@Employee_Id

end
    ')
END
