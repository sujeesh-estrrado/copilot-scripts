IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Course_Level]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Course_Level]              
(@flag bigint=0,    
@modeofstudy bigint=0,    
@Level_Id bigint=0,    
@Programme_Id bigint=0)             
AS              
              
BEGIN              
 if(@flag=0)          
 begin          
  SELECT  Course_Level_Id,Course_Level_Name,Course_Level_Descripition,Course_Level_Date              
   FROM [dbo].[Tbl_Course_Level] where Course_Level_Status=0             
 order by  Course_Level_Name            
  end            
            
   if(@flag=1)          
 begin          
  SELECT  distinct CL.Course_Level_Id,CL.Course_Level_Name,CL.Course_Level_Descripition,CL.Course_Level_Date             
   FROM [dbo].[Tbl_Course_Level] CL           
   inner join Tbl_Department D on D.GraduationTypeId=CL.Course_Level_Id          
   where Online_checkstatus=1  and D.Delete_Status=0           
    and CL.Course_Level_Status=0 and CL.Delete_Status=0 and D.Department_Status=0         
    and  (@modeofstudy=0 or D.Modeofstudy=@modeofstudy) and  (@Level_Id=0 or D.Program_Type_Id=@Level_Id)    
 and(@Programme_Id=0 or D.Department_Id=@Programme_Id)    
 order by  Course_Level_Name            
  end           
END 
');
END;