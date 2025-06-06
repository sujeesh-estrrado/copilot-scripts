IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Delete_Employee]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Delete_Employee]
(
    @Employee_Id Bigint,
    @Employee_Education_Id Bigint,
    @Employee_Experience_Id Bigint,
    @Employee_Official_Id Bigint
)
As

Begin

        update Tbl_Employee
        Set Employee_Status=1
        where Employee_Id=@Employee_Id

        update Tbl_Employee_Education
        Set Employee_Education_Status=1
        where Employee_Education_Id=@Employee_Education_Id

        update Tbl_Employee_Experience
        Set Employee_Experience_Status=1
        where Employee_Experience_id=@Employee_Experience_Id

        update Tbl_Employee_Official
        Set Employee_Official_Status=1
        where Employee_Official_Id=@Employee_Official_Id
End

    ')
END
