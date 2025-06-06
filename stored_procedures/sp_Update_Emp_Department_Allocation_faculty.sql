IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Update_Emp_Department_Allocation_faculty]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE PROCEDURE [dbo].[sp_Update_Emp_Department_Allocation_faculty] 
    @Emp_DepartmentAllocation_Id INT,
    @Employee_Id INT,
    @New_Course_Department_Id INT,
    @New_Batch_Id INT,
    @New_Subject_Id NVARCHAR(MAX), -- Comma-separated subject IDs
    @Faculty_Id INT
AS
BEGIN
    

    -- Temporary Table to Hold Split Subject IDs
    --DECLARE @SubjectTable TABLE (Subject_Id NVARCHAR(MAX));

    ---- Insert split values into the temporary table
    --INSERT INTO @SubjectTable (Subject_Id)
    --SELECT Value FROM dbo.SplitStringFunction(@New_Subject_Id, '','');
    update Tbl_Emp_Intake_Program_Course_Mapping set Del_Status=1 where Emp_DepartmentAllocation_Id=@Emp_DepartmentAllocation_Id;
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
        @New_Course_Department_Id, 
        @New_Batch_Id, 
        CAST(TRIM([Value]) AS BIGINT), 
        0,
        @Emp_DepartmentAllocation_Id -- Use the captured ID
    FROM dbo.SplitStringFunction(@New_Subject_Id, '','')
    WHERE TRIM([Value]) <> '''' 
      AND TRIM([Value]) IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM Tbl_Emp_Intake_Program_Course_Mapping
          WHERE Employee_Id = @Employee_Id
            AND Course_Department_Id = @New_Course_Department_Id
            AND Batch_Id = @New_Batch_Id
            AND Subject_Id = CAST(TRIM([Value]) AS BIGINT)
            AND Del_Status=0
      );
    -- Update Tbl_Emp_Intake_Program_Course_Mapping
    --UPDATE T
    --SET 
    --    T.Employee_Id = @Employee_Id,
    --    T.Course_Department_Id = @New_Course_Department_Id,
    --    T.Batch_Id = @New_Batch_Id,
    --    T.Subject_Id = S.Subject_Id
    --FROM Tbl_Emp_Intake_Program_Course_Mapping T
    --INNER JOIN @SubjectTable S ON 1 = 1 -- Assuming you need to set multiple subject values
    
    --WHERE T.Emp_DepartmentAllocation_Id = @Emp_DepartmentAllocation_Id;



    -- Update Tbl_Emp_CourseDepartment_Allocation
    UPDATE Tbl_Emp_CourseDepartment_Allocation
    SET Employee_Id = @Employee_Id,
        Allocated_CourseDepartment_Id = @Faculty_Id
    WHERE Emp_DepartmentAllocation_Id = @Emp_DepartmentAllocation_Id;
END;
    ')
END
