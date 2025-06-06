IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Update_Emp_Dept_Designation]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Proc_Update_Emp_Dept_Designation](@Dept_Desig_ID bigint,@Dept_Desig_name varchar(255))    
as   
IF  EXISTS (SELECT Dept_Designation_Name FROM Tbl_Emp_DeptDesignation WHERE        
 Dept_Designation_Name=@Dept_Desig_name and Dept_Designation_Status=0 and Dept_Designation_Id<>@Dept_Desig_ID)         
BEGIN          
RAISERROR(''Data already exists.'',16,1);          
END       
else    
begin    
    
update Tbl_Emp_DeptDesignation    
   set    
       Dept_Designation_Name=@Dept_Desig_name    
       
where     
        Dept_Designation_Id=@Dept_Desig_ID      
    
end
    ')
END
