IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Employee_By_Subject]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Employee_By_Subject]     
@Semester_Subject_Id bigint      
As      
Begin    
Select   
SP.Semester_Subject_Id,  
Employee_Id,  
S.Subject_Id,  
S.Subject_Name,  
@Semester_Subject_Id As Parent_Subject_Id  
from Tbl_Subject S  
Inner Join Tbl_Department_Subjects DS On S.Subject_Id=DS.Subject_Id  
Inner Join Tbl_Semester_Subjects SS On  SS.Department_Subjects_Id=DS.Department_Subject_Id  
Inner Join Tbl_Subject_Hours_PerWeek SP On Sp.Semester_Subject_Id=SS.Semester_Subject_Id  
Where  SS.Duration_Mapping_id=(Select Duration_Mapping_id From Tbl_Semester_Subjects Where Semester_Subject_Id=@Semester_Subject_Id) and Parent_Subject_Id=(Select  
 Sq.Subject_Id  
 From Tbl_Subject sq  
 Inner Join Tbl_Department_Subjects dsq on sq.Subject_Id=dsq.Subject_Id  
Inner Join Tbl_Semester_Subjects ssq on ssq.Department_Subjects_Id=dsq.Department_Subject_Id  
Where ssq.Semester_Subject_Id=@Semester_Subject_Id)  
End
'

);
END;
