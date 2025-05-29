IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetAll_Library_Fine_By_Employee_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_GetAll_Library_Fine_By_Employee_Id]   
        @Employee_Id BIGINT          
        AS            
        BEGIN            
            SELECT 
                [Issue_Book_Id],              
                BI.[Book_Id] AS Bookid,              
                [Issue_Date],    
                B.Book_Code,             
                [Due_Date],              
                [Is_Returned],              
                [Return_Date],              
                [Issue_Book_Status],              
                [Book_Title],        
                B.Book_Serial_No,            
                CASE 
                    WHEN Candidate_or_Employee = 1 THEN 
                        ISNULL(Candidate_Fname, '''') + '' '' + 
                        ISNULL(Candidate_Mname, '''') + '' '' + 
                        ISNULL(Candidate_Lname, '''')
                    ELSE 
                        ISNULL(Employee_FName, '''') + '' '' + 
                        ISNULL(Employee_LName, '''')
                END AS Name   
            FROM 
                [Tbl_LMS_Issue_Book] BI              
                INNER JOIN Tbl_AddBooks B 
                    ON BI.Book_Id = B.Book_Id                
                LEFT JOIN Tbl_Candidate_Personal_Det C 
                    ON C.Candidate_Id = BI.Candidate_Employee_Id            
                LEFT JOIN Tbl_Candidate_ContactDetails CP 
                    ON CP.Candidate_Id = BI.Candidate_Employee_Id           
                LEFT JOIN Tbl_Employee E 
                    ON E.Employee_Id = BI.Candidate_Employee_Id              
            WHERE 
                Issue_Book_Status = 0  
                AND Is_Returned = 0 
                AND CAST(Due_Date AS DATE) < CAST(GETDATE() AS DATE)            
                AND Candidate_or_Employee = 1 
                AND Candidate_Employee_Id = @Employee_Id    
        END
    ')
END
