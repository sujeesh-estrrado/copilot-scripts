IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Delete_Employeenew]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Delete_Employeenew]
(
    @Employee_Id Bigint
    
)
As

Begin

        update Tbl_Employee
        Set Employee_Status=1
        where Employee_Id=@Employee_Id


End

    ')
END
