IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Delete_Employee_Experience]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Delete_Employee_Experience]
(
    
    @Employee_Experience_Id Bigint
    
)
As

Begin

    

        update Tbl_Employee_Experience
        Set Employee_Experience_Status=1
        where Employee_Experience_id=@Employee_Experience_Id

       
End
    ')
END
