IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_Employee_Review]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_Get_Employee_Review]   --45,446,''2017/02/09''                
  @Emp_Id  bigint,    
  @Date datetime                                 
AS                                              
BEGIN                                              
select  E.Employee_Id,E.Employee_FName+'' ''+E.Employee_LName as Employee_Name,JD.Date,JD.Category from Tbl_Employee E      
inner join LMS_Tbl_JobDiary JD on E.Employee_Id=JD.User_Id    
where E.Employee_Status=0            
and E.Employee_Id=@Emp_Id  and JD.Date=@Date    
END

    ')
END
