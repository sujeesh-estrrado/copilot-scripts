IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Book_Reservation_Details_By_Book_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Get_Book_Reservation_Details_By_Book_Id]     
            @Book_Id bigint    
        AS    
        BEGIN    
            SELECT 
                ROW_NUMBER() OVER (ORDER BY RB.Reservation_Book_Id) AS Priority,
                RB.*,    
                A.[Book_Title], 
                CASE 
                    WHEN RB.Candidate_Or_Employee_Status = 0 
                    THEN (Candidate_Fname + '' '' + Candidate_Mname + '' '' + Candidate_Lname)      
                    ELSE (Employee_FName + '' '' + Employee_LName) 
                END AS [Name],
                
                --Check Issued    
                CASE   
                    WHEN EXISTS(SELECT * FROM Tbl_LMS_Issue_Book WHERE Book_Id = RB.Book_Id AND Is_Returned = 0) THEN ''Issued'' 
                    WHEN EXISTS(SELECT * FROM Tbl_LMS_Lost_Stolen_Book WHERE Book_Id = RB.Book_Id AND Lost_Stolen_Status = 0) THEN ''Lost'' 
                    WHEN EXISTS(SELECT * FROM Tbl_LMS_Book_Weeding WHERE Book_Id = RB.Book_Id AND Is_Returned = 0) THEN ''Weeding'' 
                    ELSE ''Available'' 
                END AS Status,
                
                CASE   
                    WHEN EXISTS(SELECT * FROM Tbl_LMS_Issue_Book WHERE Book_Id = RB.Book_Id AND Is_Returned = 0) THEN ''1'' 
                    WHEN EXISTS(SELECT * FROM Tbl_LMS_Lost_Stolen_Book WHERE Book_Id = RB.Book_Id AND Is_LostReturn = 0) THEN ''0'' 
                    WHEN EXISTS(SELECT * FROM Tbl_LMS_Book_Weeding WHERE Book_Id = RB.Book_Id AND Is_Returned = 0) THEN ''1'' 
                    ELSE ''1'' 
                END AS IssueStatus
            FROM dbo.Tbl_Lms_Reservation_Books RB 
            INNER JOIN Tbl_AddBooks A ON RB.Book_Id = A.Book_Id      
            LEFT JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id = RB.Candidate_Or_Employee_Id      
            LEFT JOIN Tbl_Employee E ON E.Employee_Id = RB.Candidate_Or_Employee_Id  
            WHERE    
                -- To check current reservations    
                NOT EXISTS (    
                    SELECT * 
                    FROM dbo.Tbl_Lms_Issue_Reservation_Book_Mapping 
                    WHERE Reservation_Book_Id = RB.Reservation_Book_Id    
                )    
                AND RB.Book_Id = @Book_Id 
                AND RB.Reservation_Book_Status = 0      
                AND    
                -- To check whether Reservation Priority Expired     
                ISNULL (      
                    (    
                        SELECT TOP 1 DATEDIFF(day, Return_Date, GETDATE())      
                        FROM Tbl_LMS_Return_Book      
                        WHERE Issue_Book_Id =    
                            (SELECT TOP 1 Issue_Book_Id FROM Tbl_LMS_Issue_Book      
                            WHERE Book_Id = RB.Book_Id AND Issue_Book_Status = 0 ORDER BY Issue_Book_Id DESC)    
                    ), 0    
                ) <      
                CASE 
                    WHEN RB.Candidate_Or_Employee_Status = 0      
                    THEN     
                        (    
                            SELECT TOP 1 Reservation_Days 
                            FROM Tbl_LMS_Reservation_Master 
                            WHERE Candidate_Or_Employee_Status = 0 
                            AND Reservation_Master_Status = 0 
                            ORDER BY Reservation_Master_Id DESC    
                        )      
                    ELSE     
                        (    
                            SELECT TOP 1 Reservation_Days 
                            FROM Tbl_LMS_Reservation_Master 
                            WHERE Candidate_Or_Employee_Status = 1 
                            AND Reservation_Master_Status = 0 
                            ORDER BY Reservation_Master_Id DESC    
                        )    
                END    
            ORDER BY RB.Reservation_Book_Id     
        END
    ')
END
