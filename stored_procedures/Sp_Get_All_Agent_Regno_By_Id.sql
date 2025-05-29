IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_Agent_Regno_By_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       create procedure [dbo].[Sp_Get_All_Agent_Regno_By_Id] --1      
(
@AgentRegNo varchar(MAX)
)              
              
AS              
BEGIN              
              
select Agent_RegNo from Tbl_Agent
where Agent_RegNo=@AgentRegNo and Delete_Status=0
              
END 





    ');
END;
