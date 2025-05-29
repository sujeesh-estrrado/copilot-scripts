IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Grade_Salary]') 
    AND type = N'P'
)
BEGIN
    EXEC('
      CREATE procedure [dbo].[SP_GetAll_Grade_Salary]            
         
AS            
Set NoCount ON            
BEGIN            
 Select * from          
(SELECT     
Row_Number() Over (partition by Grade_Id order by Grade_Id) As rno,         
            Tbl_Grade_Salary.Grade_Id,       
  
            Tbl_Grade_Salary.Grade_Sal_Id,   
                 
           Tbl_Grade_Salary.Basic_Salary,         
                    
                  
           Tbl_Employee_Grade.Emp_Grade_Name  ,      
               
            Tbl_Grade_Salary.Total_Salary      
          
FROM         dbo.Tbl_Grade_Salary         
INNER JOIN dbo.Tbl_Employee_Grade ON dbo.Tbl_Grade_Salary.Grade_Id = dbo.Tbl_Employee_Grade.Emp_Grade_Id         
--INNER JOIN dbo.Tbl_Salary_Head ON dbo.Tbl_Grade_Salary.Salary_Head_ID = dbo.Tbl_Salary_Head.Salary_Head_Id            
WHERE     (dbo.Tbl_Grade_Salary.GradeSal_Delete_Status = 0) AND (dbo.Tbl_Employee_Grade.Emp_Grade_Status = 0)         
--                   AND   (dbo.Tbl_Salary_Head.Salary_head_Delete_Status = 0)            
) t
Where t.rno=1
order by Grade_Sal_Id desc

            
END





    ')
END
