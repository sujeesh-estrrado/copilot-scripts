IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Count_Admin_Enquiry_List_new]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Count_Admin_Enquiry_List_new]  --1,10,'''',''Active'',1635,0,0,0 
  (                         
@CurrentPage int=1 ,                                   
@PageSize int=10 ,                                
@SearchTerm varchar(100)='''',                   
@ActiveStatus varchar(50)=''Active'',  
@Agent_ID1 bigint =0,  
@organization_id bigint=0,   
@intake_id bigint=0,  
@Department_id bigint=0               
)                                                         
AS                                                      
BEGIN                     
SET NOCOUNT ON                                                                              
             
    IF OBJECT_ID(''#TEMP1'', ''U'') IS NOT NULL                
  DROP TABLE #TEMP1;       
    IF OBJECT_ID(''#TEMP2'', ''U'') IS NOT NULL                
  DROP TABLE #TEMP2;               
          
begin    
if(@ActiveStatus=''To_RAISE_INVOICE'')  
begin  
  
SELECT count(CPD.Candidate_Id) as counts                    
     
FROM Tbl_Candidate_Personal_Det  CPD                                                        
           
inner join Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                 
left join dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                               
and   ss.student_semester_current_status=1                                
left JOIN Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                                     
left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                    
left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                                         
left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                                                                    
left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                                                                                                                                    
 
left join Tbl_Commission_Settings s on  s.Agent_ID=CPD.Agent_ID and NA.Department_Id=s.Course_Id and NA.Batch_Id=s.IntakeId  
left join   student_bill  b on CPD.Candidate_Id=b.studentid  
  
left join Tbl_Organzations  Org on CPD.campus=Org.Organization_Id  
           
left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id                                                                                       
left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                         
left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                         
LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                     
LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)                             
left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id                     
left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id and EC.Employee_Status=0)  
where  (CPD.Campus= @organization_id or @organization_id=''0'')  
and (NA.Department_Id= @Department_id  or @Department_id=''0'')  
and (NA.Batch_Id= @intake_id or @intake_id=''0'')AND    
(CPD.Candidate_Fname+'' ''+CPD.Candidate_Lname like ''''+ @SearchTerm +''%''         
or D.Department_Name like ''''+@SearchTerm+''%'' or CPD.AdharNumber like ''''+ @SearchTerm+''%''        
or CCat.Course_Category_Name like  ''''+ @SearchTerm +''%'' or CC.Candidate_Mob1 like  ''''+ @SearchTerm +''%'' or CC.Candidate_Email like  ''''+ @SearchTerm +''%'' or @SearchTerm='''')                
and(CPD.Active_Status=''Active'' and CPD.Agent_ID != 0) and   (Invoice_Status IS NULL or Invoice_Status='''')   
      

  
       

         

  
end  
else  
begin      
SELECT  count(distinct CPD.Candidate_Id) as counts  
     
FROM Tbl_Candidate_Personal_Det  CPD                                                        
           
inner join Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                 
left join dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                               
and   ss.student_semester_current_status=1                                
left JOIN Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                                     
left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                    
left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id 
LEFT OUTER JOIN dbo.Tbl_IntakeMaster AS INM ON INM.id = cbd.IntakeMasterID            
left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                                                                    
left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                                                                                                                                     
 
left join Tbl_Commission_Settings s on  s.Agent_ID=CPD.Agent_ID and NA.Department_Id=s.Course_Id and NA.Batch_Id=s.IntakeId  
left join   student_bill  b on CPD.Candidate_Id=b.studentid  
  
left join Tbl_Organzations  Org on CPD.campus=Org.Organization_Id    
          
left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id                                                                                       
left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                         
left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                         
LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                                       
LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)                             
left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id                     
left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id and EC.Employee_Status=0)  


where  (CPD.Campus= @organization_id or @organization_id=''0'')  
and (NA.Department_Id= @Department_id  or @Department_id=''0'')  
and (cbd.IntakeMasterID = @intake_id or @intake_id=''0'')AND    
(CPD.Candidate_Fname+'' ''+CPD.Candidate_Lname like ''''+ @SearchTerm +''%''         
or D.Department_Name like ''''+@SearchTerm+''%'' or CPD.AdharNumber like ''''+ @SearchTerm+''%''        
or CCat.Course_Category_Name like  ''''+ @SearchTerm +''%'' or CC.Candidate_Mob1 like  ''''+ @SearchTerm +''%'' or CC.Candidate_Email like  ''''+ @SearchTerm +''%'' or @SearchTerm='''')                
and(CPD.Active_Status=@ActiveStatus and CPD.Agent_ID  != 0) and   (Invoice_Status IS NULL or Invoice_Status='''')       
and (INM.id= @intake_id or @intake_id=''0'')  
 
                                                                        
end                        
   end              
             
       End
    ')
END
