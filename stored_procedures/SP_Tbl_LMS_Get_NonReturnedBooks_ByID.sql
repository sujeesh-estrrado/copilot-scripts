IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_LMS_Get_NonReturnedBooks_ByID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_LMS_Get_NonReturnedBooks_ByID]  
        (@Issue_Book_Id bigint)  
        AS            
        BEGIN            
            SELECT 
                [Issue_Book_Id],      
                BI.[Book_Id],      
                [Issue_Date],      
                [Due_Date],      
                [Is_Returned],      
                [Return_Date],      
                [Candidate_or_Employee],      
                [Candidate_Employee_Id],      
                [Issue_Book_Status],      
                [Book_Title], 
                B.Book_Serial_No,
                CC.Course_Category_Name + ''-'' + D.Department_Name AS Department,     
                CASE 
                    WHEN Candidate_or_Employee = 0 THEN (Candidate_Fname + '' '' + Candidate_Mname + '' '' + Candidate_Lname)       
                    ELSE (Employee_FName + '' '' + Employee_LName) 
                END AS Name
            FROM [Tbl_LMS_Issue_Book] BI      
            INNER JOIN Tbl_AddBooks B ON BI.Book_Id = B.Book_Id        
            LEFT JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id = BI.Candidate_Employee_Id      
            LEFT JOIN Tbl_Employee E ON E.Employee_Id = BI.Candidate_Employee_Id     
            INNER JOIN Tbl_Student_Registration SR ON SR.Candidate_Id = C.Candidate_Id
            INNER JOIN Tbl_Department D ON D.Department_Id = SR.Department_Id
            INNER JOIN Tbl_Course_Category CC ON CC.Course_Category_Id = SR.Course_Category_Id
            WHERE Issue_Book_Id = @Issue_Book_Id 
                AND Issue_Book_Status = 0  
                AND Is_Returned = 0    
        END
    ')
END
