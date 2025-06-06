IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Update_Emp_Department]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[Proc_Update_Emp_Department]      
(@Dept_Id bigint,@Dept_Name varchar(255),@Dept_ShortName varchar(255),@Parent_Dept bigint,       
                                            @Dept_Head varchar(255),@Dept_Signature varchar(255))        
as          
IF  EXISTS (SELECT * FROM Tbl_Emp_Department WHERE        
 Dept_Name=@Dept_Name and Dept_Status=0 and Dept_Id<>@Dept_Id)         
BEGIN          
RAISERROR(''Data already exists.'',16,1);          
END       
else    
begin       
update Tbl_Emp_Department        
        
   set Dept_Name=@Dept_Name,        
       Dept_ShortName=@Dept_ShortName,       
       Parent_Dept=@Parent_Dept,      
       Dept_Head=@Dept_Head,        
       Dept_Signature=@Dept_Signature, 
       Updated_Date=getdate()       
 where        
       Dept_Id=@Dept_Id        
        
end
    ')
END
