IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_DELETE_AgentDocs]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_DELETE_AgentDocs]   
 @Document_Id bigint 
AS  
BEGIN  
Update  Tbl_Agent_Documents set Delete_status=1 WHERE Document_Id=@Document_Id
END
    ')
END
