IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Councellor_by_Category]') 
    AND type = N'P'
)
BEGIN
    EXEC('
 CREATE procedure  [dbo].[sp_Get_Councellor_by_Category] --1,''  
(@flag bigint=0,@category varchar(50))  
as  
begin  
if(@flag=1)  
begin  
  
  


select count(CounselorEmployee_id)  as Leadscount,
e.Employee_Id  
from   dbo.tbl_Role INNER JOIN  
                         dbo.Tbl_User ON dbo.tbl_Role.role_Id = dbo.Tbl_User.role_Id INNER JOIN  
                         dbo.Tbl_Employee e INNER JOIN  
                         dbo.Tbl_Employee_User ON e.Employee_Id = dbo.Tbl_Employee_User.Employee_Id ON dbo.Tbl_User.user_Id = dbo.Tbl_Employee_User.User_Id 
						 left outer JOIN  
                         dbo.Tbl_Lead_Personal_Det ON e.Employee_Id = dbo.Tbl_Lead_Personal_Det.CounselorEmployee_id  and Tbl_Lead_Personal_Det.Source_name=''Insta''
where (dbo.tbl_Role.role_Name = ''Counsellor'' or dbo.tbl_Role.role_Name =''Counsellor Lead'' or  dbo.tbl_Role.role_Name =''Marketing Manager'')and Employee_Status=0 
     
   group by e.Employee_Id
   order by count(CounselorEmployee_id) 


  

  
    
  
  
   end  
   end  
    ');
END;
