IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Employee_Working_Hours_GetAll]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Employee_Working_Hours_GetAll] 
        AS
        BEGIN
            SELECT 
                CC.Course_Category_Name + ''-'' + D.Department_Name AS CourseDepartment, 
                Allocated_CourseDepartment_Id
            FROM
                Tbl_Employee_Working_Hours W
            INNER JOIN Tbl_Emp_CourseDepartment_Allocation EC ON EC.Employee_Id = W.Employee_Id
            INNER JOIN Tbl_Course_Department CD ON EC.Allocated_CourseDepartment_Id = CD.Course_Department_Id
            INNER JOIN Tbl_Course_Category CC ON CD.Course_Category_Id = CC.Course_Category_Id
            INNER JOIN Tbl_Department D ON D.Department_Id = CD.Department_Id
            WHERE 
                CD.Course_Department_Status = 0
                AND CC.Course_Category_Status = 0
                AND D.Department_Status = 0
        END
    ')
END
