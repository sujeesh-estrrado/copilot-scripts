IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Lms_Reservaton_By_Book_Id_New_1]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Lms_Reservaton_By_Book_Id_New_1]  
    (@Book_Id BIGINT)  
AS  
BEGIN  
    SET NOCOUNT ON;

    -- Declare variables for performance improvement
    DECLARE @Latest_Issue_Book_Id BIGINT,
            @Latest_Return_Book_Id BIGINT,
            @Return_Date DATE,
            @Days_Since_Return INT,
            @Reservation_Days INT,
            @Book_Status VARCHAR(50);

    -- Get the latest issue book ID for the given book
    SELECT TOP 1 @Latest_Issue_Book_Id = Issue_Book_Id
    FROM Tbl_LMS_Issue_Book
    WHERE Book_Id = @Book_Id AND Issue_Book_Status = 0 AND Is_Returned = 0
    ORDER BY Issue_Book_Id DESC;

    -- Get the latest return book ID and return date
    SELECT TOP 1 
        @Latest_Return_Book_Id = Return_Book_Id,
        @Return_Date = Return_Date
    FROM Tbl_LMS_Return_Book
    WHERE Issue_Book_Id = @Latest_Issue_Book_Id;

    -- Calculate days since the book was returned
    SET @Days_Since_Return = DATEDIFF(DAY, @Return_Date, GETDATE());

    -- Get reservation days limit based on user type
    SELECT TOP 1 @Reservation_Days = Reservation_Days
    FROM Tbl_LMS_Reservation_Master
    WHERE Candidate_Or_Employee_Status = 0 AND Reservation_Master_Status = 0
    ORDER BY Reservation_Master_Id DESC;

    -- Determine book status
    IF EXISTS (SELECT 1 FROM Tbl_LMS_Issue_Book WHERE Book_Id = @Book_Id AND Issue_Book_Status = 0 AND Is_Returned = 0)
        SET @Book_Status = ''Issued'';
    ELSE IF EXISTS (
        SELECT 1 FROM Tbl_LMS_Lost_Stolen_Book WHERE Book_Id = @Book_Id AND Lost_Stolen_Status = 0 AND Is_LostReturn = 0
        UNION 
        SELECT 1 FROM Tbl_LMS_Book_Weeding WHERE Book_Id = @Book_Id AND Book_Weeding_Status = 0 AND Is_Returned = 0
    )
        SET @Book_Status = ''Not In Stock'';
    ELSE IF @Days_Since_Return > @Reservation_Days
        SET @Book_Status = ''Expired'';
    ELSE 
        SET @Book_Status = ''In Stock'';

    -- Fetch reservations
    SELECT  
        ROW_NUMBER() OVER (PARTITION BY R.Book_Id ORDER BY R.Reservation_Book_Id) AS Priority,  
        R.Reservation_Book_Id,  
        R.Book_Id,  
        R.Candidate_Or_Employee_Id,  
        R.Candidate_Or_Employee_Status,  
        R.Reservation_Date,  
        R.Reservation_Book_Status,  
        A.Book_Title,  
        COALESCE(C.Candidate_Fname + '' '' + C.Candidate_Mname + '' '' + C.Candidate_Lname, 
                 E.Employee_FName + '' '' + E.Employee_LName) AS [Name],  

        -- Issue Status
        CASE  
            WHEN @Book_Status = ''Issued'' OR @Book_Status = ''Not In Stock'' THEN ''0''
            ELSE ''1''
        END AS IssueStatus,  

        -- Final Book Status
        @Book_Status AS Status  

    FROM Tbl_Lms_Reservation_Books R  
    INNER JOIN Tbl_AddBooks A ON R.Book_Id = A.Book_Id  
    LEFT JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id = R.Candidate_Or_Employee_Id  
    LEFT JOIN Tbl_Employee E ON E.Employee_Id = R.Candidate_Or_Employee_Id  
    WHERE R.Reservation_Book_Status = 0  
        AND R.Book_Id = @Book_Id;

END;
    ');
END;
