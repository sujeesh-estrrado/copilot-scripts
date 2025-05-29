IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_ModeofStudy]')
    AND type = N'P'
)
BEGIN
    EXEC('
    create procedure [dbo].[SP_Get_ModeofStudy]        
(@flag bigint=0,    
@faculty_Id bigint=0,    
@Level_Id bigint=0,    
@Programme_Id bigint=0)       
AS        
        
BEGIN        
 if(@flag=0)    
 begin    
  SELECT  Mode_Id,Mode_Name  FROM Tbl_ModeofStudy     
  end      
  if(@flag=1)    
 begin    
  SELECT  distinct M.Mode_Id,M.Mode_Name  FROM Tbl_ModeofStudy M   
  left join Tbl_Department D  on M.Mode_Id=D.Modeofstudy    
  where D.Online_checkstatus=1  and D.Delete_Status=0 and D.Department_Status=0  
  and (D.GraduationTypeId=@faculty_Id or @faculty_Id=0)    
   and (D.Program_Type_Id=@Level_Id or @Level_Id=0)    
    and (D.Department_Id=@Programme_Id or @Programme_Id=0)    
  end      
      
END      
      
  
      
    ')
END
