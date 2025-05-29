IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Move_Pipeline_status]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE  procedure [dbo].[SP_Move_Pipeline_status]
@Pipeline_Id INT =''''
as
begin
select count(*) as leadstatuscount from Tbl_Lead_Personal_Det  LPD
where Candidate_DelStatus = 0
and LPD.LeadStatus_Id IN (SELECT ILM.Lead_Satus_Id FROM tbl_Lead_Status_Maping ILM WHERE Pipeline_Id = @Pipeline_Id)
end
');
END;
