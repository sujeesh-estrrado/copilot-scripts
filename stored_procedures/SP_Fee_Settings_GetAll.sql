IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Fee_Settings_GetAll]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Fee_Settings_GetAll]              
AS              
BEGIN           
SELECT f.*,c.Department_Name,fc.FeeCategory FeeCategoryName      
from Tbl_Fee_Settings F left join dbo.Tbl_Department c on f.Course_Id=c.Department_Id inner join Tbl_Feecategory Fc on fc.FeeCategoryId=f.Fee_Category     
 where FeeSetting_DeleteStatus=0 order by f.Fee_Settings_Id desc;        
        
END
    ')
END
