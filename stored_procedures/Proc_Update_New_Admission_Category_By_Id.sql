IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Update_New_Admission_Category_By_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Update_New_Admission_Category_By_Id]   
 (  
@Course_Level_Id bigint,  
@Course_Category_Id bigint,
@FromDate datetime,  
@ToDate datetime,  
@EndDate datetime ,
@New_Admission_Category_Id bigint
)  
AS  
   
BEGIN   
   
  update tbl_New_Admission_Category set Course_Level_Id=@Course_Level_Id,Course_Category_Id=@Course_Category_Id,

FromDate=@FromDate,ToDate=@ToDate,EndDate=@EndDate,Admission_Status=1 where New_Admission_Category_Id=@New_Admission_Category_Id
  

  
END
    ')
END
