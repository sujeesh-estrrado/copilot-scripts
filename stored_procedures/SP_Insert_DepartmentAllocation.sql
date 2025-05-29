IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_DepartmentAllocation]') 
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE PROCEDURE [dbo].[SP_Insert_DepartmentAllocation]
(
    @Employee_Id BIGINT,
    @Department_Id BIGINT,
    @Faculty_Id BIGINT,
    @Course_Id NVARCHAR(MAX), -- Comma-separated course IDs
    @Batch_Id BIGINT
)
AS
BEGIN
    DECLARE @Emp_DepartmentAllocation_Id BIGINT;
    
    -- Check if an allocation for this Employee_Id and Faculty_Id exists
    IF NOT EXISTS (
        SELECT 1 
        FROM Tbl_Emp_CourseDepartment_Allocation 
        WHERE Allocated_CourseDepartment_Id = @Faculty_Id 
          AND Employee_Id = @Employee_Id        
          AND Emp_DepartmentAllocation_Status = 0
    )
    BEGIN
        -- Insert into Tbl_Emp_CourseDepartment_Allocation and get the inserted ID
        INSERT INTO Tbl_Emp_CourseDepartment_Allocation (Employee_Id, Allocated_CourseDepartment_Id)          
        VALUES (@Employee_Id, @Faculty_Id);
        
        SET @Emp_DepartmentAllocation_Id = SCOPE_IDENTITY(); -- Get the last inserted ID
    END
    ELSE
    BEGIN
        -- Get existing Emp_DepartmentAllocation_Id
        SELECT @Emp_DepartmentAllocation_Id = Emp_DepartmentAllocation_Id 
        FROM Tbl_Emp_CourseDepartment_Allocation
        WHERE Allocated_CourseDepartment_Id = @Faculty_Id 
          AND Employee_Id = @Employee_Id        
          AND Emp_DepartmentAllocation_Status = 0;
    END;

    -- Insert into Tbl_Emp_Intake_Program_Course_Mapping for each Course_Id
    INSERT INTO Tbl_Emp_Intake_Program_Course_Mapping (
        Employee_Id, 
        Course_Department_Id, 
        Batch_Id, 
        Subject_Id, 
        Del_Status,
        Emp_DepartmentAllocation_Id  -- Store the allocated department ID
    )
    SELECT 
        @Employee_Id, 
        @Department_Id, 
        @Batch_Id, 
        CAST(TRIM([Value]) AS BIGINT), 
        0,
        @Emp_DepartmentAllocation_Id -- Use the captured ID
    FROM dbo.SplitStringFunction(@Course_Id, '','')
    WHERE TRIM([Value]) <> '''' 
      AND TRIM([Value]) IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM Tbl_Emp_Intake_Program_Course_Mapping
          WHERE Employee_Id = @Employee_Id
            AND Course_Department_Id = @Department_Id
            AND Batch_Id = @Batch_Id
            AND Subject_Id = CAST(TRIM([Value]) AS BIGINT)
            AND Del_Status=0
      ); -- Prevent duplicates
END;');
END;
