IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Department_General_Return]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_Department_General_Return]  
(  
@Department_Id bigint,  
@Product_Id bigint,  
@Current_Department_Stock float,  
@RQuantity float
)  
  
as  
  
  
begin  
  
insert into dbo.Tbl_Department_General_Return values(@Department_Id,@Product_Id,@Current_Department_Stock,@RQuantity,getdate())  
  
end');
END;
