IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_ClubList]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Get_All_ClubList]
        AS
        BEGIN
            DECLARE @count BIGINT
            DECLARE @Mapcount BIGINT
            DECLARE @clubid BIGINT
            DECLARE @tempbatch VARCHAR(MAX)
            DECLARE @finalbatch VARCHAR(MAX)

            -- Create temporary table for club details
            CREATE TABLE #tab1 (
                id BIGINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
                Club_Name VARCHAR(100),
                Club_Id BIGINT,
                Depatment_Id BIGINT,
                Employee_Id BIGINT,
                Employee_Name VARCHAR(100),
                Department_Name VARCHAR(100),
                Status BIT,
                Batches VARCHAR(MAX)
            )

            -- Insert club information into #tab1
            INSERT INTO #tab1 (Club_Name, Club_Id, Depatment_Id, Employee_Id, Employee_Name, Department_Name, Status, Batches)
            SELECT 
                cl.Club_Name,
                cl.Club_Id,
                cl.Depatment_Id,
                e.Employee_Id,
                e.Employee_FName + '' '' + e.Employee_LName AS Employee_Name,
                dp.Department_Name,
                cl.Status,
                ''''
            FROM dbo.LMS_Tbl_Club cl
            INNER JOIN dbo.Tbl_Employee e ON e.Employee_Id = cl.Incharge_Id
            INNER JOIN dbo.Tbl_Course_Department cd ON cd.Course_Department_Id = cl.Depatment_Id
            INNER JOIN dbo.Tbl_Department dp ON dp.Department_Id = cd.Department_Id
            WHERE cl.Del_Status = 0

            -- Create temporary table for club batch mappings
            CREATE TABLE #tab2 (
                id BIGINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
                Mapping_Id BIGINT,
                Club_Id BIGINT,
                Batches VARCHAR(MAX)
            )

            -- Get the maximum ID from #tab1
            SET @count = (SELECT MAX(id) FROM #tab1)
            
            -- Process each club to map batches
            WHILE @count > 0
            BEGIN
                -- Clear #tab2 for the next club mapping
                TRUNCATE TABLE #tab2

                -- Get the Club_Id for current iteration
                SET @clubid = (SELECT Club_Id FROM #tab1 WHERE id = @count)

                -- Insert batch mapping data into #tab2
                INSERT INTO #tab2 (Mapping_Id, Club_Id, Batches)
                SELECT 
                    cm.Mapping_Id,
                    cm.Club_Id,
                    cbd.Batch_Code + '' '' + cs.Semester_Code AS Batches
                FROM dbo.LMS_Tbl_ClubBatch_Mapping cm
                INNER JOIN Tbl_Course_Duration_Mapping cdm ON cdm.Duration_Mapping_Id = cm.Batch_Id        
                INNER JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id        
                INNER JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = cdp.Batch_Id         
                INNER JOIN Tbl_Course_Semester cs ON cs.Semester_Id = cdp.Semester_Id
                WHERE cm.Club_Id = @clubid AND cm.Status = 0

                -- Get the max ID from #tab2
                SET @Mapcount = (SELECT MAX(id) FROM #tab2)
                SET @finalbatch = ''''

                -- Loop to concatenate all batches for the current club
                WHILE @Mapcount > 0
                BEGIN
                    -- Get the batch name from #tab2
                    SET @tempbatch = (SELECT Batches FROM #tab2 WHERE id = @Mapcount)

                    -- Append batch name to final batch string
                    IF @finalbatch = ''''
                    BEGIN
                        SET @finalbatch = @tempbatch
                    END
                    ELSE
                    BEGIN
                        SET @finalbatch = @finalbatch + '', '' + @tempbatch
                    END

                    -- Move to the next batch in #tab2
                    SET @Mapcount = @Mapcount - 1
                END

                -- Update the batch details for the current club in #tab1
                UPDATE #tab1
                SET Batches = @finalbatch
                WHERE id = @count

                -- Move to the next club in #tab1
                SET @count = @count - 1
            END
            
            -- Return the final result
            SELECT * FROM #tab1
        END
    ')
END
