IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Delete_Employee_Education]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Delete_Employee_Education]
(
    
    @Employee_Education_Id Bigint
    
)
As

Begin

        

        update Tbl_Employee_Education
        Set Employee_Education_Status=1
        where Employee_Education_Id=@Employee_Education_Id

     
End
    ')
END
