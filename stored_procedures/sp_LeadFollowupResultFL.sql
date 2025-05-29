IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_LeadFollowupResultFL]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[sp_LeadFollowupResultFL]  
(       
@Fromdate datetime=null,    
@todate datetime=null    
)    
as    
begin    
SELECT distinct CPD.Candidate_Id, CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,
    CPD.AdharNumber,CC.Candidate_Mob1 as MobileNumber,CC.Candidate_Email as EmailID,N.Nationality,
    SUBSTRING((SUBSTRING(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark) )),
        CHARINDEX(''Course Opted :'', (SUBSTRING(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark) ))),
        CHARINDEX('', Nationality:'',(SUBSTRING(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark) ))))as optedProgramme,
    case when CPD.Page_Id=0 Then ''Landing'' when CPD.Page_Id is null then ''Landing'' when CPD.Page_Id=0 then ''Landing'' else (select LandingiURL_Name from Tbl_LandingiURL where LandingiURL_Id=CPD.Page_Id) end 
        as PageName, CPD.Source_name,
    case when CPD.ApplicationStatus=''Lead'' Then ''Lead'' when CPD.ApplicationStatus=''rejected'' Then CONCAT( ''Rejected due to :'',CPD.Reject_remark) else ''Moved To Enquiry'' end  as ApplicationStatus,CPD.Scolorship_Remark,
    CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as CounsellorEmployee,
    (convert(VARCHAR(50),RegDate,111)) as LeadRegDate,  (CONVERT(VARCHAR(10), CAST(RegDate AS TIME), 0)) as LeadRegDatetime, 
    (convert(VARCHAR(50),FD1.Followup_Date,105)) as First_Followup_Date,
    (CONVERT(VARCHAR(10), CAST(FD1.Followup_time AS TIME), 0)) as First_Followup_Time,
    FD1.Remarks First_Followup_Remark,FD1.Respond_Type First_Followup_Respond_Type, 
    (convert(VARCHAR(50),FD.Followup_Date,105)) as Latest_Followup_Date,
    (CONVERT(VARCHAR(10), CAST(FD.Followup_time AS TIME), 0)) as Latest_Followup_Time,
    FD.Remarks Latest_Followup_Remark,FD.Respond_Type Latest_Followup_Respond_Type,
    convert(varchar(20),FD.Next_Date,111) Latest_Next_Followup_Date
FROM Tbl_Lead_Personal_Det  CPD                                
    left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                 
    inner join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id  
    left join Tbl_Nationality N on CPD.Candidate_Nationality=N.Nationality_Id 
    left Join
        (select Candidate_Id, Next_Date,Respond_Type,Followup_Date,Followup_time,Remarks
        from Tbl_FollowUpLead_Detail
        where (Delete_Status=0 or Delete_Status is null)
            and Follow_Up_Detail_Id in
                (select min(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail
                where (Delete_Status=0 or Delete_Status is null)
                group by Candidate_Id)
            and Action_Taken=0) as FD1 on FD1.Candidate_Id=CPD.Candidate_Id
    left Join
        (select Candidate_Id, Next_Date,Respond_Type,Followup_Date,Followup_time,Remarks
        from Tbl_FollowUpLead_Detail
        where (Delete_Status=0 or Delete_Status is null)
            and Follow_Up_Detail_Id in
                (select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail
                where (Delete_Status=0 or Delete_Status is null)
                group by Candidate_Id)
            and Action_Taken=0) as FD on FD.Candidate_Id=CPD.Candidate_Id
where  (((CONVERT(date,CPD.RegDate)) >= @fromdate and (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@todate))     
         OR (@fromdate IS NULL AND @todate IS NULL)    
         OR (@fromdate IS NULL AND (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@todate))    
         OR (@todate IS NULL AND (CONVERT(date,CPD.RegDate)) >= @fromdate)) 
order by LeadRegDate desc,LeadRegdatetime desc

Select Candidate_Id,convert(varchar(20),Followup_Date,111) Followup_Date,Followup_time,[Medium],Remarks,Respond_Type,
    convert(varchar(20),Next_Date,111) Next_Followup_Date,
    CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as CounsellorEmployee
From Tbl_FollowUpLead_Detail fu                      
    inner join Tbl_Employee EC on fu.Counselor_Employee=EC.Employee_Id  
Where (Delete_Status=0 or Delete_Status is null)
    and Candidate_Id in
        (Select Candidate_Id
        From Tbl_Lead_Personal_Det CPD
        Where (((CONVERT(date,CPD.RegDate)) >= @fromdate and (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@todate))     
             OR (@fromdate IS NULL AND @todate IS NULL)    
             OR (@fromdate IS NULL AND (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@todate))    
             OR (@todate IS NULL AND (CONVERT(date,CPD.RegDate)) >= @fromdate))
        )
Order by Candidate_Id desc,Followup_Date,Followup_time
end
');
END;
