-- Check if the stored procedure [dbo].[Proc_Insert_Employee_Mapping] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_Employee_Mapping]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Insert_Employee_Mapping]
        (
            @Employee_Id BIGINT,
            @Employee_Education_Id BIGINT,
            @Employee_Experience_Id BIGINT,
            @Employee_Official_Id BIGINT
        )
        AS
        BEGIN
            -- Declare local variables for employee ID, education ID, experience ID, and official ID
            DECLARE @EmpID BIGINT, @EmpExpID BIGINT, @EmpEduID BIGINT, @EmpOffID BIGINT;
            
            -- Insert the new employee mapping into the Tbl_Employee_Mapping table
            INSERT INTO Tbl_Employee_Mapping (Employee_Id, Employee_Education_Id, Employee_Experience_Id, Employee_Official_Id)
            VALUES (@Employee_Id, @Employee_Education_Id, @Employee_Experience_Id, @Employee_Official_Id);
        END
    ')
END
