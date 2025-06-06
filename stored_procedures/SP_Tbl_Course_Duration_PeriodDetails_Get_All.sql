IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Course_Duration_PeriodDetails_Get_All]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Course_Duration_PeriodDetails_Get_All] --0,1,10,''2019/10-FIS''  
            @facultyid bigint = 0,  
            @CurrentPage bigint = 0,  
            @pagesize bigint = 0,  
            @SearchKeyWord varchar(max)  
        AS                  
        BEGIN    
            IF(@facultyid = 0)  
            BEGIN    
                SELECT * FROM (
                    SELECT
                        ROW_NUMBER() OVER (PARTITION BY cd.Duration_Period_Id ORDER BY cd.Duration_Period_Id) AS num,
                        cd.Duration_Period_Id,
                        cd.Batch_Id,
                        cd.Semester_Id,
                        CONVERT(varchar(50), Duration_Period_From, 103) AS Duration_Period_From,
                        CONVERT(varchar(50), Duration_Period_To, 103) AS Duration_Period_To,
                        Duration_Period_Status,
                        Semester_Name,
                        Batch_Code,
                        CONVERT(varchar(50), Closing_Date, 103) AS Closing_Date,
                        CC.Course_Category_Name + ''-'' + D.Department_Name AS DepartmentName,
                        D.Department_Id AS ProgramID,
                        CL.Course_Level_Name
                    FROM Tbl_Course_Duration_PeriodDetails cd                   
                    LEFT JOIN Tbl_Course_Batch_Duration bd ON cd.Batch_Id = bd.Batch_Id                  
                    LEFT JOIN Tbl_Course_Semester cs ON cs.Semester_Id = cd.Semester_Id                 
                    LEFT JOIN Tbl_Course_Duration_Mapping CDM ON CDM.Duration_Period_Id = cd.Duration_Period_Id                 
                    LEFT JOIN Tbl_Course_Department Cdep ON Cdep.Department_Id = CDM.Course_Department_Id               
                    LEFT JOIN Tbl_Course_Category CC ON CC.Course_Category_Id = Cdep.Course_Category_Id                
                    LEFT JOIN Tbl_Department D ON D.Department_Id = Cdep.Department_Id    
                    INNER JOIN Tbl_Course_Level CL ON D.GraduationTypeId = CL.Course_Level_Id                 
                    WHERE Duration_Period_Status = 0 
                    AND (
                        cd.Duration_Period_Id LIKE ''%'' + @SearchKeyWord + ''%'' 
                        OR cd.Batch_Id LIKE ''%'' + @SearchKeyWord + ''%'' 
                        OR Batch_Code LIKE ''%'' + @SearchKeyWord + ''%'' 
                        OR cd.Semester_Id LIKE ''%'' + @SearchKeyWord + ''%'' 
                        OR cd.Duration_Period_From LIKE ''%'' + @SearchKeyWord + ''%''    
                        OR cd.Duration_Period_To LIKE ''%'' + @SearchKeyWord + ''%'' 
                        OR CONCAT(CC.Course_Category_Name, ''-'', D.Department_Name) LIKE ''%'' + @SearchKeyWord + ''%''  
                        OR CL.Course_Level_Name LIKE ''%'' + @SearchKeyWord + ''%''
                    ) 
                ) tbl                                    
                WHERE tbl.num = 1              
                ORDER BY Duration_Period_Id DESC   
                OFFSET @pagesize * (@CurrentPage - 1) ROWS  
                FETCH NEXT @pagesize ROWS ONLY OPTION (RECOMPILE);                
            END   
            ELSE  
            BEGIN  
                SELECT * FROM (
                    SELECT
                        ROW_NUMBER() OVER (PARTITION BY cd.Duration_Period_Id ORDER BY cd.Duration_Period_Id) AS num,
                        cd.Duration_Period_Id,
                        cd.Batch_Id,
                        cd.Semester_Id,
                        CONVERT(varchar(50), Duration_Period_From, 103) AS Duration_Period_From,
                        CONVERT(varchar(50), Duration_Period_To, 103) AS Duration_Period_To,
                        Duration_Period_Status,
                        Semester_Name,
                        Batch_Code,
                        CONVERT(varchar(50), Closing_Date, 103) AS Closing_Date,
                        CC.Course_Category_Name + ''-'' + D.Department_Name AS DepartmentName,
                        D.Department_Id AS ProgramID,
                        CL.Course_Level_Name
                    FROM Tbl_Course_Duration_PeriodDetails cd                   
                    LEFT JOIN Tbl_Course_Batch_Duration bd ON cd.Batch_Id = bd.Batch_Id                  
                    LEFT JOIN Tbl_Course_Semester cs ON cs.Semester_Id = cd.Semester_Id                 
                    LEFT JOIN Tbl_Course_Duration_Mapping CDM ON CDM.Duration_Period_Id = cd.Duration_Period_Id                 
                    LEFT JOIN Tbl_Course_Department Cdep ON Cdep.Department_Id = CDM.Course_Department_Id               
                    LEFT JOIN Tbl_Course_Category CC ON CC.Course_Category_Id = Cdep.Course_Category_Id                
                    LEFT JOIN Tbl_Department D ON D.Department_Id = Cdep.Department_Id    
                    INNER JOIN Tbl_Course_Level CL ON D.GraduationTypeId = CL.Course_Level_Id  
                    INNER JOIN Tbl_Emp_CourseDepartment_Allocation ED ON ED.Allocated_CourseDepartment_Id = D.GraduationTypeId                
                    WHERE Duration_Period_Status = 0 
                    AND ED.Employee_Id = @facultyid   
                    AND (
                        cd.Duration_Period_Id LIKE ''%'' + @SearchKeyWord + ''%'' 
                        OR cd.Batch_Id LIKE ''%'' + @SearchKeyWord + ''%'' 
                        OR cd.Semester_Id LIKE ''%'' + @SearchKeyWord + ''%'' 
                        OR cd.Duration_Period_From LIKE ''%'' + @SearchKeyWord + ''%''    
                        OR cd.Duration_Period_To LIKE ''%'' + @SearchKeyWord + ''%'' 
                        OR CONCAT(CC.Course_Category_Name, ''-'', D.Department_Name) LIKE ''%'' + @SearchKeyWord + ''%''  
                        OR Batch_Code LIKE ''%'' + @SearchKeyWord + ''%'' 
                        OR CL.Course_Level_Name LIKE ''%'' + @SearchKeyWord + ''%''
                    )   
                ) tbl                                    
                WHERE tbl.num = 1               
                ORDER BY Duration_Period_Id DESC  
                OFFSET @pagesize * (@CurrentPage - 1) ROWS  
                FETCH NEXT @pagesize ROWS ONLY OPTION (RECOMPILE);  
            END       
        END
    ')
END
