IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Delete_Employee_Official]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[Proc_Delete_Employee_Official]
(
    
    @Employee_Official_Id Bigint
)
As

Begin

        

        update Tbl_Employee_Official
        Set Employee_Official_Status=1
        where Employee_Official_Id=@Employee_Official_Id
End
    ')
END
