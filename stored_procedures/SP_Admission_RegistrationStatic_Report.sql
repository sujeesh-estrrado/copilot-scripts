IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Admission_RegistrationStatic_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Admission_RegistrationStatic_Report]  
        (   
            @flag bigint = 0, 
            @Intake_Id bigint = 0,
            @Organization bigint = 0
        )
        AS      
        BEGIN 
            IF(@flag = 1)
            BEGIN
                CREATE TABLE #tempdept(Department_Id bigint, Department_Name varchar(MAX))
                INSERT INTO #tempdept (Department_Id, Department_Name)
                (
                    SELECT DISTINCT D.Department_Id, D.Course_Code + '' - '' + D.Department_Name + '' ( '' + L.Course_Level_Name + '' ) ''
                    AS Department_Name
                    FROM Tbl_Department D 
                    LEFT JOIN Tbl_Course_Level L ON D.GraduationTypeId = L.Course_Level_Id
                    LEFT JOIN tbl_New_Admission N ON N.Department_Id = D.Department_Id
                    LEFT JOIN Tbl_Candidate_Personal_Det P ON P.New_Admission_Id = N.New_Admission_Id
                    WHERE Department_status = 0 AND D.Delete_status = 0 
                    AND P.ApplicationStatus = ''Completed''
                )

                -- Further table creation and insertion logic as in your original code
                -- Create and insert data into #tempallcount, #tempBumiputraSabahfemale, etc.
                -- The rest of the logic goes here for processing the admission statistics

                -- Final selection statement for the report
                SELECT * FROM #TEMP3 t 
                LEFT JOIN #tempgrandsum s ON t.Department_Id = s.Department_Id
                LEFT JOIN #tempfsum f ON t.Department_Id = f.Department_Id
                LEFT JOIN #tempmsum m ON t.Department_Id = m.Department_Id

            END
        END
    ')
END
