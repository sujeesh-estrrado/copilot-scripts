IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Counsellor_Count_By_SOE]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[sp_Get_Counsellor_Count_By_SOE] --''Local''  
(  
@Employee_Type  varchar(Max)= '''' ,
@flag bigint=0
)  
as  
BEGIN  
if(@flag=0)
begin
-- select distinct top 1 Counselor_Type,count(CounselorEmployee_id) over (partition by CounselorEmployee_id) as count,e.Employee_Id  
--from   dbo.tbl_Role INNER JOIN  
--                         dbo.Tbl_User ON dbo.tbl_Role.role_Id = dbo.Tbl_User.role_Id INNER JOIN  
--                         dbo.Tbl_Employee e INNER JOIN  
--                         dbo.Tbl_Employee_User ON e.Employee_Id = dbo.Tbl_Employee_User.Employee_Id ON dbo.Tbl_User.user_Id = dbo.Tbl_Employee_User.User_Id INNER JOIN  
--                         dbo.Tbl_Candidate_Personal_Det ON e.Employee_Id = dbo.Tbl_Candidate_Personal_Det.CounselorEmployee_id  
--where ((e.Counselor_Type=@Employee_Type or e.Counselor_Type=''Local-International'') and dbo.tbl_Role.role_Name = ''Counsellor'' ) and e.Counselor_Type is not null order by count asc  
IF OBJECT_ID(''#TEMP1'', ''U'') IS NOT NULL                
  DROP TABLE #TEMP2;     
SELECT * InTO #TEMP2 FROM   
(  
(select distinct Counselor_Type,count(CounselorEmployee_id) over (partition by CounselorEmployee_id) as count,e.Employee_Id  
from   dbo.tbl_Role INNER JOIN  
                         dbo.Tbl_User ON dbo.tbl_Role.role_Id = dbo.Tbl_User.role_Id INNER JOIN  
                         dbo.Tbl_Employee e INNER JOIN  
                         dbo.Tbl_Employee_User ON e.Employee_Id = dbo.Tbl_Employee_User.Employee_Id ON dbo.Tbl_User.user_Id = dbo.Tbl_Employee_User.User_Id INNER JOIN  
                         dbo.Tbl_Candidate_Personal_Det ON e.Employee_Id = dbo.Tbl_Candidate_Personal_Det.CounselorEmployee_id  and dbo.Tbl_Candidate_Personal_Det.Enquiry_From=''Online''
where ((e.Counselor_Type=@Employee_Type) and dbo.tbl_Role.role_Name = ''Counsellor'' )and Employee_Status=0)  
  
Union all  
  
(select distinct Counselor_Type,count(CounselorEmployee_id) over (partition by CounselorEmployee_id) as count,e.Employee_Id  
from   dbo.tbl_Role INNER JOIN  
                         dbo.Tbl_User ON dbo.tbl_Role.role_Id = dbo.Tbl_User.role_Id INNER JOIN  
                         dbo.Tbl_Employee e INNER JOIN  
                         dbo.Tbl_Employee_User ON e.Employee_Id = dbo.Tbl_Employee_User.Employee_Id ON dbo.Tbl_User.user_Id = dbo.Tbl_Employee_User.User_Id INNER JOIN  
                         dbo.Tbl_Candidate_Personal_Det ON e.Employee_Id = dbo.Tbl_Candidate_Personal_Det.CounselorEmployee_id  and dbo.Tbl_Candidate_Personal_Det.Enquiry_From=''Online''
where ((e.Counselor_Type=''Local-International'') and dbo.tbl_Role.role_Name = ''Counsellor'' )and Employee_Status=0)  
  
)Base  
                                                                 
 select distinct top 1 Counselor_Type,count,Employee_Id FROM                                         
            #TEMP2  order by count asc  
  
 end  
  else
  begin
  IF OBJECT_ID(''#TEMP1'', ''U'') IS NOT NULL                
  DROP TABLE #TEMP1;     
SELECT * InTO #TEMP1 FROM   
(  
(select distinct Counselor_Type,count(CounselorEmployee_id) over (partition by CounselorEmployee_id) as count,e.Employee_Id  
from   dbo.tbl_Role INNER JOIN  
                         dbo.Tbl_User ON dbo.tbl_Role.role_Id = dbo.Tbl_User.role_Id INNER JOIN  
                         dbo.Tbl_Employee e INNER JOIN  
                         dbo.Tbl_Employee_User ON e.Employee_Id = dbo.Tbl_Employee_User.Employee_Id ON dbo.Tbl_User.user_Id = dbo.Tbl_Employee_User.User_Id INNER JOIN  
                         dbo.Tbl_Candidate_Personal_Det ON e.Employee_Id = dbo.Tbl_Candidate_Personal_Det.CounselorEmployee_id  and dbo.Tbl_Candidate_Personal_Det.Enquiry_From=''Social Media''
where ((e.Counselor_Type=@Employee_Type) and dbo.tbl_Role.role_Name = ''Counsellor'' )and Employee_Status=0)  
  
Union all  
  
(select distinct Counselor_Type,count(CounselorEmployee_id) over (partition by CounselorEmployee_id) as count,e.Employee_Id  
from   dbo.tbl_Role INNER JOIN  
                         dbo.Tbl_User ON dbo.tbl_Role.role_Id = dbo.Tbl_User.role_Id INNER JOIN  
                         dbo.Tbl_Employee e INNER JOIN  
                         dbo.Tbl_Employee_User ON e.Employee_Id = dbo.Tbl_Employee_User.Employee_Id ON dbo.Tbl_User.user_Id = dbo.Tbl_Employee_User.User_Id INNER JOIN  
                         dbo.Tbl_Candidate_Personal_Det ON e.Employee_Id = dbo.Tbl_Candidate_Personal_Det.CounselorEmployee_id  and dbo.Tbl_Candidate_Personal_Det.Enquiry_From=''Social Media''
where ((e.Counselor_Type=''Local-International'') and dbo.tbl_Role.role_Name = ''Counsellor'' )and Employee_Status=0)  
  
)Base  
                                                                 
 select distinct top 1 Counselor_Type,count,Employee_Id FROM                                         
            #TEMP1  order by count asc  
  end


  end
    ');
END;
