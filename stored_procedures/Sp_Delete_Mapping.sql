IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Delete_Mapping]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_Delete_Mapping]  
(@Depid bigint)

  
As  
Begin  
  
Delete from  Tbl_Course_Department where Department_Id=@Depid  and Course_Department_Status=0
  
End
    ')
END
