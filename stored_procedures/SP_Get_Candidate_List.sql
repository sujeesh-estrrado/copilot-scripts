IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Candidate_List]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Get_Candidate_List] --''approved'',1,100,0,0,0,''990518812612'',0  
(  
@status varchar(50),  
@CurrentPage int=null,  
@pagesize bigint null,  
@organization_id bigint=0,   
@intake_id bigint=0,  
@Department_id bigint=0,  
@searchkeyword varchar(500)='''',  
@flag bigint=0,
@from date ,
@to date,
@TypeOfStudent varchar(20)='''',
@CamsysStatus varchar(10) ='''',
@counselorId bigint=0,

@FacultyId NVARCHAR(MAX), 
@ProgrammeId NVARCHAR(MAX), 
@IntakeId NVARCHAR(MAX) 


)                                          
AS
BEGIN    
  DECLARE @FacultyTable TABLE (FacultyId INT);
DECLARE @ProgrammeTable TABLE (ProgrammeId INT);
DECLARE @IntakeTable TABLE (IntakeId INT);
 
IF @FacultyId <> ''0'' AND @FacultyId <> ''''
BEGIN
    INSERT INTO @FacultyTable (FacultyId)
    SELECT value FROM dbo.SplitStringFunction(@FacultyId, '','');
END
ELSE
BEGIN
    INSERT INTO @FacultyTable (FacultyId)
    SELECT DISTINCT Course_Level_Id FROM Tbl_Course_Level;
END
 
IF @ProgrammeId <> ''0'' AND @ProgrammeId <> ''''
BEGIN
    INSERT INTO @ProgrammeTable (ProgrammeId)
    SELECT value FROM dbo.SplitStringFunction(@ProgrammeId, '','');
END
ELSE
BEGIN 
    INSERT INTO @ProgrammeTable (ProgrammeId)
    SELECT DISTINCT Department_Id FROM Tbl_Department;  
END
 
IF @IntakeId <> ''0'' AND @IntakeId <> ''''
BEGIN
    INSERT INTO @IntakeTable (IntakeId)
    SELECT value FROM dbo.SplitStringFunction(@IntakeId, '','');
END
ELSE
BEGIN

    INSERT INTO @IntakeTable (IntakeId)
    SELECT DISTINCT Duration_Period_Id FROM Tbl_Course_Duration_PeriodDetails; 
  END 
  
if(@flag=0)    
begin     
(  
( SELECT  distinct CPD.Candidate_Id as ID
--,SG.BloodGroup
,CPD.IDMatrixNo,CPD.Candidate_Gender,CPD.IdentificationNo,                                    
 concat( CPD.Candidate_Fname,'' '',CPD.Candidate_Lname) as CandidateName, (convert(date,RegDate,105)) as RegDate,RegDate as RegDatetime,                    
 CPD.Candidate_Fname,CPD.AdharNumber, CPD.TypeOfStudent, CPD.Status,                                                  
  CPD.Candidate_Dob as DOB,                                          
  CPD.New_Admission_Id as AdmnID,  
  (case when CPD.Candidate_Id in (select Tbl_Delete_Request.candidate_id from Tbl_Delete_Request left join Tbl_Candidate_Personal_Det CPDd on CPDd.candidate_id=Tbl_Delete_Request.candidate_id where delete_status=0 ) then ''Rejection Approval Pending'' 
  else IL.Interview_status end) as ApplicationStatus,    
--ISNULL(ISNULL(IL.Interview_status, CPD.ApplicationStatus), CPD.ApplicationStatus) AS ApplicationStatus,
                   
 CC.Candidate_idNo as IdentificationNumber ,                              
                                        
  CC.Candidate_ContAddress as Address,                                            
  CC.Candidate_Mob1 as MobileNumber,                                          
  CC.Candidate_Email as EmailID ,                                  
  CCat.Course_Category_Id,                      
                                 
  cbd.Batch_Id as BatchID,                                  
                                        
  cbd.Batch_Code as Batch,          
 NA.Batch_Id,         
              im.Batch_Code as masterintake,                  
 case when  NA.Batch_Id=0 then ''Unspecified'' else (select cbd.Batch_Code from Tbl_Course_Batch_Duration cbd where          
 cbd.Batch_Id=NA.Batch_Id)  end  as Batch_Code,          
        
                                        
  --(Case when SR.UserId IS NULL  Then ''''                                        
  --Else Isnull(E. Employee_FName,''Admin'') END) as UserName,                                        
                                          
  NA.Course_Level_Id as [LevelID],CL.Course_Level_Name as [LevelName],                                          
  NA.Course_Category_Id as CategoryID,CCat.Course_Category_Name as [Category],                                   
                                       
  NA.Department_Id as DepartmentID,                                
                              
                                
 case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where          
 D.Department_Id=NA.Department_Id)  end  as Department           
          
                                                               
 FROM Tbl_Candidate_Personal_Det  CPD                                          
                           
 left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id    
 left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id     
 left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id   
 left join Tbl_IntakeMaster im on im.id=cbd.intakemasterid                    
 --left join dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id and SS.Student_Semester_Delete_Status=0 and ss.student_semester_current_status=1                  
 --left JOIN Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                       
-- left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id            
     
 --left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                         
                                   
 left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id              
                                       
 left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id           
 left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                        
 --LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                         
 --LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)               
                   
 --left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id  
 
LEFT JOIN Tbl_Interview_Schedule_Log IL ON IL.Candidate_Id = CPD.Candidate_Id
 

                                            
 where CPD.Candidate_DelStatus=0   
 and (CPD.Campus= @organization_id or @organization_id=''0'' or  @organization_id=0)  
 and (NA.Department_Id= @Department_id  or @Department_id=''0'' or @Department_id=0)  
 and (im.id= @intake_id or @intake_id=''0'' or @intake_id=0)  

 and((concat([Candidate_Fname],'' '',Candidate_Lname) like  ''%''+ @searchkeyword +''%'')   
     or ([Candidate_Lname] like  ''%''+ @searchkeyword +''%'')    
     or([AdharNumber] like ''%''+ @searchkeyword +''%'' )  
     or (IDMatrixNo like ''%''+ @searchkeyword +''%'' )   
     or (CPD.IdentificationNo like ''%''+ @searchkeyword +''%'' )   
     or(CPD.[Candidate_Id] like ''%''+ @searchkeyword +''%'' )   
     or concat(Candidate_Fname,'''',Candidate_Lname) like concat(''%'',@searchkeyword ,''%'')  
     or @searchkeyword='''')  and (convert(datetime,CPD.RegDate,103)>= convert(datetime,@from,120)or @from='''' ) 
 and  
 (CPD.Active_Status=''Active''or CPD.Active_Status=''ACTIVE'' ) and (CPD.ApplicationStatus=@status or @status is null) and CPD.ApplicationStatus is not null  
 AND (CPD.TypeOfStudent = @TypeOfStudent OR @TypeOfStudent = ''0'')
 )  
 
-- Union all  
   
-- (  
-- SELECT  distinct NP.Candidate_Id as ID,SG.BloodGroup,  
--  NP.IDMatrixNo,CPD.Candidate_Gender,CPD.IdentificationNo,                                    
-- concat( CPD.Candidate_Fname,'' '',CPD.Candidate_Lname) as CandidateName,                                     
-- CPD.Candidate_Fname,CPD.AdharNumber, CPD.TypeOfStudent, NP.Active_Status as Status,                                                  
--  CPD.Candidate_Dob as DOB,                                          
--  NP.New_Admission_Id as AdmnID,
--(case when CPD.Candidate_Id in (select Tbl_Delete_Request.candidate_id from Tbl_Delete_Request left join Tbl_Candidate_Personal_Det CPDd on CPDd.candidate_id=Tbl_Delete_Request.candidate_id where delete_status=0 ) then ''Rejection Approval Pending'' else 
  
  
  
  
  
  
-- IL.Interview_status end) as ApplicationStatus,         
--   --ISNULL(ISNULL(IL.Interview_status, NP.ApplicationStatus), NP.ApplicationStatus) AS ApplicationStatus,
                 
-- CC.Candidate_idNo as IdentificationNumber ,                              
                                        
--  CC.Candidate_ContAddress as Address,                                            
--  CC.Candidate_Mob1 as MobileNumber,                                          
--  CC.Candidate_Email as EmailID ,                                  
--  CCat.Course_Category_Id,                      
                                 
--  cbd.Batch_Id as BatchID,                                  
                                        
--  cbd.Batch_Code as Batch,          
-- NA.Batch_Id,         
--           im.Batch_Code as masterintake,                      
-- case when  NA.Batch_Id=0 then ''Unspecified'' else (select cbd.Batch_Code from Tbl_Course_Batch_Duration cbd where          
-- cbd.Batch_Id=NA.Batch_Id)  end  as Batch_Code,          
        
                                        
--  (Case when SR.UserId IS NULL  Then ''''                                        
--  Else Isnull(E. Employee_FName,''Admin'') END) as UserName,                                        
                                          
--  NA.Course_Level_Id as [LevelID],CL.Course_Level_Name as [LevelName],                                          
--  NA.Course_Category_Id as CategoryID,CCat.Course_Category_Name as [Category],                                   
               
--  NA.Department_Id as DepartmentID,                                
                              
                                
-- case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where          
-- D.Department_Id=NA.Department_Id)  end  as Department           
          
                                                               
-- FROM Tbl_Student_NewApplication NP   
-- inner join Tbl_Candidate_Personal_Det  CPD on NP.Candidate_Id=CPD.Candidate_Id                                         
                           
-- left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
-- left join tbl_New_Admission NA On NA.New_Admission_Id=NP.New_Admission_Id   
-- left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id  
-- left join Tbl_IntakeMaster im on im.id=cbd.intakemasterid     
               
-- left join dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                 
--      and   ss.student_semester_current_status=1                  
-- left JOIN Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                       
-- left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id            
    
        
-- left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                         
                    
                                   
                                      
-- left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id              
                                       
-- left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id           
-- left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                                               
-- LEFT JOIN Tbl_Student_Registration SR on NP.Candidate_Id = SR.Candidate_Id                                         
-- LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)               
                   
-- left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = NP.Candidate_Id   

-- LEFT JOIN Tbl_Interview_Schedule_Log IL ON IL.Candidate_Id = NP.Candidate_Id

             
-- where NP.Candidate_DelStatus=0   
--  and (NP.Campus= @organization_id or @organization_id=''0'' or  @organization_id=0)  
--  and (NA.Department_Id= @Department_id  or @Department_id=''0'' or @Department_id=0)  
--  and (NA.Batch_Id= @intake_id or @intake_id=''0'' or @intake_id=0)  
    
--  and((concat([Candidate_Fname],'' '',Candidate_Lname) like  ''%''+ @searchkeyword +''%'')   
--      or ([Candidate_Lname] like  ''%''+ @searchkeyword +''%'')    
--      or([AdharNumber] like ''%''+ @searchkeyword +''%'' )  
--      or (NP.IDMatrixNo like ''%''+ @searchkeyword +''%'' )   
--      or (CPD.IdentificationNo like ''%''+ @searchkeyword +''%'' )   
--      or(NP.[Candidate_Id] like ''%''+ @searchkeyword +''%'' )   
--      or concat(Candidate_Fname,'''',Candidate_Lname) like concat(''%'',@searchkeyword ,''%'')  
--      or @searchkeyword='''')  
--  and  
--  (NP.Active_Status=''Active''or NP.Active_Status=''ACTIVE'' ) and (NP.ApplicationStatus=@status or @status is null) and NP.ApplicationStatus is not null  
-- )  )  
-- order by   cpd.Candidate_Id desc
-- -- concat( CPD.Candidate_Fname,'' '',CPD.Candidate_Lname)  
--  OFFSET @PageSize * (@CurrentPage - 1) ROWS  
--  FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);                 
  )end 
  
  if(@flag=3)    
begin     
(  
( SELECT  distinct CPD.Candidate_Id as ID,SG.BloodGroup, CPD.IDMatrixNo,CPD.Candidate_Gender,CPD.IdentificationNo,                                    
 concat( CPD.Candidate_Fname,'' '',CPD.Candidate_Lname) as CandidateName,                                     
 CPD.Candidate_Fname,CPD.AdharNumber, CPD.TypeOfStudent, CPD.Status,                                                  
  CPD.Candidate_Dob as DOB,                                          
  CPD.New_Admission_Id as AdmnID,  
  (case when CPD.Candidate_Id in (select Tbl_Delete_Request.candidate_id from Tbl_Delete_Request left join Tbl_Candidate_Personal_Det CPDd on CPDd.candidate_id=Tbl_Delete_Request.candidate_id where delete_status=0 ) then ''Rejection Approval Pending'' else 
  
  
  
  
  
  
 IL.Interview_status end) as ApplicationStatus,    
--ISNULL(ISNULL(IL.Interview_status, CPD.ApplicationStatus), CPD.ApplicationStatus) AS ApplicationStatus,


                    
 CC.Candidate_idNo as IdentificationNumber ,                              
                                        
  CC.Candidate_ContAddress as Address,                                            
  CC.Candidate_Mob1 as MobileNumber,                                          
  CC.Candidate_Email as EmailID ,                                  
  CCat.Course_Category_Id,                      
                                 
  cbd.Batch_Id as BatchID,                                  
                                        
  cbd.Batch_Code as Batch,          
 NA.Batch_Id,         
              im.Batch_Code as masterintake,                  
 case when  NA.Batch_Id=0 then ''Unspecified'' else (select cbd.Batch_Code from Tbl_Course_Batch_Duration cbd where          
 cbd.Batch_Id=NA.Batch_Id)  end  as Batch_Code,          
        
                                        
  (Case when SR.UserId IS NULL  Then ''''                                        
  Else Isnull(E. Employee_FName,''Admin'') END) as UserName,                                        
                                          
  NA.Course_Level_Id as [LevelID],CL.Course_Level_Name as [LevelName],                                          
  NA.Course_Category_Id as CategoryID,CCat.Course_Category_Name as [Category],                                   
                                       
  NA.Department_Id as DepartmentID,                                
                              
                                
 case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where          
 D.Department_Id=NA.Department_Id)  end  as Department           
          
                                                               
 FROM Tbl_Candidate_Personal_Det  CPD                                          
                           
 left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id    
 left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id     
 left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id   
 left join Tbl_IntakeMaster im on im.id=cbd.intakemasterid                    
 left join  dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                 
 and   ss.student_semester_current_status=1                  
 left JOIN                       
 Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                       
 left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id            
     
 left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                         
                                   
 left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id              
                                       
 left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id           
 left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                        
 LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                         
 LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)               
                   
 left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id  
 
LEFT JOIN Tbl_Interview_Schedule_Log IL ON IL.Candidate_Id = CPD.Candidate_Id


                                            
 where CPD.Candidate_DelStatus=0   
 and (CPD.Campus= @organization_id or @organization_id=''0'' or  @organization_id=0)  
 and (NA.Department_Id= @Department_id  or @Department_id=''0'' or @Department_id=0)  
 and (im.id= @intake_id or @intake_id=''0'' or @intake_id=0)  
 
        AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
        AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
    AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
 and((concat([Candidate_Fname],'' '',Candidate_Lname) like  ''%''+ @searchkeyword +''%'')   
     or ([Candidate_Lname] like  ''%''+ @searchkeyword +''%'')    
     or([AdharNumber] like ''%''+ @searchkeyword +''%'' )  
     or (IDMatrixNo like ''%''+ @searchkeyword +''%'' )   
     or (CPD.IdentificationNo like ''%''+ @searchkeyword +''%'' )   
     or(CPD.[Candidate_Id] like ''%''+ @searchkeyword +''%'' )   
     or concat(Candidate_Fname,'''',Candidate_Lname) like concat(''%'',@searchkeyword ,''%'')  
     or @searchkeyword='''')  
 and  
 (CPD.Active_Status=''Active''or CPD.Active_Status=''ACTIVE'' ) and (CPD.ApplicationStatus=@status or @status is null) and CPD.ApplicationStatus is not null  
 --AND (CPD.TypeOfStudent = @TypeOfStudent OR @TypeOfStudent = ''0'')
 )  )end 

 if(@flag=1)     
 begin  
  
select count(*)as count from(    
                                     
(SELECT  distinct CPD.Candidate_Id  
          
                                                               
FROM Tbl_Candidate_Personal_Det  CPD                                          
                           
left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                   
left join         
dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                 
and   ss.student_semester_current_status=1       
left JOIN                       
Tbl_Course_Duration_Mapping cdm  on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                       
left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id            
left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id        
left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                   
                  
left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                   
                                       
left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id              
                                       
left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id           
left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                        
--inner join Tbl_Department D On D.Department_Id=NA.Department_Id                                          
LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                         
LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)               
                   
left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id      
             
                                          
                                            
where CPD.Candidate_DelStatus=0   
and (CPD.Campus= @organization_id or @organization_id=''0'' or  @organization_id=0)  
and (NA.Department_Id= @Department_id  or @Department_id=''0'' or @Department_id=0)  
and (NA.Batch_Id= @intake_id or @intake_id=''0'' or @intake_id=0) 

        AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
        AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
    AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
--and (CPD.active=@studentStatus  or @studentStatus=''0'')  
and((concat([Candidate_Fname],'' '',Candidate_Lname) like  ''%''+ @searchkeyword +''%'')   
    or ([Candidate_Lname] like  ''%''+ @searchkeyword +''%'')    
    or([AdharNumber] like ''%''+ @searchkeyword +''%'' )  
    or (IDMatrixNo like ''%''+ @searchkeyword +''%'' )   
    or (CPD.IdentificationNo like ''%''+ @searchkeyword +''%'' )   
    or(CPD.[Candidate_Id] like ''%''+ @searchkeyword +''%'' )   
    or concat(Candidate_Fname,'''',Candidate_Lname) like concat(''%'',@searchkeyword ,''%'')  
    or @searchkeyword='''')  
and  
(CPD.Active_Status=''Active''or CPD.Active_Status=''ACTIVE'' ) and (CPD.ApplicationStatus=@status or @status is null) and CPD.ApplicationStatus is not null   
  
)  
  
Union all  
  
(SELECT  distinct NP.Candidate_Id  
          
                                                               
FROM Tbl_Student_NewApplication NP   
 inner join Tbl_Candidate_Personal_Det  CPD on NP.Candidate_Id=CPD.Candidate_Id                                                  
                           
left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                   
left join                   
dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                 
and   ss.student_semester_current_status=1                  
left JOIN                       
Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                       
left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id            
left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id        
left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                   
                  
left join tbl_New_Admission NA On NA.New_Admission_Id=NP.New_Admission_Id                                   
                                       
left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id              
                                       
left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id           
left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                        
--inner join Tbl_Department D On D.Department_Id=NA.Department_Id                                          
LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id      
LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)               
                   
left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id      
             
                  
                                            
where NP.Candidate_DelStatus=0   
and (NP.Campus= @organization_id or @organization_id=''0'' or  @organization_id=0)  
and (NA.Department_Id= @Department_id  or @Department_id=''0'' or @Department_id=0)  
and (NA.Batch_Id= @intake_id or @intake_id=''0'' or @intake_id=0)  
--and (CPD.active=@studentStatus  or @studentStatus=''0'')  
and((concat([Candidate_Fname],'' '',Candidate_Lname) like  ''%''+ @searchkeyword +''%'')   
    or ([Candidate_Lname] like  ''%''+ @searchkeyword +''%'')    
    or([AdharNumber] like ''%''+ @searchkeyword +''%'' )  
    or (NP.IDMatrixNo like ''%''+ @searchkeyword +''%'' )   
    or(NP.[Candidate_Id] like ''%''+ @searchkeyword +''%'' )  
    or (CPD.IdentificationNo like ''%''+ @searchkeyword +''%'' )    
    or concat(Candidate_Fname,'''',Candidate_Lname) like concat(''%'',@searchkeyword ,''%'')  
    or @searchkeyword='''')  
  
        AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
        AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
    AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
and  

(NP.Active_Status=''Active''or NP.Active_Status=''ACTIVE'' ) and (NP.ApplicationStatus=@status or @status is null)   
and NP.ApplicationStatus is not null   
  
))as c  
  
 end   
 if @flag=2
 begin
 
-- (  
--( SELECT  distinct CPD.Candidate_Id as ID,SG.BloodGroup, CPD.IDMatrixNo,CPD.Candidate_Gender,CPD.IdentificationNo,                                    
-- concat( CPD.Candidate_Fname,'' '',CPD.Candidate_Lname) as CandidateName,                                     
-- CPD.Candidate_Fname,CPD.AdharNumber, CPD.TypeOfStudent, CPD.Status,                                                  
--  CPD.Candidate_Dob as DOB,                                          
--  CPD.New_Admission_Id as AdmnID,  
--  (case when CPD.Candidate_Id in (select Tbl_Delete_Request.candidate_id from Tbl_Delete_Request left join Tbl_Candidate_Personal_Det CPDd on CPDd.candidate_id=Tbl_Delete_Request.candidate_id where delete_status=0 ) then ''Rejection Approval Pending'' else 
  
  
  
  
  
  
-- IL.Interview_status end) as ApplicationStatus,    
----ISNULL(ISNULL(IL.Interview_status, CPD.ApplicationStatus), CPD.ApplicationStatus) AS ApplicationStatus,


                    
-- CC.Candidate_idNo as IdentificationNumber ,                              
                                        
--  CC.Candidate_ContAddress as Address,                                            
--  CC.Candidate_Mob1 as MobileNumber,                                          
--  CC.Candidate_Email as EmailID ,                                  
--  CCat.Course_Category_Id,                      
                                 
--  cbd.Batch_Id as BatchID,                                  
                                        
--  cbd.Batch_Code as Batch,          
-- NA.Batch_Id,         
--              im.Batch_Code as masterintake,                  
-- case when  NA.Batch_Id=0 then ''Unspecified'' else (select cbd.Batch_Code from Tbl_Course_Batch_Duration cbd where          
-- cbd.Batch_Id=NA.Batch_Id)  end  as Batch_Code,          
        
                                        
--  (Case when SR.UserId IS NULL  Then ''''                                        
--  Else Isnull(E. Employee_FName,''Admin'') END) as UserName,                                        
                                          
--  NA.Course_Level_Id as [LevelID],CL.Course_Level_Name as [LevelName],                                          
--  NA.Course_Category_Id as CategoryID,CCat.Course_Category_Name as [Category],                                   
                                       
--  NA.Department_Id as DepartmentID,                                
                              
                                
-- case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where          
-- D.Department_Id=NA.Department_Id)  end  as Department           
          
                                                               
-- FROM Tbl_Candidate_Personal_Det  CPD                                          
                           
-- left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id    
-- left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                    
--left JOIN Tbl_Course_Duration_PeriodDetails cdp ON NA.Batch_Id=cdp.Batch_Id 
-- left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id   
-- left join Tbl_IntakeMaster im on im.id=cbd.intakemasterid                    
-- left join  dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                 
-- and   ss.student_semester_current_status=1                  
-- left JOIN                       
-- Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                         
     
-- left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                         
                                   
-- left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id              
                                       
-- left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id           
-- left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                        
-- LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                         
-- LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)               
                   
-- left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id  
 
--LEFT JOIN Tbl_Interview_Schedule_Log IL ON IL.Candidate_Id = CPD.Candidate_Id


                                            
-- where CPD.Candidate_DelStatus=0   
-- and (CPD.Campus= @organization_id or @organization_id=''0'' or  @organization_id=0)  
-- and (CPD.CounselorEmployee_id=@counselorId or @counselorId=0)
-- and (NA.Department_Id= @Department_id  or @Department_id=''0'' or @Department_id=0)  
-- and (im.id= @intake_id or @intake_id=''0'' or @intake_id=0)  
--    AND (
--        (EXISTS (SELECT 1 FROM @FacultyTable) AND NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)) 
--        OR ISNULL(@FacultyId, '''') = '''' OR @FacultyId = ''0''
--    )
--    AND (
--        (EXISTS (SELECT 1 FROM @ProgrammeTable) AND NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)) 
--        OR ISNULL(@ProgrammeId, '''') = '''' OR @ProgrammeId = ''0''
--    )
--    AND (
--        (EXISTS (SELECT 1 FROM @IntakeTable) AND CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable)) 
--        OR ISNULL(@IntakeId, '''') = '''' OR @IntakeId = ''0''
--    )
-- and((concat([Candidate_Fname],'' '',Candidate_Lname) like  ''%''+ @searchkeyword +''%'')   
--     or ([Candidate_Lname] like  ''%''+ @searchkeyword +''%'')    
--     or([AdharNumber] like ''%''+ @searchkeyword +''%'' )  
--     or (IDMatrixNo like ''%''+ @searchkeyword +''%'' )   
--     or (CPD.IdentificationNo like ''%''+ @searchkeyword +''%'' )   
--     or(CPD.[Candidate_Id] like ''%''+ @searchkeyword +''%'' )   
--     or concat(Candidate_Fname,'''',Candidate_Lname) like concat(''%'',@searchkeyword ,''%'')  
--     or @searchkeyword='''')  
-- and  
-- (CPD.Active_Status=''Approved''or CPD.Active_Status= ''Approved'' )   AND (LOWER(CPD.ApplicationStatus) = LOWER(@status) OR @status IS NULL)
-- and CPD.ApplicationStatus is not null  
-- --AND (CPD.TypeOfStudent = @TypeOfStudent OR @TypeOfStudent = ''0'')
-- )  )

SELECT DISTINCT 
    CPD.Candidate_Id AS ID, 
    SG.BloodGroup, 
    CPD.IDMatrixNo,
    CPD.Candidate_Gender,
    CPD.IdentificationNo,                                  
    CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS CandidateName,                                     
    CPD.Candidate_Fname,
    CPD.AdharNumber, 
    CPD.TypeOfStudent, 
    CPD.Status,                                                  
    CPD.Candidate_Dob AS DOB,                                          
    CPD.New_Admission_Id AS AdmnID,  
    CASE 
        WHEN CPD.Candidate_Id IN (SELECT Tbl_Delete_Request.candidate_id 
                                  FROM Tbl_Delete_Request 
                                  LEFT JOIN Tbl_Candidate_Personal_Det CPDd 
                                  ON CPDd.candidate_id = Tbl_Delete_Request.candidate_id 
                                  WHERE delete_status = 0) 
        THEN ''Rejection Approval Pending'' 
        ELSE IL.Interview_status 
    END AS ApplicationStatus,    
    CC.Candidate_idNo AS IdentificationNumber,                              
    CC.Candidate_ContAddress AS Address,                                            
    CC.Candidate_Mob1 AS MobileNumber,                                          
    CC.Candidate_Email AS EmailID,                                   
    CCat.Course_Category_Id,                      
    cbd.Batch_Id AS BatchID,                                  
    cbd.Batch_Code AS Batch,          
    NA.Batch_Id,         
    im.Batch_Code AS masterintake,                  
    CASE 
        WHEN NA.Batch_Id = 0 THEN ''Unspecified'' 
        ELSE (SELECT cbd.Batch_Code 
              FROM Tbl_Course_Batch_Duration cbd 
              WHERE cbd.Batch_Id = NA.Batch_Id)  
    END AS Batch_Code,          
    CASE 
        WHEN SR.UserId IS NULL THEN ''''                                      
        ELSE ISNULL(E.Employee_FName, ''Admin'') 
    END AS UserName,                                        
    NA.Course_Level_Id AS [LevelID],
    CL.Course_Level_Name AS [LevelName],                                          
    NA.Course_Category_Id AS CategoryID,
    CCat.Course_Category_Name AS [Category],                                   
    NA.Department_Id AS DepartmentID,                                
    CASE 
        WHEN NA.Department_Id = 0 THEN ''Unspecified'' 
        ELSE (SELECT D.Department_Name 
              FROM Tbl_Department D 
              WHERE D.Department_Id = NA.Department_Id)  
    END AS Department           
FROM Tbl_Candidate_Personal_Det CPD                                          
LEFT JOIN Tbl_Candidate_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id    
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id                    
LEFT JOIN Tbl_Course_Duration_PeriodDetails cdp ON NA.Batch_Id = cdp.Batch_Id 
LEFT JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = NA.Batch_Id   
LEFT JOIN Tbl_IntakeMaster im ON im.id = cbd.intakemasterid                    
LEFT JOIN dbo.Tbl_Student_Semester SS 
    ON SS.Candidate_Id = CPD.Candidate_Id  
    AND SS.Student_Semester_Delete_Status = 0                  
    AND SS.student_semester_current_status = 1                  
LEFT JOIN Tbl_Course_Duration_Mapping cdm   
    ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id                         
LEFT JOIN Tbl_Course_Semester cs ON cs.Semester_Id = cdp.Semester_Id                         
LEFT JOIN Tbl_Course_Level CL ON CL.Course_Level_Id = NA.Course_Level_Id              
LEFT JOIN Tbl_Course_Category CCat ON CCat.Course_Category_Id = NA.Course_Category_Id           
LEFT JOIN Tbl_Department D ON NA.Department_Id = D.Department_Id                                      
LEFT JOIN Tbl_Student_Registration SR ON CPD.Candidate_Id = SR.Candidate_Id                                         
LEFT JOIN Tbl_Employee E 
    ON E.Employee_Id = (SELECT Employee_Id FROM dbo.Tbl_Employee_User WHERE [User_Id] = SR.UserId)               
LEFT JOIN dbo.Tbl_Student_Health_General SG ON SG.StudentId = CPD.Candidate_Id  
LEFT JOIN Tbl_Interview_Schedule_Log IL ON IL.Candidate_Id = CPD.Candidate_Id
WHERE CPD.Candidate_DelStatus = 0   
AND (CPD.Campus = @organization_id OR @organization_id = ''0'' OR @organization_id = 0)  
AND (CPD.CounselorEmployee_id = @counselorId OR @counselorId = 0)
AND (NA.Department_Id = @Department_id OR @Department_id = ''0'' OR @Department_id = 0)  
AND (im.id = @intake_id OR @intake_id = ''0'' OR @intake_id = 0)  
AND (
    (EXISTS (SELECT 1 FROM @FacultyTable) AND NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)) 
    OR ISNULL(@FacultyId, '''') = '''' OR @FacultyId = ''0''
)
AND (
    (EXISTS (SELECT 1 FROM @ProgrammeTable) AND NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)) 
    OR ISNULL(@ProgrammeId, '''') = '''' OR @ProgrammeId = ''0''
)
AND (
    (EXISTS (SELECT 1 FROM @IntakeTable) AND CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable)) 
    OR ISNULL(@IntakeId, '''') = '''' OR @IntakeId = ''0''
)
AND (
    CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @searchkeyword + ''%''   
    OR CPD.Candidate_Lname LIKE ''%'' + @searchkeyword + ''%''    
    OR CPD.AdharNumber LIKE ''%'' + @searchkeyword + ''%''  
    OR CPD.IDMatrixNo LIKE ''%'' + @searchkeyword + ''%''   
    OR CPD.IdentificationNo LIKE ''%'' + @searchkeyword + ''%''   
    OR CPD.Candidate_Id LIKE ''%'' + @searchkeyword + ''%''   
    OR CONCAT(CPD.Candidate_Fname, '''', CPD.Candidate_Lname) LIKE CONCAT(''%'', @searchkeyword, ''%'')  
    OR @searchkeyword = ''''
)  
AND (
    CPD.Active_Status = ''Active'' 
    OR CPD.Active_Status = ''ACTIVE''
)   
AND (LOWER(CPD.ApplicationStatus) = LOWER(@status) OR @status IS NULL)
AND CPD.ApplicationStatus IS NOT NULL;

 end
 if @flag=4
 begin
 select count(*)as count from(    
                                     
(SELECT  distinct CPD.Candidate_Id  
          
                                                               
FROM Tbl_Candidate_Personal_Det  CPD                                          
                           
left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                   
left join         
dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                 
and   ss.student_semester_current_status=1       
left JOIN                       
Tbl_Course_Duration_Mapping cdm  on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                       
left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id            
left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id        
left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                   
                  
left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                   
                                      
left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id              
                                       
left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id           
left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                        
--inner join Tbl_Department D On D.Department_Id=NA.Department_Id                                          
LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                         
LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)               
                   
left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id      
             
                                          
                                            
where CPD.Candidate_DelStatus=0   
and (CPD.Campus= @organization_id or @organization_id=''0'' or  @organization_id=0)
and(CPD.CounselorEmployee_id=@counselorId or @counselorId=0)
and (NA.Department_Id= @Department_id  or @Department_id=''0'' or @Department_id=0)  
and (NA.Batch_Id= @intake_id or @intake_id=''0'' or @intake_id=0)  
--and (CPD.active=@studentStatus  or @studentStatus=''0'')  
and((concat([Candidate_Fname],'' '',Candidate_Lname) like  ''%''+ @searchkeyword +''%'')   
    or ([Candidate_Lname] like  ''%''+ @searchkeyword +''%'')    
    or([AdharNumber] like ''%''+ @searchkeyword +''%'' )  
    or (IDMatrixNo like ''%''+ @searchkeyword +''%'' )   
    or (CPD.IdentificationNo like ''%''+ @searchkeyword +''%'' )   
    or(CPD.[Candidate_Id] like ''%''+ @searchkeyword +''%'' )   
    or concat(Candidate_Fname,'''',Candidate_Lname) like concat(''%'',@searchkeyword ,''%'')  
    or @searchkeyword='''')  
and  
(CPD.Active_Status=''Active''or CPD.Active_Status=''ACTIVE'' ) and (CPD.ApplicationStatus=@status or @status is null) and CPD.ApplicationStatus is not null   
  
)  
  
Union all  
  
(SELECT  distinct NP.Candidate_Id  
          
                                                               
FROM Tbl_Student_NewApplication NP   
 inner join Tbl_Candidate_Personal_Det  CPD on NP.Candidate_Id=CPD.Candidate_Id                                                  
                           
left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                   
left join                   
dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                 
and   ss.student_semester_current_status=1                  
left JOIN                       
Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                       
left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id            
left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id        
left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                   
                  
left join tbl_New_Admission NA On NA.New_Admission_Id=NP.New_Admission_Id                                   
                                      
left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id              
                                       
left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id           
left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                        
--inner join Tbl_Department D On D.Department_Id=NA.Department_Id                                          
LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id      
LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)               
                   
left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id      
             
                  
                                            
where NP.Candidate_DelStatus=0   
and (NP.Campus= @organization_id or @organization_id=''0'' or  @organization_id=0)  
and (CPD.CounselorEmployee_id=@counselorId or @counselorId=0)
and (NA.Department_Id= @Department_id  or @Department_id=''0'' or @Department_id=0)  
and (NA.Batch_Id= @intake_id or @intake_id=''0'' or @intake_id=0)  
--and (CPD.active=@studentStatus  or @studentStatus=''0'')  
and((concat([Candidate_Fname],'' '',Candidate_Lname) like  ''%''+ @searchkeyword +''%'')   
    or ([Candidate_Lname] like  ''%''+ @searchkeyword +''%'')    
    or([AdharNumber] like ''%''+ @searchkeyword +''%'' )  
    or (NP.IDMatrixNo like ''%''+ @searchkeyword +''%'' )   
    or(NP.[Candidate_Id] like ''%''+ @searchkeyword +''%'' )  
    or (CPD.IdentificationNo like ''%''+ @searchkeyword +''%'' )    
    or concat(Candidate_Fname,'''',Candidate_Lname) like concat(''%'',@searchkeyword ,''%'')  
    or @searchkeyword='''')  
and  
(NP.Active_Status=''Active''or NP.Active_Status=''ACTIVE'' ) and (NP.ApplicationStatus=@status or @status is null)   
and NP.ApplicationStatus is not null   
  
))as c  
 end
 if @flag=5
 begin
 (  
( SELECT  distinct CPD.Candidate_Id as ID,SG.BloodGroup, CPD.IDMatrixNo,CPD.Candidate_Gender,CPD.IdentificationNo,                                    
 concat( CPD.Candidate_Fname,'' '',CPD.Candidate_Lname) as CandidateName,                                     
 CPD.Candidate_Fname,CPD.AdharNumber, CPD.TypeOfStudent, CPD.Status,                                                  
  CPD.Candidate_Dob as DOB,                                          
  CPD.New_Admission_Id as AdmnID,  
  (case when CPD.Candidate_Id in (select Tbl_Delete_Request.candidate_id from Tbl_Delete_Request left join Tbl_Candidate_Personal_Det CPDd on CPDd.candidate_id=Tbl_Delete_Request.candidate_id where delete_status=0 ) then ''Rejection Approval Pending'' else 
  
  
  
  
  
  
 IL.Interview_status end) as ApplicationStatus,    
--ISNULL(ISNULL(IL.Interview_status, CPD.ApplicationStatus), CPD.ApplicationStatus) AS ApplicationStatus,


                    
 CC.Candidate_idNo as IdentificationNumber ,                              
                                        
  CC.Candidate_ContAddress as Address,                                            
  CC.Candidate_Mob1 as MobileNumber,                                          
  CC.Candidate_Email as EmailID ,                                  
  CCat.Course_Category_Id,                      
                                 
  cbd.Batch_Id as BatchID,                                  
                                        
  cbd.Batch_Code as Batch,          
 NA.Batch_Id,         
              im.Batch_Code as masterintake,                  
 case when  NA.Batch_Id=0 then ''Unspecified'' else (select cbd.Batch_Code from Tbl_Course_Batch_Duration cbd where          
 cbd.Batch_Id=NA.Batch_Id)  end  as Batch_Code,          
        
                                        
  (Case when SR.UserId IS NULL  Then ''''                                        
  Else Isnull(E. Employee_FName,''Admin'') END) as UserName,                                        
                                          
  NA.Course_Level_Id as [LevelID],CL.Course_Level_Name as [LevelName],                                          
  NA.Course_Category_Id as CategoryID,CCat.Course_Category_Name as [Category],                                   
                                       
  NA.Department_Id as DepartmentID,                                
                              
                                
 case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where          
 D.Department_Id=NA.Department_Id)  end  as Department           
          
                                                               
 FROM Tbl_Candidate_Personal_Det  CPD                                          
                           
 left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id    
 left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id     
 left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id   
 left join Tbl_IntakeMaster im on im.id=cbd.intakemasterid                    
 left join  dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                 
 and   ss.student_semester_current_status=1                  
 left JOIN                       
 Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                       
 left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id            
     
 left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                         
                                   
 left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id              
                                       
 left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id           
 left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                        
 LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                         
 LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)               
                   
 left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id  
 
LEFT JOIN Tbl_Interview_Schedule_Log IL ON IL.Candidate_Id = CPD.Candidate_Id


                                            
 where CPD.Candidate_DelStatus=0   
 and (CPD.Campus= @organization_id or @organization_id=''0'' or  @organization_id=0)  
 and (CPD.Agent_ID=@counselorId or @counselorId=0)
 and (NA.Department_Id= @Department_id  or @Department_id=''0'' or @Department_id=0)  
 and (im.id= @intake_id or @intake_id=''0'' or @intake_id=0)  
 
        AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
        AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
    AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
 and((concat([Candidate_Fname],'' '',Candidate_Lname) like  ''%''+ @searchkeyword +''%'')   
     or ([Candidate_Lname] like  ''%''+ @searchkeyword +''%'')    
     or([AdharNumber] like ''%''+ @searchkeyword +''%'' )  
     or (IDMatrixNo like ''%''+ @searchkeyword +''%'' )   
     or (CPD.IdentificationNo like ''%''+ @searchkeyword +''%'' )   
     or(CPD.[Candidate_Id] like ''%''+ @searchkeyword +''%'' )   
     or concat(Candidate_Fname,'''',Candidate_Lname) like concat(''%'',@searchkeyword ,''%'')  
     or @searchkeyword='''')  
 and  
 (CPD.Active_Status=''Active''or CPD.Active_Status=''ACTIVE'' ) and (CPD.ApplicationStatus=@status or @status is null) and CPD.ApplicationStatus is not null  
 --AND (CPD.TypeOfStudent = @TypeOfStudent OR @TypeOfStudent = ''0'')
 )  )
 end
 if @flag=6
 begin
 select count(*)as count from(    
                                     
(SELECT  distinct CPD.Candidate_Id  
          
                                                               
FROM Tbl_Candidate_Personal_Det  CPD                                          
                           
left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                   
left join         
dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                 
and   ss.student_semester_current_status=1       
left JOIN                       
Tbl_Course_Duration_Mapping cdm  on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                       
left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id            
left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id        
left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                   
                  
left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                   
                                      
left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id              
                                       
left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id           
left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                        
--inner join Tbl_Department D On D.Department_Id=NA.Department_Id                                          
LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                         
LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)               
                   
left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id      
             
                                          
                                            
where CPD.Candidate_DelStatus=0   
and (CPD.Campus= @organization_id or @organization_id=''0'' or  @organization_id=0)
and(CPD.Agent_ID=@counselorId or @counselorId=0)
and (NA.Department_Id= @Department_id  or @Department_id=''0'' or @Department_id=0)  
and (NA.Batch_Id= @intake_id or @intake_id=''0'' or @intake_id=0)  
--and (CPD.active=@studentStatus  or @studentStatus=''0'')  
and((concat([Candidate_Fname],'' '',Candidate_Lname) like  ''%''+ @searchkeyword +''%'')   
    or ([Candidate_Lname] like  ''%''+ @searchkeyword +''%'')    
    or([AdharNumber] like ''%''+ @searchkeyword +''%'' )  
    or (IDMatrixNo like ''%''+ @searchkeyword +''%'' )   
    or (CPD.IdentificationNo like ''%''+ @searchkeyword +''%'' )   
    or(CPD.[Candidate_Id] like ''%''+ @searchkeyword +''%'' )   
    or concat(Candidate_Fname,'''',Candidate_Lname) like concat(''%'',@searchkeyword ,''%'')  
    or @searchkeyword='''')  
and  
(CPD.Active_Status=''Active''or CPD.Active_Status=''ACTIVE'' ) and (CPD.ApplicationStatus=@status or @status is null) and CPD.ApplicationStatus is not null   
  
)  
  
Union all  
  
(SELECT  distinct NP.Candidate_Id  
          
                                                               
FROM Tbl_Student_NewApplication NP   
 inner join Tbl_Candidate_Personal_Det  CPD on NP.Candidate_Id=CPD.Candidate_Id                                                  
                           
left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                   
left join                   
dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                 
and   ss.student_semester_current_status=1                  
left JOIN                       
Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                       
left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id            
left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id        
left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                   
                  
left join tbl_New_Admission NA On NA.New_Admission_Id=NP.New_Admission_Id                                   
                                      
left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id              
                                       
left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id           
left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                        
--inner join Tbl_Department D On D.Department_Id=NA.Department_Id                                          
LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id      
LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)               
                   
left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id      
             
                  
                                            
where NP.Candidate_DelStatus=0   
and (NP.Campus= @organization_id or @organization_id=''0'' or  @organization_id=0)  
and (CPD.Agent_ID=@counselorId or @counselorId=0)
and (NA.Department_Id= @Department_id  or @Department_id=''0'' or @Department_id=0)  
and (NA.Batch_Id= @intake_id or @intake_id=''0'' or @intake_id=0)  
--and (CPD.active=@studentStatus  or @studentStatus=''0'')  
and((concat([Candidate_Fname],'' '',Candidate_Lname) like  ''%''+ @searchkeyword +''%'')   
    or ([Candidate_Lname] like  ''%''+ @searchkeyword +''%'')    
    or([AdharNumber] like ''%''+ @searchkeyword +''%'' )  
    or (NP.IDMatrixNo like ''%''+ @searchkeyword +''%'' )   
    or(NP.[Candidate_Id] like ''%''+ @searchkeyword +''%'' )  
    or (CPD.IdentificationNo like ''%''+ @searchkeyword +''%'' )    
    or concat(Candidate_Fname,'''',Candidate_Lname) like concat(''%'',@searchkeyword ,''%'')  
    or @searchkeyword='''')  
and  
(NP.Active_Status=''Active''or NP.Active_Status=''ACTIVE'' ) and (NP.ApplicationStatus=@status or @status is null)   
and NP.ApplicationStatus is not null   
  
))as c  
 end



 IF (@flag=300)
 BEGIN
 SELECT DISTINCT 
    CPD.Candidate_Id AS ID, 
    SG.BloodGroup, 
    CPD.IDMatrixNo,
    CPD.Candidate_Gender,
    CPD.IdentificationNo,                                  
    CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS CandidateName,                                     
    CPD.Candidate_Fname,
    CPD.AdharNumber, 
    CPD.TypeOfStudent, 
    CPD.Status,                                                  
    CPD.Candidate_Dob AS DOB,                                          
    CPD.New_Admission_Id AS AdmnID,  
    CASE 
        WHEN CPD.Candidate_Id IN (SELECT Tbl_Delete_Request.candidate_id 
                                  FROM Tbl_Delete_Request 
                                  LEFT JOIN Tbl_Candidate_Personal_Det CPDd 
                                  ON CPDd.candidate_id = Tbl_Delete_Request.candidate_id 
                                  WHERE delete_status = 0) 
        THEN ''Rejection Approval Pending'' 
        ELSE IL.Interview_status 
    END AS ApplicationStatus,    
    CC.Candidate_idNo AS IdentificationNumber,                              
    CC.Candidate_ContAddress AS Address,                                            
    CC.Candidate_Mob1 AS MobileNumber,                                          
    CC.Candidate_Email AS EmailID,                                   
    CCat.Course_Category_Id,                      
    cbd.Batch_Id AS BatchID,                                  
    cbd.Batch_Code AS Batch,          
    NA.Batch_Id,         
    im.Batch_Code AS masterintake,                  
    CASE 
        WHEN NA.Batch_Id = 0 THEN ''Unspecified'' 
        ELSE (SELECT cbd.Batch_Code 
              FROM Tbl_Course_Batch_Duration cbd 
              WHERE cbd.Batch_Id = NA.Batch_Id)  
    END AS Batch_Code,          
    CASE 
        WHEN SR.UserId IS NULL THEN ''''                                      
        ELSE ISNULL(E.Employee_FName, ''Admin'') 
    END AS UserName,                                        
    NA.Course_Level_Id AS [LevelID],
    CL.Course_Level_Name AS [LevelName],                                          
    NA.Course_Category_Id AS CategoryID,
    CCat.Course_Category_Name AS [Category],                                   
    NA.Department_Id AS DepartmentID,                                
    CASE 
        WHEN NA.Department_Id = 0 THEN ''Unspecified'' 
        ELSE (SELECT D.Department_Name 
              FROM Tbl_Department D 
              WHERE D.Department_Id = NA.Department_Id)  
    END AS Department           
FROM Tbl_Candidate_Personal_Det CPD                                          
LEFT JOIN Tbl_Candidate_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id    
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id                    
LEFT JOIN Tbl_Course_Duration_PeriodDetails cdp ON NA.Batch_Id = cdp.Batch_Id 
LEFT JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = NA.Batch_Id   
LEFT JOIN Tbl_IntakeMaster im ON im.id = cbd.intakemasterid                    
LEFT JOIN dbo.Tbl_Student_Semester SS 
    ON SS.Candidate_Id = CPD.Candidate_Id  
    AND SS.Student_Semester_Delete_Status = 0                  
    AND SS.student_semester_current_status = 1                  
LEFT JOIN Tbl_Course_Duration_Mapping cdm   
    ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id                         
LEFT JOIN Tbl_Course_Semester cs ON cs.Semester_Id = cdp.Semester_Id                         
LEFT JOIN Tbl_Course_Level CL ON CL.Course_Level_Id = NA.Course_Level_Id              
LEFT JOIN Tbl_Course_Category CCat ON CCat.Course_Category_Id = NA.Course_Category_Id           
LEFT JOIN Tbl_Department D ON NA.Department_Id = D.Department_Id                                      
LEFT JOIN Tbl_Student_Registration SR ON CPD.Candidate_Id = SR.Candidate_Id                                         
LEFT JOIN Tbl_Employee E 
    ON E.Employee_Id = (SELECT Employee_Id FROM dbo.Tbl_Employee_User WHERE [User_Id] = SR.UserId)               
LEFT JOIN dbo.Tbl_Student_Health_General SG ON SG.StudentId = CPD.Candidate_Id  
LEFT JOIN Tbl_Interview_Schedule_Log IL ON IL.Candidate_Id = CPD.Candidate_Id
WHERE CPD.Candidate_DelStatus = 0                                      
   AND CPD.ApplicationStatus = ''approved'' 
           AND CPD.Active_Status IN (''Active'', ''ACTIVE'')
          AND (
            NOT EXISTS (SELECT 1 FROM @FacultyTable)
            OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
        )
        AND (
            NOT EXISTS (SELECT 1 FROM @ProgrammeTable)
            OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
        )
        
 END

 IF (@flag=305)
 BEGIN
 SELECT DISTINCT 
    CPD.Candidate_Id AS ID, 
    SG.BloodGroup, 
    CPD.IDMatrixNo,
    CPD.Candidate_Gender,
    CPD.IdentificationNo,                                  
    CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS CandidateName,                                     
    CPD.Candidate_Fname,
    CPD.AdharNumber, 
    CPD.TypeOfStudent, 
    CPD.Status,                                                  
    CPD.Candidate_Dob AS DOB,                                          
    CPD.New_Admission_Id AS AdmnID,  
    CASE 
        WHEN CPD.Candidate_Id IN (SELECT Tbl_Delete_Request.candidate_id 
                                  FROM Tbl_Delete_Request 
                                  LEFT JOIN Tbl_Candidate_Personal_Det CPDd 
                                  ON CPDd.candidate_id = Tbl_Delete_Request.candidate_id 
                                  WHERE delete_status = 0) 
        THEN ''Rejection Approval Pending'' 
        ELSE IL.Interview_status 
    END AS ApplicationStatus,    
    CC.Candidate_idNo AS IdentificationNumber,                              
    CC.Candidate_ContAddress AS Address,                                            
    CC.Candidate_Mob1 AS MobileNumber,                                          
    CC.Candidate_Email AS EmailID,                                   
    CCat.Course_Category_Id,                      
    cbd.Batch_Id AS BatchID,                                  
    cbd.Batch_Code AS Batch,          
    NA.Batch_Id,         
    im.Batch_Code AS masterintake,                  
    CASE 
        WHEN NA.Batch_Id = 0 THEN ''Unspecified'' 
        ELSE (SELECT cbd.Batch_Code 
              FROM Tbl_Course_Batch_Duration cbd 
              WHERE cbd.Batch_Id = NA.Batch_Id)  
    END AS Batch_Code,          
    CASE 
        WHEN SR.UserId IS NULL THEN ''''                                      
        ELSE ISNULL(E.Employee_FName, ''Admin'') 
    END AS UserName,                                        
    NA.Course_Level_Id AS [LevelID],
    CL.Course_Level_Name AS [LevelName],                                          
    NA.Course_Category_Id AS CategoryID,
    CCat.Course_Category_Name AS [Category],                                   
    NA.Department_Id AS DepartmentID,                                
    CASE 
        WHEN NA.Department_Id = 0 THEN ''Unspecified'' 
        ELSE (SELECT D.Department_Name 
              FROM Tbl_Department D 
              WHERE D.Department_Id = NA.Department_Id)  
    END AS Department           
FROM Tbl_Candidate_Personal_Det CPD                                          
LEFT JOIN Tbl_Candidate_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id    
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id                    
LEFT JOIN Tbl_Course_Duration_PeriodDetails cdp ON NA.Batch_Id = cdp.Batch_Id 
LEFT JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = NA.Batch_Id   
LEFT JOIN Tbl_IntakeMaster im ON im.id = cbd.intakemasterid                    
LEFT JOIN dbo.Tbl_Student_Semester SS 
    ON SS.Candidate_Id = CPD.Candidate_Id  
    AND SS.Student_Semester_Delete_Status = 0                  
    AND SS.student_semester_current_status = 1                  
LEFT JOIN Tbl_Course_Duration_Mapping cdm   
    ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id                         
LEFT JOIN Tbl_Course_Semester cs ON cs.Semester_Id = cdp.Semester_Id                         
LEFT JOIN Tbl_Course_Level CL ON CL.Course_Level_Id = NA.Course_Level_Id              
LEFT JOIN Tbl_Course_Category CCat ON CCat.Course_Category_Id = NA.Course_Category_Id           
LEFT JOIN Tbl_Department D ON NA.Department_Id = D.Department_Id                                      
LEFT JOIN Tbl_Student_Registration SR ON CPD.Candidate_Id = SR.Candidate_Id                                         
LEFT JOIN Tbl_Employee E 
    ON E.Employee_Id = (SELECT Employee_Id FROM dbo.Tbl_Employee_User WHERE [User_Id] = SR.UserId)               
LEFT JOIN dbo.Tbl_Student_Health_General SG ON SG.StudentId = CPD.Candidate_Id  
LEFT JOIN Tbl_Interview_Schedule_Log IL ON IL.Candidate_Id = CPD.Candidate_Id
WHERE CPD.Candidate_DelStatus = 0                                      
  AND CPD.ApplicationStatus = ''Preactivated''
          AND (
            NOT EXISTS (SELECT 1 FROM @FacultyTable)
            OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
        )
        AND (
            NOT EXISTS (SELECT 1 FROM @ProgrammeTable)
            OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
        )
         
 END
                                END
    ')
END
