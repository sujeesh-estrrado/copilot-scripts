IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Update_Departmentnew]') 
    AND type = N'P'
)
BEGIN
    EXEC('
         
CREATE procedure [dbo].[Update_Departmentnew](@Dept_Id bigint,@Dept_Name varchar(300))  
  
AS  
  
BEGIN  
  
UPDATE [dbo].[Tbl_Emp_Department]  
SET      
Dept_Name= @Dept_Name  
 
                              
                
                
WHERE  Dept_Id= @Dept_Id  
  
END
    ')
END;
GO
