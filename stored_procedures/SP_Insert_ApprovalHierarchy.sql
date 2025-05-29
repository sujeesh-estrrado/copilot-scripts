IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_ApprovalHierarchy]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_ApprovalHierarchy]       
@Name varchar(100),    
@Type varchar(50),    
@Priority bigint                    
                        
as                        
                        
begin     
  
  
IF EXISTS(SELECT Name,Type,Priority FROM Tbl_Approval_Hierarchy Where Name = @Name 
and Type=@Type and Priority=@Priority and delstatus=0 )            
BEGIN            
RAISERROR (''Data Already Exists.'', -- Message text.            
               16, -- Severity.            
               1 -- State.            
               );            
END            
ELSE  
BEGIN                     
           
   insert into  dbo.Tbl_Approval_Hierarchy (Name,Type,Priority,delstatus) values(@Name,@Type,@Priority,0)    
    SELECT SCOPE_IDENTITY()                       
end  
END ');
END;
