IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_StudentAttendance_Period_Wise]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Insert_StudentAttendance_Period_Wise]      
(              
    @Candidate_Id BIGINT,               
    @Absent_Date  DATETIME,              
    @Duration_Mapping_Id BIGINT,       
    @Class_Timings_Id BIGINT,        
    @Absent_Type VARCHAR(150),      
    @Course_Department_Id BIGINT,      
    @Subject_Id BIGINT,
    @Remark NVARCHAR(MAX),
    @EmployeeId BIGINT
)              
AS              
BEGIN      


    --IF NOT EXISTS (
    --    SELECT 1 
    --    FROM Tbl_Student_Absence 
    --    WHERE 
    --        Candidate_Id = @Candidate_Id 
    --        AND Absent_Date = @Absent_Date 
    --        AND Duration_Mapping_Id = @Duration_Mapping_Id 
    --        AND Class_Timings_Id = @Class_Timings_Id 
    --        AND Absent_Type = @Absent_Type 
    --        AND Course_Department_Id = @Course_Department_Id 
    --        AND Subject_Id = @Subject_Id 
    --        AND employee_Id = @EmployeeId
    --)
    --BEGIN

        --INSERT INTO Tbl_Student_Absence              
        --(Candidate_Id, Duration_Mapping_Id, Absent_Date, Class_Timings_Id, Absent_Type, Course_Department_Id, Subject_Id, Remark, employee_Id)                
        --VALUES                
        --(@Candidate_Id, @Duration_Mapping_Id, @Absent_Date, @Class_Timings_Id, @Absent_Type, @Course_Department_Id, @Subject_Id, @Remark, @EmployeeId) 
		

		  IF EXISTS (
        SELECT 1 
        FROM Tbl_Student_Absence 
        WHERE 
            Candidate_Id = @Candidate_Id 
            AND Absent_Date = @Absent_Date 
            AND Subject_Id = @Subject_Id 
			And Class_Timings_Id=@Class_Timings_Id
            AND Employee_Id <> @EmployeeId
    )
    BEGIN 
        SELECT ''WRONG'' AS Result
        RETURN
    END

    -- If no such record exists, proceed with the insertion
    INSERT INTO Tbl_Student_Absence              
    (Candidate_Id, Duration_Mapping_Id, Absent_Date, Class_Timings_Id, Absent_Type, Course_Department_Id, Subject_Id, Remark, Employee_Id)                
    VALUES                
    (@Candidate_Id, @Duration_Mapping_Id, @Absent_Date, @Class_Timings_Id, @Absent_Type, @Course_Department_Id, @Subject_Id, @Remark, @EmployeeId)                
	 
END
    ');
END;
