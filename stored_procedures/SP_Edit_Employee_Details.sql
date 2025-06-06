IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Edit_Employee_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Edit_Employee_Details]
        (
            @Employee_Id BIGINT
        )
        AS
        BEGIN
            SELECT 
                TCA.Employee_Id, 
                TCA.Allocated_CourseDepartment_Id,
                TIP.Course_Department_Id AS Course_Department_Id,
                TIP.Batch_Id AS Duration_Mapping_Id,
                STRING_AGG(TIP.Subject_Id, '','') AS Course_Id
            FROM 
                Tbl_Emp_CourseDepartment_Allocation TCA
            INNER JOIN 
                Tbl_Emp_Intake_Program_Course_Mapping TIP 
                ON TCA.Employee_Id = TIP.Employee_Id 
                AND TCA.Allocated_CourseDepartment_Id = TIP.Course_Department_Id
            WHERE 
                TCA.Emp_DepartmentAllocation_Id = @Employee_Id
            GROUP BY 
                TCA.Employee_Id, 
                TCA.Allocated_CourseDepartment_Id, 
                TIP.Course_Department_Id, 
                TIP.Batch_Id
        END
    ')
END
