IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Getparam_Agent_Listing_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Getparam_Agent_Listing_Report] 
(
@Flag bigint=0,
@category bigint=0,
@AgentId bigint=0
)
AS      
BEGIN 
 
 if(@Flag=1)
 begin
 select Distinct 
case when @category=0 then ''All'' else C.Category_Name end as Category_Name,
case when @AgentId=0 then ''All'' else Agent_Name end as Agent_Name from [dbo].[Tbl_Agent] A
Inner join Tbl_Agent_Category C on  C.Category_Id=A.Agent_Category_Id
Where (Agent_Category_Id=@category  or @category =0) and (A.Agent_Id=@AgentId or @AgentId= 0)
end
END
');
END;