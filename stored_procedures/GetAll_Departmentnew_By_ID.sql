-- Create procedure GetAll_Departmentnew_By_ID if it does not exist
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GetAll_Departmentnew_By_ID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[GetAll_Departmentnew_By_ID] --3    
(@Department_Id bigint)            
            
AS            
            
BEGIN            
          
                 
  Select D.Department_Id,D.Department_Name,D.Department_Descripition,D.Course_Code,          
         C.Program_Code,CD.ProviderId,PM.ProviderCode ,C.Course_Category_Id,D.Department_Descripition,D.Intro_Date,CL.Course_Level_Name,
           CL.Course_Level_Id,C.Course_Category_Id    
                 
   from  Tbl_Department D   
   left join  Tbl_Course_Department CD on CD.Department_Id=D.Department_Id          
    left join Tbl_ProviderMaster PM on PM.ProviderId=CD.ProviderId        
    left join Tbl_Course_Category C on C.Course_Category_Id=CD.Course_Category_Id       
    left join  Tbl_Course_Level CL on CL.Course_Level_Id=D.GraduationTypeId        
            
            
 --select Department_Id,Department_Name,Department_Descripition,Course_Code            
 --from Tbl_Department            
 where D.Department_Id=@Department_Id            
END
    ')
END;
GO
