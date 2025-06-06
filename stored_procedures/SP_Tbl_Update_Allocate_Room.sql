IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Update_Allocate_Room]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Update_Allocate_Room]    
   (@Allocation_Id bigint,  
    @Room_Id bigint    
   ,@Duration_Mapping_Id bigint )    
AS

IF  EXISTS (SELECT Room_Id FROM Tbl_Class_Allocation WHERE        
 Room_Id=@Room_Id and Duration_Mapping_Id=@Duration_Mapping_Id and Allocation_Id<>@Allocation_Id)         
BEGIN          
RAISERROR(''Room already allocated.'',16,1);          
END       
ELSE
    
BEGIN    
UPDATE  dbo.Tbl_Class_Allocation   
SET Room_Id = @Room_Id    
   ,Duration_Mapping_Id = @Duration_Mapping_Id  
where Allocation_Id = @Allocation_Id  
END
   ')
END;
