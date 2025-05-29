IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Candidate_List_new]') 
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE procedure [dbo].[Sp_Get_Candidate_List_new] --'''',1,100,0,0,0,0
(

@SearchKeyWord varchar(max),
@CurrentPage int=null,
@pagesize bigint null,
@organization_id bigint=0, 
@intake_id bigint=0,
@Department_id bigint=0 ,
@Flag bigint=0 

)
As 
BEGIN
    if(@Flag=0)
    begin
        select concat(dbo.Tbl_Candidate_Personal_Det.Candidate_Fname,'' '',dbo.Tbl_Candidate_Personal_Det.Candidate_Lname) AS CandidateName, 
    dbo.Tbl_Candidate_Personal_Det.AdharNumber,
    convert(varchar, dbo.Tbl_Interview_Schedule_Log.Interview_date,103)  as Interview_date, 
    convert(varchar, dbo.Tbl_Interview_Schedule_Log.reschedule_date,103) as reschedule_date ,
    dbo.Tbl_Interview_Schedule_Log.Interview_status, dbo.Tbl_Interview_Schedule_Log.candidate_id as ID, 
    dbo.Tbl_Interview_Schedule_Log.Staff_id, 
    dbo.Tbl_Employee.Employee_FName, 
    dbo.Tbl_Candidate_ContactDetails.Candidate_Mob1 as MobileNumber, 
    dbo.Tbl_Candidate_ContactDetails.Candidate_Email as EmailID,
    (
    case when Tbl_Candidate_Personal_Det.Candidate_Id in 

    (select Tbl_Delete_Request.candidate_id from Tbl_Delete_Request 
     left join Tbl_Candidate_Personal_Det CPDd on CPDd.candidate_id=Tbl_Delete_Request.candidate_id 
     where delete_status=0 ) then ''Rejection Approval Pending'' 

     when NAP.Candidate_Id in 

    (select Tbl_Delete_Request.candidate_id from Tbl_Delete_Request 
     left join Tbl_Student_NewApplication CPDd on CPDd.candidate_id=Tbl_Delete_Request.candidate_id 
     where delete_status=0 ) then ''Rejection Approval Pending''
     
     when NAP.ApplicationStatus is not null then NAP.ApplicationStatus
     else  
    Tbl_Candidate_Personal_Det.ApplicationStatus end) as ApplicationStatus


        FROM    dbo.Tbl_Candidate_Personal_Det 
        left join Tbl_Student_NewApplication NAP on NAP.Candidate_Id= dbo.Tbl_Candidate_Personal_Det.Candidate_Id
        INNER JOIN
                    dbo.Tbl_Interview_Schedule_Log ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Interview_Schedule_Log.candidate_id LEFT OUTER JOIN
                    dbo.Tbl_Candidate_ContactDetails ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Candidate_ContactDetails.Candidate_Id LEFT OUTER JOIN
                    dbo.Tbl_Employee_User left JOIN
                    dbo.Tbl_Employee ON dbo.Tbl_Employee_User.Employee_Id = dbo.Tbl_Employee.Employee_Id ON 
                    dbo.Tbl_Interview_Schedule_Log.Scheduled_by = dbo.Tbl_Employee_User.Employee_Id
                    left join dbo.Tbl_Student_Semester SS on SS.Candidate_Id=Tbl_Candidate_Personal_Det.Candidate_Id   and  SS.Student_Semester_Delete_Status=0 and   ss.student_semester_current_status=1
                    left JOIN Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id  
                    left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id     
                    left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id  
                    LEFT OUTER JOIN dbo.Tbl_IntakeMaster AS INM ON INM.id = cbd.IntakeMasterID 
                    left join tbl_New_Admission NA on NA.New_Admission_Id=dbo.Tbl_Candidate_Personal_Det.New_Admission_Id
                    
        where   ((Interview_status='''' or Interview_status is Null   or Interview_status=''Fail'' or Interview_status=''AB'') and dbo.Tbl_Candidate_Personal_Det.Candidate_DelStatus=0  and(dbo.Tbl_Candidate_Personal_Det.Campus= @organization_id or @organization_id=0)
            and (NA.Department_Id= @Department_id  or @Department_id=0)
            and (NA.Batch_Id= @intake_id or @intake_id=0)and dbo.Tbl_Candidate_Personal_Det.Candidate_DelStatus=0)
             and(dbo.Tbl_Candidate_Personal_Det.Candidate_Id like ''%'' +@SearchKeyWord+ ''%''
                or CONCAT(Tbl_Candidate_Personal_Det.Candidate_Fname,'' '',Tbl_Candidate_Personal_Det.Candidate_Lname) like ''%'' + @SearchKeyWord+ ''%'' 
                or Tbl_Candidate_Personal_Det.AdharNumber like ''%'' +@SearchKeyWord+ ''%''or Interview_date like ''%'' +@SearchKeyWord+ ''%'' 
                or Tbl_Candidate_ContactDetails.Candidate_Email like ''%''+@SearchKeyWord+ ''%'' OR @SearchKeyWord='''')     
                and (INM.id= @intake_id or @intake_id=''0'')     
        order by ID desc   
            OFFSET @pagesize * (@CurrentPage - 1) ROWS
            FETCH NEXT @pagesize ROWS ONLY
    end
    if(@Flag=1)
    begin
     select count(*) as counts 
 
 
     FROM            dbo.Tbl_Candidate_Personal_Det
     left join Tbl_Student_NewApplication NAP on NAP.Candidate_Id= dbo.Tbl_Candidate_Personal_Det.Candidate_Id INNER JOIN
                             dbo.Tbl_Interview_Schedule_Log ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Interview_Schedule_Log.candidate_id LEFT OUTER JOIN
                             dbo.Tbl_Candidate_ContactDetails ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Candidate_ContactDetails.Candidate_Id LEFT OUTER JOIN
                             dbo.Tbl_Employee_User left JOIN
                             dbo.Tbl_Employee ON dbo.Tbl_Employee_User.Employee_Id = dbo.Tbl_Employee.Employee_Id ON 
                             dbo.Tbl_Interview_Schedule_Log.Scheduled_by = dbo.Tbl_Employee_User.Employee_Id
                             left join dbo.Tbl_Student_Semester SS on SS.Candidate_Id=Tbl_Candidate_Personal_Det.Candidate_Id   and  SS.Student_Semester_Delete_Status=0 and   ss.student_semester_current_status=1
                    left JOIN Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id  
                    left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id     
                    left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id  
                    LEFT OUTER JOIN dbo.Tbl_IntakeMaster AS INM ON INM.id = cbd.IntakeMasterID 
                             left join tbl_New_Admission NA on NA.New_Admission_Id=dbo.Tbl_Candidate_Personal_Det.New_Admission_Id
                             where 
                              (dbo.Tbl_Candidate_Personal_Det.Campus= @organization_id or @organization_id=0)
    and (NA.Department_Id= @Department_id  or @Department_id=0)
    and (NA.Batch_Id= @intake_id or @intake_id=''0'')and((Interview_status='''' or Interview_status is Null   or Interview_status=''Fail'' or Interview_status=''AB'') and dbo.Tbl_Candidate_Personal_Det.Candidate_DelStatus=0) and
     (dbo.Tbl_Candidate_Personal_Det.Candidate_Id like ''%'' +@SearchKeyWord+ ''%''or 
     CONCAT(Tbl_Candidate_Personal_Det.Candidate_Fname,'' '',Tbl_Candidate_Personal_Det.Candidate_Lname) like ''%'' + @SearchKeyWord+ ''%'' or Tbl_Candidate_Personal_Det.AdharNumber like ''%'' 
     +@SearchKeyWord+ ''%''or Interview_date like ''%'' +@SearchKeyWord+ ''%'' or Tbl_Candidate_ContactDetails.Candidate_Email like ''%''
     +@SearchKeyWord+ ''%'' OR @SearchKeyWord=''''   )
     and (INM.id= @intake_id or @intake_id=''0'')     
     order by counts desc   
     OFFSET @pagesize * (@CurrentPage - 1) ROWS
          FETCH NEXT @pagesize ROWS ONLY           

    end     
END
    ');
END;
