IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Update_Student_Holiday_Name]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Proc_Update_Student_Holiday_Name](    
@Student_Holiday_Id bigint,@Student_Holiday_Name varchar(100))    
  
as    
begin    
    
update Tbl_Student_Holidays     
set     
   Student_Holiday_Name=@Student_Holiday_Name    
   
    
where Student_Holiday_Id=@Student_Holiday_Id    
    
    
end
   ')
END;
