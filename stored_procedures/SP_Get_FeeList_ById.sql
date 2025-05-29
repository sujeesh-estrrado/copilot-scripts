IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_FeeList_ById]')
    AND type = N'P'
)
BEGIN
    EXEC('
   create procedure [dbo].[SP_Get_FeeList_ById]--1    
(@Fee_Settings_Id bigint)            
AS            
            
BEGIN   
  
SELECT f.*,c.Department_Name,fc.FeeCategory FeeCategoryName          
from Tbl_Fee_Settings F left join dbo.Tbl_Department c on f.Course_Id=c.Department_Id   
inner join Tbl_Feecategory Fc on fc.FeeCategoryId=f.Fee_Category         
 where FeeSetting_DeleteStatus=0 and f.Fee_Settings_Id=@Fee_Settings_Id  
   
 end

    ')
END
