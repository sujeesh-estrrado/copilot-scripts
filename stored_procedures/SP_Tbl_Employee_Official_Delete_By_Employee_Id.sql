IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Employee_Official_Delete_By_Employee_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Tbl_Employee_Official_Delete_By_Employee_Id](
@Employee_Id bigint
)

as

begin

Delete from dbo.Tbl_Employee_Official where Employee_Id=@Employee_Id

end

    ')
END
