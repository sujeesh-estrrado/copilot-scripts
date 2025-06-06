IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Count_Enquiry_List_Counsellor_Lead_new_Adv_Search]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
create procedure [dbo].[SP_Get_Count_Enquiry_List_Counsellor_Lead_new_Adv_Search]   
--'''',''--select--'',''--select--'',''--select--'','''','''',''1'',''--select--'',''--select--'','''',''--select--'' ,'''','''',''1450''             
(                  
                             
@SearchTerm varchar(100),              
@CounselorCampus1 varchar(50) ,              
@EmployeeName varchar(50),              
@Type1 varchar(50),          
@from   varchar(50),          
@to varchar(50),          
 @ActiveStatus varchar(50),  
@Hostel_Req  varchar(50),  
@Scholarship varchar(50),  
@Program varchar(50),  
@feespaid  varchar(50) ,  
@createdby  varchar(100)='''',  
@Marketing_Status varchar(100)='''' ,  
@Employee_Id varchar(100)=''''  
  
)                                                           
AS                                                        
BEGIN                   
SET NOCOUNT ON                                      
                  
 IF OBJECT_ID(''#TEMP1'', ''U'') IS NOT NULL                
  DROP TABLE #TEMP1;          
    IF OBJECT_ID(''#TEMP2'', ''U'') IS NOT NULL                
  DROP TABLE #TEMP2;               
    if(@from=@to)            
       begin                       
   
   
SELECT case when SUM(counts) >100 then 100  
else SUM(counts) end as counts--SUM(counts)as counts   
from   
((SELECT  count(distinct  CPD.Candidate_Id)as counts                      
                                     
 FROM Tbl_Candidate_Personal_Det  CPD                                                        
                                         
left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                 
left join                              
dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                               
and   ss.student_semester_current_status=1                                
left JOIN                                     
Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                                     
left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                    
left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                                         
left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                                       
                                
left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                 
                                                     
 left join Tbl_Sponsorship_candidate_mapping SM on CPD.Candidate_Id=SM.candidate_id                                               
                                                    
left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id   
 left join Tbl_Student_status RR on RR.id=CPD.Active  
                                    
                                                     
 left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                         
 left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                      
 LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id  
 left join Tbl_Status_change_by_Marketing HS on CPD.Candidate_Id= HS.Candidate_id                                                      
 LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)                             
    left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id                     
 left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )--and EC.Employee_Status=0  
 left Join (  
 select Candidate_Id, Next_Date from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in  
 (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id  
  
 where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )   
 or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''   
 or LTRIM(RTRIM(CPD.AdharNumber)) like ''''+ LTRIM(RTRIM(@SearchTerm))+''%''         
 or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''   
 or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''   
 or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')   
      
 and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--'' or @CounselorCampus1=''0'')        
 and(CPD.TypeOfStudent=@Type1 or @Type1=''--Select--'')      
 -- and (CPD.CounselorEmployee_id in (select TeamMembers  from Tbl_Counsellor_Teamforming TCT where  TeamLead=@Employee_Id))  
 and (concat(EC.Employee_FName,'' '',EC.Employee_LName)=@EmployeeName or @EmployeeName=''--Select--'')        
 and (convert(datetime,CPD.RegDate,103)>= convert(datetime,@from,120)or @from='''' )    
 and (SM.Sponsorship_Name = @Scholarship or @Scholarship =''--Select--'')    
 and (CPD.Hostel_Required = @Hostel_Req or @Hostel_Req =''--Select--'' or @Hostel_Req =''0'')  
 and (CPD.FeeStatus = @feespaid or @feespaid =''--Select--'' or(CPD.FeeStatus is null and @feespaid=''Not Paid''))  
 and (D.Course_Code= @Program or D.Department_Name=@Program or @Program =''--Select--'')    
  and(@createdby=''--Select--'' or EnrollBy=@createdby)     
 and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')   
 or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''submited''))  
 or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or   
 (@ActiveStatus=''4'' and CPD.ApplicationStatus=''Old Data'')))  
  Union all  
    
  (SELECT  count(distinct  CPD.Candidate_Id)as counts                      
                                     
FROM Tbl_Student_NewApplication CPD                                                        
Inner join Tbl_Candidate_Personal_Det  PD on PD.Candidate_Id=CPD.Candidate_Id                                                 
                                         
 left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                 
 left join                              
 dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                               
 and   ss.student_semester_current_status=1                                
 left JOIN                                     
 Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                                     
 left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                    
 left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                                         
 left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id     
 left join Tbl_Status_change_by_Marketing HS on CPD.Candidate_Id= HS.Candidate_id                                      
                                
 left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                 
                                                     
  left join Tbl_Sponsorship_candidate_mapping SM on CPD.Candidate_Id=SM.candidate_id                                               
                                                    
 left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id   
 left join Tbl_Student_status RR on RR.id=CPD.Active  
  
                                    
                                                     
 left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                         
 left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                      
 LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                                       
 LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)                             
    left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id                     
 left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )--and EC.Employee_Status=0  
 left Join (  
 select Candidate_Id, Next_Date from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in  
 (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id  
  
 where  (concat(LTRIM(RTRIM((PD.Candidate_Fname))),'' '',LTRIM(RTRIM((PD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )   
 or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''   
 or LTRIM(RTRIM(PD.AdharNumber)) like ''''+ LTRIM(RTRIM(@SearchTerm))+''%''         
 or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''   
 or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''   
 or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')   
    --and (CPD.CounselorEmployee_id in (select TeamMembers  from Tbl_Counsellor_Teamforming TCT where  TeamLead=@Employee_Id))  
 and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--'' or @CounselorCampus1=''0'')        
 and(PD.TypeOfStudent=@Type1 or @Type1=''--Select--'')        
 and (concat(EC.Employee_FName,'' '',EC.Employee_LName)=@EmployeeName or @EmployeeName=''--Select--'')        
 and (convert(datetime,CPD.RegDate,103)>= convert(datetime,@from,120)or @from='''' )    
 and (SM.Sponsorship_Name = @Scholarship or @Scholarship =''--Select--'')    
 and (PD.Hostel_Required = @Hostel_Req or @Hostel_Req =''--Select--'' or @Hostel_Req =''0'')  
 and (CPD.FeeStatus = @feespaid or @feespaid =''--Select--'' or(CPD.FeeStatus is null and @feespaid=''Not Paid''))  
 and (D.Course_Code= @Program or D.Department_Name=@Program or @Program =''--Select--'')    
  and(@createdby=''--Select--'' or CPD.EnrollBy=@createdby)     
 and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')   
 or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''submited''))  
 or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or   
 (@Marketing_Status=''4'' and CPD.ApplicationStatus=''Old Data'')))    
)as counts  
  
end         
else        
begin   
SELECT case when SUM(counts) >100 then 100  
else SUM(counts) end as counts--SUM(counts)as counts   
from (       
 (SELECT count(distinct  CPD.Candidate_Id)as counts                                      
                                         
 FROM Tbl_Student_NewApplication CPD  
  
Inner join Tbl_Candidate_Personal_Det  PD on PD.Candidate_Id=CPD.Candidate_Id                                                 
                                         
 left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                 
 left join                              
 dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                               
 and   ss.student_semester_current_status=1                                
 left JOIN                                     
 Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                                     
 left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                    
 left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                                         
 left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id     
 left join Tbl_Status_change_by_Marketing HS on CPD.Candidate_Id= HS.Candidate_id                                      
                                
 left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                      
                                                     
  left join Tbl_Sponsorship_candidate_mapping SM on CPD.Candidate_Id=SM.candidate_id                                               
                                                    
 left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id   
 left join Tbl_Student_status RR on RR.id=CPD.Active  
  
                                    
                                                     
 left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                         
 left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                      
 LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                                       
 LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)                             
    left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id                     
 left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )--and EC.Employee_Status=0  
 left Join (  
 select Candidate_Id, Next_Date from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in  
 (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where(Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id  
  
 where  (concat(LTRIM(RTRIM((PD.Candidate_Fname))),'' '',LTRIM(RTRIM((PD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )   
 or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''   
 or LTRIM(RTRIM(PD.AdharNumber)) like ''''+ LTRIM(RTRIM(@SearchTerm))+''%''         
 or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''   
 or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''   
 or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')   
      
 and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--'' or @CounselorCampus1=''0'')        
 and(PD.TypeOfStudent=@Type1 or @Type1=''--Select--'')        
 and (concat(EC.Employee_FName,'' '',EC.Employee_LName)=@EmployeeName or @EmployeeName=''--Select--'')        
 and (convert(datetime,CPD.RegDate,103)>= convert(datetime,@from,120)or @from='''' )    
 and (SM.Sponsorship_Name = @Scholarship or @Scholarship =''--Select--'')    
  --and (CPD.CounselorEmployee_id in (select TeamMembers  from Tbl_Counsellor_Teamforming TCT where  TeamLead=@Employee_Id))  
 and (PD.Hostel_Required = @Hostel_Req or @Hostel_Req =''--Select--'' or @Hostel_Req =''0'')  
 and (CPD.FeeStatus = @feespaid or @feespaid =''--Select--'' or(CPD.FeeStatus is null and @feespaid=''Not Paid''))  
 and (D.Course_Code= @Program or D.Department_Name=@Program or @Program =''--Select--'')    
  and(@createdby=''--Select--'' or CPD.EnrollBy=@createdby)     
 and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')   
 or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''submited''))  
 or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or   
 (@ActiveStatus=''4'' and CPD.ApplicationStatus=''Old Data'')))      
  
 Union all  
   
 (SELECT count(distinct  CPD.Candidate_Id)as counts                                      
                                         
FROM Tbl_Candidate_Personal_Det  CPD                                                        
           
 left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                 
 left join                              
 dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                               
 and   ss.student_semester_current_status=1                                
 left JOIN                                     
 Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                                     
 left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                    
 left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                                         
 left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id   
 left join Tbl_Status_change_by_Marketing HS on CPD.Candidate_Id= HS.Candidate_id         
 left join Tbl_Student_status RR on RR.id=CPD.Active                                 
                                
 left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                 
                                                     
  left join Tbl_Sponsorship_candidate_mapping SM on CPD.Candidate_Id=SM.candidate_id                                                   
                                                    
 left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id                                     
                                                     
 left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                         
 left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                      
 LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                                       
 LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)                             
    left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id                     
 left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id)-- and EC.Employee_Status=0  
 left Join (  
 select Candidate_Id, Next_Date from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in  
 (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id  
 where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )   
 or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''   
 or LTRIM(RTRIM(CPD.AdharNumber)) like ''''+ LTRIM(RTRIM(@SearchTerm))+''%''         
 or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''   
 or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''   
 or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')   
       
 and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--''or @CounselorCampus1=''0'')        
 and(CPD.TypeOfStudent=@Type1 or @Type1=''--Select--'')     
  and(@createdby=''--Select--'' or EnrollBy=@createdby)        
 and (concat(EC.Employee_FName,'' '',EC.Employee_LName)=@EmployeeName or @EmployeeName=''--Select--'')  
 and (SM.Sponsorship_Name = @Scholarship or @Scholarship =''--Select--'')     
  --and (CPD.CounselorEmployee_id in (select TeamMembers  from Tbl_Counsellor_Teamforming TCT where  TeamLead=@Employee_Id))  
  
 and (CPD.Hostel_Required = @Hostel_Req or @Hostel_Req =''--Select--'' or @Hostel_Req =''0'')   
 and (CPD.FeeStatus = @feespaid or @feespaid =''--Select--'' or(CPD.FeeStatus is null and @feespaid=''Not Paid''))  
 and (D.Course_Code= @Program or D.Department_Name=@Program or @Program =''--Select--'')  
 and  
 (((CONVERT(date,RegDate)) >= @from and (CONVERT(date,RegDate)) < DATEADD(day,1,@to))  
 OR (@from IS NULL AND @to IS NULL)  
 OR (@from IS NULL AND (CONVERT(date,RegDate)) < DATEADD(day,1,@to))  
 OR (@to IS NULL AND (CONVERT(date,RegDate)) >= @from)  
 or @from='''' or @to='''')       
    
 and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')   
 or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''submited''))  
 or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or   
 (@ActiveStatus=''4'' and CPD.ApplicationStatus=''Old Data''))  
  and(CPD.Active= @Marketing_Status or @Marketing_Status=''0'') )  
              
)as counts  
end       
                 
             
       End 
    ')
END
