IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Online_Reservation_Books_Get_All]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Online_Reservation_Books_Get_All]          
AS          
BEGIN   
    SELECT     
        ROW_NUMBER() OVER(PARTITION BY R.Book_Id ORDER BY Reservation_Book_Id) AS Priority,    
        R.[Reservation_Book_Id],          
        R.[Book_Id],          
        R.[Candidate_Or_Employee_Id],          
        R.[Candidate_Or_Employee_Status],          
        R.[Reservation_Date],          
        R.[Reservation_Book_Status],          
        A.[Book_Title],          
        CASE 
            WHEN R.Candidate_Or_Employee_Status = 0 THEN (C.Candidate_Fname + '' '' + C.Candidate_Mname + '' '' + C.Candidate_Lname)             
            ELSE (E.Employee_FName + '' '' + E.Employee_LName) 
        END AS [Name],        
        CASE       
            WHEN (
                (SELECT TOP 1 Issue_Reservation_Mapping_Id FROM Tbl_Lms_Issue_Reservation_Book_Mapping         
                WHERE Reservation_Book_Id = R.Reservation_Book_Id) IS NULL 
                AND
                (SELECT TOP 1 Return_Book_Id FROM Tbl_LMS_Return_Book 
                WHERE Issue_Book_Id = (
                    SELECT TOP 1 Issue_Book_Id FROM Tbl_LMS_Issue_Book 
                    WHERE Book_Id = R.[Book_Id] AND Issue_Book_Status = 0 
                    ORDER BY Issue_Book_Id DESC
                )) IS NOT NULL
            )
            AND
            ISNULL(
                (SELECT TOP 1 DATEDIFF(day, Return_Date, GETDATE())      
                FROM Tbl_LMS_Return_Book      
                WHERE Issue_Book_Id = (
                    SELECT TOP 1 Issue_Book_Id FROM Tbl_LMS_Issue_Book       
                    WHERE Book_Id = R.[Book_Id] AND Issue_Book_Status = 0 
                    ORDER BY Issue_Book_Id DESC
                )), 0) < 
                CASE 
                    WHEN R.Candidate_Or_Employee_Status = 0 THEN (
                        SELECT TOP 1 Reservation_Days FROM Tbl_LMS_Reservation_Master 
                        WHERE Candidate_Or_Employee_Status = 0 AND Reservation_Master_Status = 0 
                        ORDER BY Reservation_Master_Id DESC
                    )      
                    ELSE (
                        SELECT TOP 1 Reservation_Days FROM Tbl_LMS_Reservation_Master 
                        WHERE Candidate_Or_Employee_Status = 1 AND Reservation_Master_Status = 0 
                        ORDER BY Reservation_Master_Id DESC
                    ) 
                END      
            THEN ''1''      
            ELSE ''0'' 
        END AS IssueStatus,      
        CASE       
            WHEN (
                SELECT TOP 1 Issue_Reservation_Mapping_Id FROM Tbl_Lms_Issue_Reservation_Book_Mapping         
                WHERE Reservation_Book_Id = R.Reservation_Book_Id
            ) IS NOT NULL THEN ''Issued''      
            WHEN (
                SELECT TOP 1 Return_Book_Id FROM Tbl_LMS_Return_Book 
                WHERE Issue_Book_Id = (
                    SELECT TOP 1 Issue_Book_Id FROM Tbl_LMS_Issue_Book 
                    WHERE Book_Id = R.[Book_Id] AND Issue_Book_Status = 0 
                    ORDER BY Issue_Book_Id DESC
                )
            ) IS NULL THEN ''Not in Stock''      
            WHEN ISNULL(
                (SELECT TOP 1 DATEDIFF(day, Return_Date, GETDATE())      
                FROM Tbl_LMS_Return_Book      
                WHERE Issue_Book_Id = (
                    SELECT TOP 1 Issue_Book_Id FROM Tbl_LMS_Issue_Book       
                    WHERE Book_Id = R.[Book_Id] AND Issue_Book_Status = 0 
                    ORDER BY Issue_Book_Id DESC
                )), 0) > 
                CASE 
                    WHEN R.Candidate_Or_Employee_Status = 0 THEN (
                        SELECT TOP 1 Reservation_Days FROM Tbl_LMS_Reservation_Master 
                        WHERE Candidate_Or_Employee_Status = 0 AND Reservation_Master_Status = 0 
                        ORDER BY Reservation_Master_Id DESC
                    )      
                    ELSE (
                        SELECT TOP 1 Reservation_Days FROM Tbl_LMS_Reservation_Master 
                        WHERE Candidate_Or_Employee_Status = 1 AND Reservation_Master_Status = 0 
                        ORDER BY Reservation_Master_Id DESC
                    ) 
                END      
            THEN ''Expired''      
            ELSE ''In Stock'' 
        END AS Status      
    FROM Tbl_AddBooks A  
    LEFT JOIN [Tbl_Lms_Reservation_Books] R ON R.Book_Id = A.Book_Id        
    LEFT JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id = R.Candidate_Or_Employee_Id            
    LEFT JOIN Tbl_Employee E ON E.Employee_Id = R.Candidate_Or_Employee_Id  
END
');
END