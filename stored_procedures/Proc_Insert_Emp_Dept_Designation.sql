IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_Emp_Dept_Designation]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[Proc_Insert_Emp_Dept_Designation]
(@Dept_Desig_name varchar(255),  
 @Dept_Desig_DeleteStatus bit)  
as   
  
IF  EXISTS (SELECT * FROM Tbl_Emp_DeptDesignation WHERE Dept_Designation_Name=@Dept_Desig_name and Delete_Status=0)  
BEGIN  
RAISERROR(''Data already exists.'',16,1);  
END  
ELSE  
BEGIN  
insert into Tbl_Emp_DeptDesignation(Dept_Designation_Name,Dept_Designation_Status,Created_Date,Updated_Date,Delete_Status)  
values(@Dept_Desig_name,@Dept_Desig_DeleteStatus,getdate(),getdate(),0)  
end
    ')
END
