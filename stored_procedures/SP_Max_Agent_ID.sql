IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Max_Agent_ID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Max_Agent_ID]     
As
Begin
select isnull(max(Agent_ID),0) as Agent_ID from Tbl_Agent 
End');
END