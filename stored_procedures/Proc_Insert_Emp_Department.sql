-- Check if the stored procedure [dbo].[Proc_Insert_Emp_Department] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_Emp_Department]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Insert_Emp_Department]            
(@Dept_Name varchar(255),            
 @Dept_ShortName varchar(255),            
 @Parent_Dept bigint,              
 @Dept_Head varchar(255),            
 @Dept_Status bit,            
 @Dept_Signature varchar(255))              
              
as              
IF  EXISTS (SELECT * FROM Tbl_Emp_Department WHERE            
 (Dept_Name=@Dept_Name or Dept_ShortName=@Dept_ShortName )and Dept_Status=0 and Delete_Status=0)              
BEGIN  
    RAISERROR(''Data Already Exist.'',16,1);        
END       
       
ELSE              
BEGIN              
              
 insert into Tbl_Emp_Department(Dept_Name,Dept_ShortName,Parent_Dept,Dept_Head,Dept_Status,Dept_Signature,Created_Date,Updated_Date,Delete_Status)              
 values(@Dept_Name,@Dept_ShortName,@Parent_Dept,@Dept_Head,@Dept_Status,@Dept_Signature,getdate(),getdate(),0)              
              
end    


--select * from Tbl_Emp_Department
    ')
END
