IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Student_Issued_Books_By_CandidateID]')
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[SP_Get_Student_Issued_Books_By_CandidateID]

@Candidate_Employee_Id bigint

AS

BEGIN

SELECT*  FROM [Tbl_LMS_Issue_Book] BI
          
INNER JOIN Tbl_AddBooks B ON BI.Book_Id=B.Book_Id  
          
LEFT JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id=BI.Candidate_Employee_Id 
    
LEFT JOIN Tbl_Student_Registration SR on SR.Candidate_Id=C.Candidate_Id   
             
LEFT JOIN Tbl_Course_Category CC on CC.Course_Category_Id=SR.Course_Category_Id
               
LEFT JOIN Tbl_Department D on D.Department_Id=SR.Department_Id 

WHERE Candidate_Employee_Id=@Candidate_Employee_Id

END

    ')
END;
