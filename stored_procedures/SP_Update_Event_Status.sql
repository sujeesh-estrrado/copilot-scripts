IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Event_Status]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       
CREATE procedure [dbo].[SP_Update_Event_Status]    
(    
  @Event_Id  bigint,       
  @flag bigint=0    
     
     
)    
As    
    
Begin 

 if(@flag=1)      
 begin      
 delete from  Tbl_Event_Staff where EventID=@Event_Id      
      
      
 end  

 if(@flag=2)      
 begin      
 Update Tbl_Marketing_ManangerApproval set Approval_Status=0 where Event_id=@Event_Id      
 Update Tbl_Pso_Approval set Approval_Status=0 where Event_id=@Event_Id      
      
      
 end   
 
 if(@flag=3)      
 begin      
      
      
 delete from Tbl_Particulars_Detailss where Event_ID=@Event_Id      
      
 end 
 end
    ')
END
