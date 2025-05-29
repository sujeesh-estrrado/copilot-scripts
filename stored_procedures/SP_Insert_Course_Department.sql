IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Course_Department]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_Insert_Course_Department]               
    (
        @Course_Category_Id BIGINT,
        @Department_Id BIGINT,
        @Course_Department_Description VARCHAR(500),              
        @Course_Department_Date DATETIME,
        @ProviderCode BIGINT
    )              
    AS              
    BEGIN
        

        -- Check if the department already exists for the given course category
        IF EXISTS (
            SELECT 1 
            FROM Tbl_Course_Department  
            WHERE Department_Id = @Department_Id 
              AND Course_Category_Id = @Course_Category_Id 
              AND Course_Department_Status = 0
        )              
        BEGIN              
            THROW 50000, ''Data Already Exists.'', 1;
            RETURN;
        END              
        
        DECLARE @CourseDepId BIGINT;
        DECLARE @Course_Dept VARCHAR(200);

        -- Insert new course department
        INSERT INTO Tbl_Course_Department(
            Course_Category_Id,
            Department_Id,
            course_Department_Description,              
            course_Department_Date,
            ProviderId
        )              
        VALUES(
            @Course_Category_Id,
            @Department_Id,
            @Course_Department_Description,
            @Course_Department_Date,
            @ProviderCode
        );              

        -- Get the newly inserted Course_Department_Id
        SET @CourseDepId = SCOPE_IDENTITY();     

        -- Construct Course_Dept Name
        SELECT @Course_Dept = 
            D.Department_Name + '' '' + CC.Course_Category_Name
        FROM Tbl_Course_Department CD
        INNER JOIN Tbl_Course_Category CC ON CD.Course_Category_Id = CC.Course_Category_Id            
        INNER JOIN Tbl_Department D ON CD.Department_Id = D.Department_Id            
        WHERE CD.Course_Department_Id = @CourseDepId;

        -- Insert into LMS_Tbl_Class
        INSERT INTO LMS_Tbl_Class(Class_Name, Is_Existing_Class, [Type], Type_Id)            
        VALUES(@Course_Dept, 1, ''Department'', @CourseDepId);
        
        -- Return the new Course_Department_Id
        SELECT @CourseDepId;     
    END;');
END;
