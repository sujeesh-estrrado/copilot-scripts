IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Assigned_Room_Delete]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Assigned_Room_Delete]    
   (@Allocation_Id bigint)    
AS    
BEGIN    
 Delete  from  dbo.Tbl_Class_Allocation
 WHERE Allocation_Id=@Allocation_Id    
END

   ')
END;
