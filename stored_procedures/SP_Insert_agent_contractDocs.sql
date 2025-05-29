IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_agent_contractDocs]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_agent_contractDocs] -- 2  
 (
 @Agent_Id bigint ,
 @Document_Path varchar(MAX)
 )   
AS    
BEGIN    
insert into Tbl_Agent_Documents    
(Agent_Id,Document_Path,Created_Date,Delete_status)values(@Agent_Id,@Document_Path,getdate(),0)   
END
    ');
END;
