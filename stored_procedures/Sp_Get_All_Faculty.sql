IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_Faculty]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Get_All_Faculty]
@from datetime=null,              
@to datetime=NULL,              
@scheduledetails_id bigint=0 
as
begin
select DISTINCT E.Employee_Id,CONCAT(E.Employee_FName,'' '',E.Employee_LName) as EmployeeName from Tbl_Employee E                              
inner join Tbl_Employee_User EU                              
on EU.Employee_Id=E.Employee_Id                              
inner join Tbl_User U on  U.user_Id=EU.User_Id                              
inner join tbl_Role R on R.role_Id=U.role_Id and E.Employee_Id not in(                              
select employee_Id from Tbl_Employee_Allocations where ( (Allocation_from>=@from and Allocation_To<=@to)                             
or                             
  (Allocation_from>=@from and Allocation_To<=@from) or                            
   (Allocation_from>=@to and Allocation_To<=@to) )   and Status=0) 
   where E.Employee_Status=0
--and (R.role_Id=3 or  R.role_Id=11)   
--where E.Employee_Type = ''Teaching''
                           
     union                       
 select DISTINCT E.Employee_Id,CONCAT(E.Employee_FName,'' '',E.Employee_LName) as EmployeeName from Tbl_Employee E                              
inner join Invigilator_Mapping i on E.Employee_Id=i.Employee_id                      
where I.Exam_Schedule_Details_Id=@scheduledetails_id   and E.Employee_Status=0  

union 

select Distinct E.Employee_Id,CONCAT(E.Employee_FName,'' '',E.Employee_LName) as EmployeeName from Tbl_Employee E
inner join Tbl_Exam_Schedule_Details EA on EA.ChiefInvigilator=E.Employee_Id
--left join Invigilator_Mapping i on i.InvigilatorMapping_id=EA.Reference_id
where EA.Exam_Schedule_Details_Id=@scheduledetails_id


     order by EmployeeName  

end
    ')
END;
