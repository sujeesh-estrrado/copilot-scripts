IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Fee_Settings_GetAll_Without_Search]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Fee_Settings_GetAll_Without_Search]   --''''DIPLOMA IN BUSINESS MANAGEMENT''''                
  
AS                  
BEGIN               
SELECT ROW_NUMBER() OVER (ORDER BY Fee_Settings_Id DESC) AS num,Base.*  FROM   
  
(SELECT f.*,c.Department_Name,fc.FeeCategory FeeCategoryName          
from Tbl_Fee_Settings F left join dbo.Tbl_Department c on f.Course_Id=c.Department_Id   
inner join Tbl_Feecategory Fc on fc.FeeCategoryId=f.Fee_Category  )Base  
       
 where ( FeeSetting_DeleteStatus=0  )  
   
 end
    ')
END
