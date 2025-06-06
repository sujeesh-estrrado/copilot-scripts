IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_Calendar_By_Emp_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_Get_Calendar_By_Emp_Id]                    
@Emp_Id bigint                  
AS                  
BEGIN                  
SELECT     
--[Type],    
Case When [Type]=''Assignment'' Then (Select Assignment_Title From LMS_Tbl_Assignment Where Assignment_Id=Type_Id)    
When [Type]=''Quiz'' Then (Select Quiz_Name From LMS_Tbl_Quiz Where Quiz_Id=Type_Id)    
When [Type]=''Exam'' Then (Select Exam_Name From LMS_Tbl_Exams Where Exams_Id=Type_Id)    
End    
As Title,    
Case When [Type]=''Assignment'' Then (Select Due_Date From LMS_Tbl_Assignment Where Assignment_Id=Type_Id)    
When [Type]=''Quiz'' Then (Select Quiz_Due_Date From LMS_Tbl_Quiz Q Inner Join LMS_Tbl_Quiz_Send Qs    
on Q.Quiz_Id=QS.Quiz_Id Where Q.Quiz_Id=Type_Id)    
When [Type]=''Exam'' Then (Select Exam_Due_Date From LMS_Tbl_Exams E Inner Join LMS_Tbl_Exam_Send ES    
On E.Exams_Id=ES.Exams_Id  Where E.Exams_Id=Type_Id)    
End    
As DueDate    
From  LMS_Tbl_Emloyee_Notification Where Emp_Id=@Emp_Id    
          
    
Union    
Select      
Task_Title  As Title,    
Task_Date As DueDate    
From LMS_Tbl_Employee_Task     
Where Employee_Id=@Emp_Id    
  
Union  
SELECT   
''Library Due'',         
[Due_Date]                
       
  FROM [Tbl_LMS_Issue_Book] BI                
INNER JOIN Tbl_AddBooks B ON BI.Book_Id=B.Book_Id                  
WHERE Issue_Book_Status=0  and Is_Returned=0               
and Candidate_or_Employee =1 and Candidate_Employee_Id=@Emp_Id   
  
  
             
END
    ')
END
