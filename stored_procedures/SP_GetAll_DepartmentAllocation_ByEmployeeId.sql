IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_DepartmentAllocation_ByEmployeeId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_GetAll_DepartmentAllocation_ByEmployeeId]
(
    @flag BIGINT = 0,  
    @CurrentPage INT = 1, -- Default to page 1
    @PageSize BIGINT = 10 -- Default page size to 10
)
AS      
BEGIN      
    IF (@flag = 0) -- Fetch paginated data
    BEGIN  
        DECLARE @LowerBand INT;
        DECLARE @UpperBand INT;

        -- Calculate pagination bounds
        SET @LowerBand = (@CurrentPage - 1) * @PageSize;
        SET @UpperBand = @CurrentPage * @PageSize;

        -- CTE to pre-aggregate distinct courses
        WITH DistinctCourses AS (
            SELECT DISTINCT
                ECA.Emp_DepartmentAllocation_Id,
                NC.Course_Id,
                NC.Course_Name
            FROM Tbl_Emp_CourseDepartment_Allocation ECA
            INNER JOIN Tbl_Emp_Intake_Program_Course_Mapping CTM ON ECA.Emp_DepartmentAllocation_Id = CTM.Emp_DepartmentAllocation_Id 
            INNER JOIN Tbl_New_Course NC ON CTM.Subject_Id = NC.Course_Id
            WHERE NC.Delete_Status = 0 AND CTM.Del_Status = 0
        ),
        CTE AS (
            SELECT 
                ROW_NUMBER() OVER (ORDER BY ECA.Emp_DepartmentAllocation_Id DESC) AS RowNumber,
                ECA.Employee_Id,  
                CONCAT(E.Employee_FName, '' '', E.Employee_LName) AS EmployeeName,    
                ECA.Emp_DepartmentAllocation_Id,  
                ED.Dept_Name,    
                ECA.Allocated_CourseDepartment_Id,    
                CD.Course_Level_Name AS SubDept,
                STRING_AGG(DC.Course_Id, '', '') AS Course_Id,
                STRING_AGG(DC.Course_Name, '', '') AS CourseNames
            FROM 
                Tbl_Emp_CourseDepartment_Allocation ECA    
                INNER JOIN Tbl_Employee E ON E.Employee_Id = ECA.Employee_Id    
                LEFT JOIN dbo.Tbl_Employee_Official EO ON EO.Employee_Id = E.Employee_Id    
                LEFT JOIN Tbl_Emp_Department ED ON ED.Dept_Id = EO.Department_Id     
                LEFT JOIN Tbl_Course_Level CD ON CD.Course_Level_Id = ECA.Allocated_CourseDepartment_Id
                LEFT JOIN DistinctCourses DC ON ECA.Emp_DepartmentAllocation_Id = DC.Emp_DepartmentAllocation_Id
            WHERE 
                ISNULL(Emp_DepartmentAllocation_Status,0) = 0 
                AND E.Employee_Status = 0
            GROUP BY 
                ECA.Employee_Id, E.Employee_FName, E.Employee_LName, 
                ECA.Emp_DepartmentAllocation_Id, ED.Dept_Name, 
                ECA.Allocated_CourseDepartment_Id, CD.Course_Level_Name
        )
        SELECT 
            Emp_DepartmentAllocation_Id,
            Employee_Id,
            EmployeeName,
            Dept_Name,
            Allocated_CourseDepartment_Id,
            SubDept,
            CourseNames
        FROM 
            CTE
        WHERE 
            RowNumber > @LowerBand 
            AND RowNumber <= @UpperBand
        ORDER BY RowNumber;
    END;
    IF (@flag = 1) -- Fetch total count of records
    BEGIN
SELECT COUNT(*) AS TotalCount
FROM (
    SELECT DISTINCT 
        ECA.Emp_DepartmentAllocation_Id
    FROM Tbl_Emp_CourseDepartment_Allocation ECA    
        INNER JOIN Tbl_Employee E ON E.Employee_Id = ECA.Employee_Id    
        LEFT JOIN dbo.Tbl_Employee_Official EO ON EO.Employee_Id = E.Employee_Id    
        LEFT JOIN Tbl_Emp_Department ED ON ED.Dept_Id = EO.Department_Id     
        LEFT JOIN Tbl_Course_Level CD ON CD.Course_Level_Id = ECA.Allocated_CourseDepartment_Id  
        INNER JOIN Tbl_Emp_Intake_Program_Course_Mapping CTM ON ECA.Emp_DepartmentAllocation_Id = CTM.Emp_DepartmentAllocation_Id
    WHERE 
        ISNULL(Emp_DepartmentAllocation_Status,0) = 0 
        AND E.Employee_Status = 0
                AND CTM.Del_Status=0
) AS DistinctAllocations;
    END;
END;
');
END;