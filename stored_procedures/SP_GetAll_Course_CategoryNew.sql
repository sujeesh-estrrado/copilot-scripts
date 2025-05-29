IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Course_CategoryNew]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Course_CategoryNew]  
as  
begin  
select Course_Category_Id as CategoryID,Course_Category_Name as CategoryName  
from Tbl_Course_Category where Course_Category_Status=0  
order by CategoryName
  
end


');
END;