-- Create procedure GetAll_Departmentnew if it does not exist
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GetAll_Departmentnew]') 
    AND type = N'P'
)
BEGIN
    EXEC('
             
CREATE procedure [dbo].[GetAll_Departmentnew]                  
                  
AS                  
                  
BEGIN                  
                
  Select distinct D.Department_Id,D.Department_Name,D.Department_Descripition,D.Course_Code,          
       C.Program_Code,CD.ProviderId,PM.ProviderCode ,C.Course_Category_Id,D.Intro_Date,CL.Course_Level_Name,CD.Course_Department_Id          
                 
   from  Tbl_Department D left join  Tbl_Course_Department CD on CD.Department_Id=D.Department_Id          
    left join Tbl_ProviderMaster PM on PM.ProviderId=CD.ProviderId        
    left join Tbl_Course_Category C on C.Course_Category_Id=CD.Course_Category_Id   
        left join  Tbl_Course_Level CL on CL.Course_Level_Id=D.GraduationTypeId                   
                
   where D.Department_Status=0 order by D.Department_Name desc               
                  
--SELECT  Department_Id,Department_Name,Department_Descripition              
--  FROM [dbo].[Tbl_Department] where Department_Status=0 order by Department_Name desc              
                     
END
    ')
END;
GO
