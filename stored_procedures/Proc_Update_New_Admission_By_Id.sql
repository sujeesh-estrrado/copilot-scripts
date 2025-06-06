IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Update_New_Admission_By_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       
CREATE procedure [dbo].[Proc_Update_New_Admission_By_Id]     
 (    
@Course_Level_Id bigint,    
@Course_Category_Id bigint,    
@Department_Id bigint,  
@Batch_Id bigint,    
@FromDate datetime,    
@ToDate datetime,    
@EndDate datetime,    
@New_Admission_Id bigint
  
)    
AS    
     
BEGIN     
     
  update dbo.tbl_New_Admission set    
    
Course_Level_Id=(select GraduationTypeId from Tbl_Department where Department_Id=@Department_Id),Course_Category_Id=@Course_Category_Id,Department_Id=@Department_Id,  
Batch_Id=@Batch_Id  ,  
FromDate=@FromDate,ToDate=@ToDate,EndDate=@EndDate,Admission_Status=1
 where New_Admission_Id=@New_Admission_Id    
    
      
    
    
END
    ')
END
