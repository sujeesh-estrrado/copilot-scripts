IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Reject_Lead]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Reject_Lead]  
(@candidate_id bigint,  
@status varchar(50),  
@Activestatus varchar(50)=''ACTIVE'',  
@Flag bigint=0  
)  
as  
begin  
if(@Flag=0)  
begin  
 update Tbl_Lead_Personal_Det set   
 ApplicationStatus=@status,Candidate_DelStatus=1, 
Reject_remark=@Activestatus  ,
LeadStatus_Id = (SELECT Lead_Status_Id FROM Tbl_Lead_Status_Master where Lead_Status_Name = ''Rejected'' AND Lead_Status_DelStatus = 0)
    where Candidate_Id=@candidate_id  
end  
 
end
    ')
END
