IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Counsellor_EnquiryCount]') 
    AND type = N'P'
)
BEGIN
    EXEC('
   
CREATE procedure [dbo].[sp_Get_Counsellor_EnquiryCount] --''Local''            
(            
@flag bigint=0,          
@Employee_Type  varchar(Max)= '''' ,          
@Page_Id BIGINT=0   ,
@Counselor_Type varchar(max)='''',
@ProgramId  BIGINT=0   ,
@NationalityId BIGINT=0 ,
@StateId BIGINT=0,
@AgentId BIGINT=0,
@Type varchar(Max)=''''

)            
as            
BEGIN            
if(@flag=0)          
Begin          
 IF OBJECT_ID(''#TEMP1'', ''U'') IS NOT NULL                          
   DROP TABLE #TEMP2;               
           
 SELECT * InTO #TEMP2 FROM             
 (            
 (select distinct Counselor_Type,count(CounselorEmployee_id) over (partition by CounselorEmployee_id) as count,e.Employee_Id,e.Lead_assigned_date            
 from   dbo.tbl_Role INNER JOIN            
        dbo.Tbl_User ON dbo.tbl_Role.role_Id = dbo.Tbl_User.role_Id INNER JOIN            
        dbo.Tbl_Employee e INNER JOIN            
        dbo.Tbl_Employee_User ON e.Employee_Id = dbo.Tbl_Employee_User.Employee_Id ON dbo.Tbl_User.user_Id = dbo.Tbl_Employee_User.User_Id INNER JOIN            
        dbo.Tbl_Candidate_Personal_Det ON e.Employee_Id = dbo.Tbl_Candidate_Personal_Det.CounselorEmployee_id   INNER JOIN 
         dbo.Tbl_Counsellor_PageMapping on E.Employee_Id =  dbo.Tbl_Counsellor_PageMapping.Counsellor_Id 
 where ((e.Counselor_Type=@Employee_Type) and dbo.tbl_Role.role_Name in( ''Counsellor'' ,''Counsellor Lead'') )and E.Employee_Status=0 AND    Tbl_Counsellor_PageMapping.Delete_Status =0    AND (Tbl_Counsellor_PageMapping.Nationality_Id = @NationalityId OR @NationalityId IS NULL ) AND (Tbl_Counsellor_PageMapping.state_id = @StateId OR @StateId IS NULL ) and 
(Tbl_Counsellor_PageMapping.Agent_id = @AgentId OR @AgentId IS NULL ) and (Tbl_Counsellor_PageMapping.Page_Id = @Page_Id OR @Page_Id IS NULL)
and Tbl_Counsellor_PageMapping.Type  =@Type AND Tbl_Counsellor_PageMapping.ActiveStatus=1  )     
            
 Union all            
            
 (select distinct Counselor_Type,count(CounselorEmployee_id) over (partition by CounselorEmployee_id) as count,e.Employee_Id,e.Lead_assigned_date           
 from   dbo.tbl_Role INNER JOIN            
        dbo.Tbl_User ON dbo.tbl_Role.role_Id = dbo.Tbl_User.role_Id INNER JOIN            
        dbo.Tbl_Employee e INNER JOIN            
        dbo.Tbl_Employee_User ON e.Employee_Id = dbo.Tbl_Employee_User.Employee_Id ON dbo.Tbl_User.user_Id = dbo.Tbl_Employee_User.User_Id LEFT JOIN            
        dbo.Tbl_Candidate_Personal_Det ON e.Employee_Id = dbo.Tbl_Candidate_Personal_Det.CounselorEmployee_id  INNER JOIN 
         dbo.Tbl_Counsellor_PageMapping on E.Employee_Id =  dbo.Tbl_Counsellor_PageMapping.Counsellor_Id           
 where ((e.Counselor_Type=''Local-International'') and dbo.tbl_Role.role_Name in( ''Counsellor'' ,''Counsellor Lead'') )and E.Employee_Status=0 AND    Tbl_Counsellor_PageMapping.Delete_Status =0  AND (Tbl_Counsellor_PageMapping.Nationality_Id = @NationalityId OR @NationalityId IS NULL) AND (Tbl_Counsellor_PageMapping.state_id = @StateId OR @StateId IS NULL ) and 
(Tbl_Counsellor_PageMapping.Agent_id = @AgentId OR @AgentId IS NULL)  and (Tbl_Counsellor_PageMapping.Page_Id = @Page_Id OR @Page_Id IS NULL)
and Tbl_Counsellor_PageMapping.Type  =@Type AND Tbl_Counsellor_PageMapping.ActiveStatus=1  )    

 Union all            
            
 (select distinct Counselor_Type,count(CounselorEmployee_id) over (partition by CounselorEmployee_id) as count,e.Employee_Id,e.Lead_assigned_date           
 from   dbo.tbl_Role INNER JOIN            
        dbo.Tbl_User ON dbo.tbl_Role.role_Id = dbo.Tbl_User.role_Id INNER JOIN            
        dbo.Tbl_Employee e INNER JOIN            
        dbo.Tbl_Employee_User ON e.Employee_Id = dbo.Tbl_Employee_User.Employee_Id ON dbo.Tbl_User.user_Id = dbo.Tbl_Employee_User.User_Id LEFT JOIN            
        dbo.Tbl_Candidate_Personal_Det ON e.Employee_Id = dbo.Tbl_Candidate_Personal_Det.CounselorEmployee_id  INNER JOIN 
         dbo.Tbl_Counsellor_PageMapping on E.Employee_Id =  dbo.Tbl_Counsellor_PageMapping.Counsellor_Id           
 where ((e.Counselor_Type=''Local'') and dbo.tbl_Role.role_Name in( ''Counsellor'' ,''Counsellor Lead'') )and E.Employee_Status=0 AND    Tbl_Counsellor_PageMapping.Delete_Status =0  AND (Tbl_Counsellor_PageMapping.Nationality_Id = @NationalityId OR @NationalityId IS NULL) AND (Tbl_Counsellor_PageMapping.state_id = @StateId OR @StateId IS NULL ) and 
(Tbl_Counsellor_PageMapping.Agent_id = @AgentId OR @AgentId IS NULL)  and (Tbl_Counsellor_PageMapping.Page_Id = @Page_Id OR @Page_Id IS NULL)
and Tbl_Counsellor_PageMapping.Type  =@Type AND Tbl_Counsellor_PageMapping.ActiveStatus=1  )

 Union all            
            
 (select distinct Counselor_Type,count(CounselorEmployee_id) over (partition by CounselorEmployee_id) as count,e.Employee_Id,e.Lead_assigned_date           
 from   dbo.tbl_Role INNER JOIN            
        dbo.Tbl_User ON dbo.tbl_Role.role_Id = dbo.Tbl_User.role_Id INNER JOIN            
        dbo.Tbl_Employee e INNER JOIN            
        dbo.Tbl_Employee_User ON e.Employee_Id = dbo.Tbl_Employee_User.Employee_Id ON dbo.Tbl_User.user_Id = dbo.Tbl_Employee_User.User_Id LEFT JOIN            
        dbo.Tbl_Candidate_Personal_Det ON e.Employee_Id = dbo.Tbl_Candidate_Personal_Det.CounselorEmployee_id  INNER JOIN 
         dbo.Tbl_Counsellor_PageMapping on E.Employee_Id =  dbo.Tbl_Counsellor_PageMapping.Counsellor_Id           
 where ((e.Counselor_Type=''INTERNATIONAL'') and dbo.tbl_Role.role_Name in( ''Counsellor'' ,''Counsellor Lead'') )and E.Employee_Status=0 AND    Tbl_Counsellor_PageMapping.Delete_Status =0  AND (Tbl_Counsellor_PageMapping.Nationality_Id = @NationalityId OR @NationalityId IS NULL) AND (Tbl_Counsellor_PageMapping.state_id = @StateId OR @StateId IS NULL ) and 
(Tbl_Counsellor_PageMapping.Agent_id = @AgentId OR @AgentId IS NULL)  and (Tbl_Counsellor_PageMapping.Page_Id = @Page_Id OR @Page_Id IS NULL)
and Tbl_Counsellor_PageMapping.Type  =@Type AND Tbl_Counsellor_PageMapping.ActiveStatus=1  )
            
 )Base            
              select  top 1 Counselor_Type,count,Employee_Id,Lead_assigned_date FROM                                                   
    #TEMP2  order by Lead_assigned_date asc 
    update Tbl_Employee set Lead_assigned_date= getdate() where Employee_Id = (select  top 1 Employee_Id from #TEMP2 order by Lead_assigned_date)                                                             
  --select distinct top 1 Counselor_Type,count,Employee_Id FROM                                                   
  --  #TEMP2  order by count asc            
end          
if(@flag=1)          
Begin          
IF OBJECT_ID(''#TEMP3'', ''U'') IS NOT NULL                          
   DROP TABLE #TEMP3;               
           
 SELECT * InTO #TEMP3 FROM             
 (            
 (select distinct Counselor_Type,count(CounselorEmployee_id) over (partition by CounselorEmployee_id) as count,e.Employee_Id,e.Lead_assigned_date           
 from   dbo.tbl_Role INNER JOIN            
        dbo.Tbl_User ON dbo.tbl_Role.role_Id = dbo.Tbl_User.role_Id INNER JOIN            
        Tbl_Counsellor_PageMapping PM INNER JOIN           
        dbo.Tbl_Employee e on  E.Employee_Id=PM.Counsellor_Id INNER JOIN            
        dbo.Tbl_Employee_User ON e.Employee_Id = dbo.Tbl_Employee_User.Employee_Id ON dbo.Tbl_User.user_Id = dbo.Tbl_Employee_User.User_Id INNER JOIN            
        dbo.Tbl_Candidate_Personal_Det ON e.Employee_Id = dbo.Tbl_Candidate_Personal_Det.CounselorEmployee_id            
 where E.Employee_Status=0 AND  Page_Id=@Page_Id)            
 )Base            
         select  top 1 Counselor_Type,count,Employee_Id,Lead_assigned_date FROM                                                   
    #TEMP3 order by Lead_assigned_date asc      
    update Tbl_Employee set Lead_assigned_date= getdate() where Employee_Id = (select  top 1 Employee_Id from #TEMP3 order by Lead_assigned_date)                                                                   
  --select distinct top 1 Counselor_Type,count,Employee_Id FROM                                                   
  --  #TEMP3 order by count asc           
end  
if(@flag=2)--insta page least count counsellor        
begin        
        
  --select top 100 a.Leadscount as Leadscount,Page_Id,Employee_Id  from         
  --(        
        
     --( 
        --select PM.Counter  as Leadscount,e.Employee_Id  ,Page_Id       
        --from  Tbl_Counsellor_PageMapping PM INNER JOIN          
        --                   dbo.Tbl_Employee e on e.Employee_Id=PM.Counsellor_Id INNER JOIN            
        --                   dbo.Tbl_Employee_User EU ON e.Employee_Id = EU.Employee_Id  inner join  
        --                   dbo.Tbl_User U on U.User_Id= EU.User_Id inner join 
        --                   tbl_Role R on R.role_Id=U.role_Id 
        --                   --left  JOIN dbo.Tbl_Candidate_Personal_Det CPD ON PM.Counsellor_Id = CPD.CounselorEmployee_id
        --where  (R.role_Name = ''Counsellor'' 
        --          or R.role_Name =''Counsellor Lead'' 
        --          or  R.role_Name =''Marketing Manager''     
        --          or  R.role_Name =''PSO'')
        --  and Employee_Status=0    and PM.Delete_Status=0 and (Counselor_Type = @Counselor_Type or Counselor_Type = ''Local-International'')
        --  --or( Enquiry_From=''Online''or CPD.ApplicationStatus in(''Pending'',''pending'',''submited'',''Old Data'',''HOLD'')     
        --  --      or CPD.Candidate_DelStatus=0    
        --  --      or CPD.active=1   )     
        --group by e.Employee_Id,PM.Counter ,Page_Id )
  -- ) as a  where Page_Id=@Page_Id group by Employee_Id,Page_Id,Leadscount     
      
  -- order by Leadscount 
         

            select  top 1  E.Employee_Id as Employee_Id

from Tbl_Employee E     
 inner join Tbl_Employee_User EU on EU.Employee_Id=E.Employee_Id  
 left join Tbl_Counsellor_PageMapping PM on E.Employee_Id = PM.Counsellor_Id
 inner join Tbl_User U on U.user_Id=EU.User_Id    
 inner join Tbl_RoleAssignment RA on RA.employee_id=E.Employee_Id    
 left join Tbl_Employee_Official eo on eo.Employee_Id=E.Employee_Id    
 left join Tbl_Emp_Department ed on ed.Dept_Id=eo.Department_Id and  ed.Dept_Id=10    
 inner join tbl_Role R on R.role_Id=RA.role_id    
  WHERE    
   (R.role_Name = ''Counsellor'' or R.role_Name=''Counsellor Lead''  or R.role_Name=''Marketing Manager''  or R.role_Name=''PSO'')  and     
  E.Employee_Status=0    and PM.Page_Id= @Page_Id
    and    ( Counselor_Type = @Counselor_Type or Counselor_Type = ''Local-International'')and  PM.Delete_Status =0
 order by E.Lead_Assigned_Date

   update Tbl_Employee set Lead_assigned_date=getdate() where Employee_Id=
   (select  top 1  E.Employee_Id as Employee_Id

    from Tbl_Employee E     
 inner join Tbl_Employee_User EU on EU.Employee_Id=E.Employee_Id    
  left join Tbl_Counsellor_PageMapping PM on E.Employee_Id = PM.Counsellor_Id

 inner join Tbl_User U on U.user_Id=EU.User_Id    
 inner join Tbl_RoleAssignment RA on RA.employee_id=E.Employee_Id 
 left join Tbl_Employee_Official eo on eo.Employee_Id=E.Employee_Id    
 left join Tbl_Emp_Department ed on ed.Dept_Id=eo.Department_Id and  ed.Dept_Id=10    
 inner join tbl_Role R on R.role_Id=RA.role_id    
  WHERE    
   (R.role_Name = ''Counsellor'' or R.role_Name=''Counsellor Lead''  or R.role_Name=''Marketing Manager''  or R.role_Name=''PSO'')  and     
   E.Employee_Status=0    and PM.Page_Id = @Page_Id
   and    (Counselor_Type = @Counselor_Type or Counselor_Type = ''Local-International'')and  PM.Delete_Status =0

 order by E.Lead_Assigned_Date)
        
        
        
end        
if(@flag=3)--welcome page least count counsellor        
begin        
        
  --select top 100 a.Leadscount as Leadscount,Page_Id,Employee_Id  from         
  --(        
        
     --( 
        --select PM.Counter  as Leadscount,e.Employee_Id  ,Page_Id       
        --from  Tbl_Counsellor_PageMapping PM INNER JOIN          
        --                   dbo.Tbl_Employee e on e.Employee_Id=PM.Counsellor_Id INNER JOIN            
        --                   dbo.Tbl_Employee_User EU ON e.Employee_Id = EU.Employee_Id  inner join  
        --                   dbo.Tbl_User U on U.User_Id= EU.User_Id inner join 
        --                   tbl_Role R on R.role_Id=U.role_Id 
        --                   --left  JOIN dbo.Tbl_Candidate_Personal_Det CPD ON PM.Counsellor_Id = CPD.CounselorEmployee_id
        --where  (R.role_Name = ''Counsellor'' 
        --          or R.role_Name =''Counsellor Lead'' 
        --          or  R.role_Name =''Marketing Manager''     
        --          or  R.role_Name =''PSO'')
        --  and Employee_Status=0    and PM.Delete_Status=0 and (Counselor_Type = @Counselor_Type or Counselor_Type = ''Local-International'')
        --  --or( Enquiry_From=''Online''or CPD.ApplicationStatus in(''Pending'',''pending'',''submited'',''Old Data'',''HOLD'')     
        --  --      or CPD.Candidate_DelStatus=0    
        --  --      or CPD.active=1   )     
        --group by e.Employee_Id,PM.Counter ,Page_Id )
  -- ) as a  where Page_Id=@Page_Id group by Employee_Id,Page_Id,Leadscount     
      
  -- order by Leadscount      


 SELECT TOP 1 * FROM (select  top 1   E.Employee_Id as Employee_Id, CONCAT(E.employee_fname, '' '', E.employee_lname) AS empname, Employee_Mail,E.Lead_Assigned_Date

        from Tbl_Employee E     
         inner join Tbl_Employee_User EU on EU.Employee_Id=E.Employee_Id  
         left join Tbl_Counsellor_PageMapping PM on E.Employee_Id = PM.Counsellor_Id
         inner join Tbl_User U on U.user_Id=EU.User_Id    
         inner join Tbl_RoleAssignment RA on RA.employee_id=E.Employee_Id    
         left join Tbl_Employee_Official eo on eo.Employee_Id=E.Employee_Id    
         left join Tbl_Emp_Department ed on ed.Dept_Id=eo.Department_Id --and  ed.Dept_Id=10    
         inner join tbl_Role R on R.role_Id=RA.role_id    
          WHERE    
           (R.role_Name = ''Counsellor'' or R.role_Name=''Counsellor Lead''  or R.role_Name=''Marketing Manager''  or R.role_Name=''PSO'')  and     
           E.Employee_Status=0    and PM.Page_Id= @Page_Id AND (PM.Program_id = @ProgramId OR @ProgramId IS NULL )
AND (PM.Nationality_Id = @NationalityId OR @NationalityId IS NULL) AND (PM.state_id = @StateId OR @StateId IS NULL) and 
(PM.Agent_id = @AgentId OR @AgentId IS NULL )
and PM.Type  =@Type AND PM.ActiveStatus=1
            --and    (e.Counselor_Type = (case when @Counselor_Type =''Local-International'' Then ''INTERNATIONAL'' when @Counselor_Type =''LOCAL'' Then ''LOCAL'' END) or e.Counselor_Type = ''Local-International'' ) 
            and  PM.Delete_Status =0 ORDER BY Lead_Assigned_Date
        -- order by E.Lead_Assigned_Date

union all

          select  top 1  E.Employee_Id as Employee_Id, CONCAT(E.employee_fname, '' '', E.employee_lname) AS empname, Employee_Mail,E.Lead_Assigned_Date

        from Tbl_Employee E     
         inner join Tbl_Employee_User EU on EU.Employee_Id=E.Employee_Id  
         left join Tbl_Counsellor_PageMapping PM on E.Employee_Id = PM.Counsellor_Id
         inner join Tbl_User U on U.user_Id=EU.User_Id    
         inner join Tbl_RoleAssignment RA on RA.employee_id=E.Employee_Id    
         left join Tbl_Employee_Official eo on eo.Employee_Id=E.Employee_Id    
         left join Tbl_Emp_Department ed on ed.Dept_Id=eo.Department_Id --and  ed.Dept_Id=10    
         inner join tbl_Role R on R.role_Id=RA.role_id    
          WHERE    
           (R.role_Name = ''Counsellor'' or R.role_Name=''Counsellor Lead''  or R.role_Name=''Marketing Manager''  or R.role_Name=''PSO'')  and     
           E.Employee_Status=0    and PM.Page_Id= @Page_Id AND (PM.Program_id = 0 OR PM.Program_id IS NULL )
AND (PM.Nationality_Id = 0 OR  PM.Nationality_Id IS NULL) AND (PM.state_id = 0 OR PM.state_id IS NULL) and 
(PM.Agent_id = 0 OR PM.Agent_id IS NULL )
and PM.Type  =@Type AND PM.ActiveStatus=1
            --and    (e.Counselor_Type = (case when @Counselor_Type =''Local-International'' Then ''INTERNATIONAL'' when @Counselor_Type =''LOCAL'' Then ''LOCAL'' END) or e.Counselor_Type = ''Local-International'' ) 
            and  PM.Delete_Status =0 ORDER BY Lead_Assigned_Date
          ) AS CombinedResults
ORDER BY Lead_Assigned_Date

 update Tbl_Employee set Lead_assigned_date=getdate() where Employee_Id=
   ( SELECT TOP 1 Employee_Id FROM ( SELECT E.Employee_Id,E.Lead_assigned_date

    from Tbl_Employee E     
 inner join Tbl_Employee_User EU on EU.Employee_Id=E.Employee_Id    
  left join Tbl_Counsellor_PageMapping PM on E.Employee_Id = PM.Counsellor_Id

 inner join Tbl_User U on U.user_Id=EU.User_Id    
 inner join Tbl_RoleAssignment RA on RA.employee_id=E.Employee_Id 
 left join Tbl_Employee_Official eo on eo.Employee_Id=E.Employee_Id    
 left join Tbl_Emp_Department ed on ed.Dept_Id=eo.Department_Id and  ed.Dept_Id=10    
 inner join tbl_Role R on R.role_Id=RA.role_id    
  WHERE    
     (R.role_Name = ''Counsellor'' or R.role_Name=''Counsellor Lead''  or R.role_Name=''Marketing Manager''  or R.role_Name=''PSO'')  and     
           E.Employee_Status=0    and PM.Page_Id= @Page_Id AND (PM.Program_id = @ProgramId OR @ProgramId IS NULL )
AND (PM.Nationality_Id = @NationalityId OR @NationalityId IS NULL) AND (PM.state_id = @StateId OR @StateId IS NULL) and 
(PM.Agent_id = @AgentId OR @AgentId IS NULL )
and PM.Type  =@Type AND PM.ActiveStatus=1
            --and    (e.Counselor_Type = (case when @Counselor_Type =''Local-International'' Then ''INTERNATIONAL'' when @Counselor_Type =''LOCAL'' Then ''LOCAL'' END) or e.Counselor_Type = ''Local-International'' ) 
            and  PM.Delete_Status =0

   UNION ALL

    SELECT E.Employee_Id,E.Lead_assigned_date

    from Tbl_Employee E     
 inner join Tbl_Employee_User EU on EU.Employee_Id=E.Employee_Id    
  left join Tbl_Counsellor_PageMapping PM on E.Employee_Id = PM.Counsellor_Id

 inner join Tbl_User U on U.user_Id=EU.User_Id    
 inner join Tbl_RoleAssignment RA on RA.employee_id=E.Employee_Id 
 left join Tbl_Employee_Official eo on eo.Employee_Id=E.Employee_Id    
 left join Tbl_Emp_Department ed on ed.Dept_Id=eo.Department_Id and  ed.Dept_Id=10    
 inner join tbl_Role R on R.role_Id=RA.role_id    
  WHERE    
           (R.role_Name = ''Counsellor'' or R.role_Name=''Counsellor Lead''  or R.role_Name=''Marketing Manager''  or R.role_Name=''PSO'')  and     
           E.Employee_Status=0    and PM.Page_Id= @Page_Id AND (PM.Program_id = 0 OR PM.Program_id IS NULL )
AND (PM.Nationality_Id = 0 OR  PM.Nationality_Id IS NULL) AND (PM.state_id = 0 OR PM.state_id IS NULL) and 
(PM.Agent_id = 0 OR PM.Agent_id IS NULL )
and PM.Type  =@Type AND PM.ActiveStatus=1
            --and    (e.Counselor_Type = (case when @Counselor_Type =''Local-International'' Then ''INTERNATIONAL'' when @Counselor_Type =''LOCAL'' Then ''LOCAL'' END) or e.Counselor_Type = ''Local-International'' ) 
            and  PM.Delete_Status =0
          ) AS CombinedResults
ORDER BY Lead_Assigned_Date)
        
end        
--if(@flag=2)--insta page least count counsellor        
--begin        
        
--   select top 1 sum(Leadscount)as Leadscount,Employee_Id,Page_Id  from         
--  (( select count(CounselorEmployee_id)  as Leadscount,e.Employee_Id ,Page_Id        
--   from  Tbl_Counsellor_PageMapping PM INNER JOIN          
--                         dbo.Tbl_Employee e on e.Employee_Id=PM.Counsellor_Id INNER JOIN            
--                         dbo.Tbl_Employee_User EU ON e.Employee_Id = EU.Employee_Id         
             
--       inner join  dbo.Tbl_User U on U.User_Id= EU.User_Id        
--       inner join tbl_Role R on R.role_Id=U.role_Id        
--       left  JOIN            
--                       dbo.Tbl_Lead_Personal_Det ON e.Employee_Id = dbo.Tbl_Lead_Personal_Det.CounselorEmployee_id          
--      and Tbl_Lead_Personal_Det.Source_name=''Instapage''          
--      where Page_Id=@Page_Id and(R.role_Name = ''Counsellor'' or R.role_Name =''Counsellor Lead'' or  R.role_Name =''Marketing Manager'' or  R.role_Name =''PSO'')and Employee_Status=0           
               
--   group by e.Employee_Id,Page_Id  )        
          
--  Union        
        
-- ( select count(CounselorEmployee_id)  as Leadscount,e.Employee_Id  ,Page_Id       
--   from  Tbl_Counsellor_PageMapping PM INNER JOIN          
--                         dbo.Tbl_Employee e on e.Employee_Id=PM.Counsellor_Id INNER JOIN            
--                         dbo.Tbl_Employee_User EU ON e.Employee_Id = EU.Employee_Id         
             
--       inner join  dbo.Tbl_User U on U.User_Id= EU.User_Id        
--       inner join tbl_Role R on R.role_Id=U.role_Id        
--       left  JOIN            
--                       dbo.Tbl_Candidate_Personal_Det CPD ON e.Employee_Id = CPD.CounselorEmployee_id          
              
--      where Page_Id=@Page_Id and (R.role_Name = ''Counsellor'' or R.role_Name =''Counsellor Lead'' or  R.role_Name =''Marketing Manager'' or  R.role_Name =''PSO'')and Employee_Status=0           
--       or( (CPD.ApplicationStatus in(''Pending'',''pending'',''submited'',''Old Data'',''HOLD'') or CPD.Candidate_DelStatus=0 or CPD.active=1))        
--   group by e.Employee_Id,Page_Id  )) as a where Page_Id=@Page_Id group by Employee_Id,Page_Id order by Leadscount        
         
        
        
        
--end        
--if(@flag=3)--welcome page least count counsellor        
--begin        
        
--  select top 1 sum(Leadscount)as Leadscount,Page_Id,Employee_Id  from         
--  (        
        
-- ( select count(CounselorEmployee_id)  as Leadscount,e.Employee_Id  ,Page_Id       
--   from  Tbl_Counsellor_PageMapping PM INNER JOIN          
--                         dbo.Tbl_Employee e on e.Employee_Id=PM.Counsellor_Id INNER JOIN            
--                         dbo.Tbl_Employee_User EU ON e.Employee_Id = EU.Employee_Id         
             
--       inner join  dbo.Tbl_User U on U.User_Id= EU.User_Id        
--       inner join tbl_Role R on R.role_Id=U.role_Id        
--       left  JOIN            
--                       dbo.Tbl_Candidate_Personal_Det CPD ON PM.Counsellor_Id = CPD.CounselorEmployee_id          
              
--      where  (R.role_Name = ''Counsellor'' or R.role_Name =''Counsellor Lead'' or  R.role_Name =''Marketing Manager''     
--   or  R.role_Name =''PSO'')and Employee_Status=0    or( Enquiry_From=''Online''       
--       or CPD.ApplicationStatus in(''Pending'',''pending'',''submited'',''Old Data'',''HOLD'')     
-- or CPD.Candidate_DelStatus=0    
--  or CPD.active=1   )     
      
--   group by e.Employee_Id ,Page_Id )) as a  where Page_Id=@Page_Id group by Employee_Id,Page_Id     
      
--   order by Leadscount      
        
--end        
end


    ');
END;
