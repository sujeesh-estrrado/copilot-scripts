IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Move_interest_level_status]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE  procedure [dbo].[SP_Move_interest_level_status]
@interestlevelID INT =''''
as
begin
select count(*) as leadstatuscount from Tbl_Lead_Personal_Det  LPD
where Candidate_DelStatus = 0
and LPD.LeadStatus_Id IN (SELECT ILM.Lead_Status_Id FROM Tbl_Interest_level_Mapping ILM WHERE InterestLevel_ID = @interestlevelID)
end
'
)
END;
