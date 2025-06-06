IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_LMS_Issue_Book_Select_All]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_LMS_Issue_Book_Select_All] 
        AS 
        BEGIN

            SELECT ROW_NUMBER() OVER (ORDER BY BI.Book_Id) AS RowNumber,  
                [Issue_Book_Id],
                BI.[Book_Id], 
                B.Book_Id AS ID,
                B.Book_Author AS Author,   
                B.Book_Code,
                BC.Category_Name AS [Category Name],
                B.Book_Serial_No,
                BSC.SubCategory_Name AS [SubCategory],
                BC.Category_Id AS [CategoryId],
                BSC.SubCategory_Id AS [SubCategoryId],
                BP.Publisher_Name AS [Publisher],
                B.Book_Title,  
                B.Book_Title + ''-'' + B.Book_Serial_No AS Title,
                B.Book_Author,
                BSC.SubCategory_Name,
                [Issue_Date],
                [Due_Date],
                CASE 
                    WHEN [Is_Returned] = 1 THEN CONVERT(VARCHAR(10), [Return_Date], 3) 
                    ELSE '''' 
                END AS ReturnDate_new,
                [Return_Date],
                [Candidate_or_Employee],
                [Candidate_Employee_Id],
                [Issue_Book_Status],
                [Book_Title],
                B.Book_Serial_No,
                [Is_Returned],
                CASE 
                    WHEN Candidate_or_Employee = 0 THEN (Candidate_Fname + '' '' + Candidate_Mname + '' '' + Candidate_Lname)                 
                    ELSE (Employee_FName + '' '' + Employee_LName) 
                END AS Name,
                CASE 
                    WHEN Is_Returned = 0 THEN ''Not Returned''
                    ELSE ''Returned'' 
                END AS Status,
                CASE 
                    WHEN Candidate_or_Employee = 0 THEN (CC.Course_Category_Name + ''-'' + D.Department_Name)                 
                    ELSE (ED.Dept_Name) 
                END AS Department

            FROM [Tbl_LMS_Issue_Book] BI
            INNER JOIN Tbl_AddBooks B ON BI.Book_Id = B.Book_Id
            LEFT JOIN Tbl_BookCategory BC ON B.Category_Id = BC.Category_Id
            LEFT JOIN Tbl_Book_SubCategory BSC ON B.SubCategory_Id = BSC.SubCategory_Id
            LEFT JOIN Tbl_Book_Publisher BP ON B.Publisher_Id = BP.Publisher_Id
            LEFT JOIN Tbl_Book_Almeria_Rack BAR ON B.Almeria_Rack_Id = BAR.Almeria_Rack_Id
            LEFT JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id = BI.Candidate_Employee_Id
            LEFT JOIN Tbl_Student_Registration SR ON SR.Candidate_Id = C.Candidate_Id
            LEFT JOIN Tbl_Course_Category CC ON CC.Course_Category_Id = SR.Course_Category_Id
            LEFT JOIN Tbl_Department D ON D.Department_Id = SR.Department_Id
            LEFT JOIN Tbl_Employee E ON E.Employee_Id = BI.Candidate_Employee_Id
            LEFT JOIN dbo.Tbl_Employee_Official EO ON EO.Employee_Id = E.Employee_Id
            LEFT JOIN dbo.Tbl_Emp_Department ED ON ED.Dept_Id = EO.Department_Id
            WHERE Issue_Book_Status = 0
        END
    ')
END
