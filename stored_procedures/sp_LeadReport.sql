IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_LeadReport]') 
    AND type = N'P'
)
BEGIN
    EXEC('
   create procedure [dbo].[sp_LeadReport]
as
begin

    SELECT distinct 
    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,
    CPD.AdharNumber as ICPassport,
    CC.Candidate_Mob1 as MobileNumber,                                          
    CC.Candidate_Email as EmailID  ,
    CPD.Scolorship_Remark as Remark    ,
    CPD.Source_name,
    case when                   
    CPD.ApplicationStatus=''Lead'' Then ''Lead'' when CPD.ApplicationStatus=''rejected'' Then CONCAT( ''Rejected due to :'',CPD.Reject_remark) else ''Moved To Enquiry'' end  as ApplicationStatus,                                                          
    CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                          
    RegDate as RegDatetime,                                         
    CPD.TypeOfStudent,
    FULD.Respond_Type,
    FULD.Followup_Date
    --,FULD.Followup_time


    ----CPD.ApplicationStage as Stage,                    
    ----CPD.Source_name as  SourceofInformation  
    --CC.Candidate_idNo as IdentificationNumber ,                                                                  
                                                                            
    --CC.Candidate_ContAddress as Address,    
                                                               
    FROM Tbl_Lead_Personal_Det  CPD                                                                              
                                                     
    left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                       
    inner join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id     
    left join Tbl_FollowUpLead_Detail  FULD on (FULD.Candidate_Id = CPD.Candidate_Id and Follow_Up_Detail_Id in (select MAX(Follow_Up_Detail_Id) from Tbl_FollowUpLead_Detail group by Candidate_Id))
end
    ');
END;
