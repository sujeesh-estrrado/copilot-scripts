IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetMonthAndYear]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_GetMonthAndYear]
(
    @ord_id BIGINT,
    @Course_category_id BIGINT,
    @flag BIGINT
)
AS
BEGIN
    IF (@flag = 1) -- Get months
    BEGIN
        IF EXISTS (SELECT * FROM Tbl_Configuration_Settings 
                  WHERE Config_Type = ''AdmissionFeeMapping'' AND Config_Status = ''true'')
        BEGIN
            SELECT DISTINCT 
                MONTH(CBD.Batch_From) AS month,
                FORMAT(CBD.Batch_From, ''MMMM'') AS monthname    
            FROM dbo.Tbl_Course_Batch_Duration AS CBD
            INNER JOIN fee_group f ON f.programIntakeID = CBD.Batch_Id
            INNER JOIN dbo.Tbl_Organzations AS O ON O.Organization_Id = CBD.Org_Id 
            INNER JOIN dbo.Tbl_Program_Duration AS PD ON CBD.Duration_Id = PD.Duration_Id 
            INNER JOIN dbo.Tbl_Department ON dbo.Tbl_Department.Department_Id = PD.Program_Category_Id 
            INNER JOIN dbo.Tbl_Course_Department AS CD ON CD.Department_Id = dbo.Tbl_Department.Department_Id 
            INNER JOIN dbo.Tbl_Course_Category AS CC ON CC.Course_Category_Id = CD.Course_Category_Id    
            WHERE (CBD.Batch_DelStatus = 0) 
              AND (dbo.Tbl_Department.Department_Status = 0) 
              AND O.Organization_Id = @ord_id     
              AND CC.Course_Category_Id = @Course_category_id 
              AND DATEADD(DAY, 1, CBD.Close_Date) >= GETDATE() 
            ORDER BY month ASC
        END
        ELSE
        BEGIN
            SELECT DISTINCT 
                MONTH(CBD.Batch_From) AS month,
                FORMAT(CBD.Batch_From, ''MMMM'') AS monthname    
            FROM dbo.Tbl_Course_Batch_Duration AS CBD
            LEFT JOIN fee_group f ON f.programIntakeID = CBD.Batch_Id
            INNER JOIN dbo.Tbl_Organzations AS O ON O.Organization_Id = CBD.Org_Id 
            INNER JOIN dbo.Tbl_Program_Duration AS PD ON CBD.Duration_Id = PD.Duration_Id 
            INNER JOIN dbo.Tbl_Department ON dbo.Tbl_Department.Department_Id = PD.Program_Category_Id 
            INNER JOIN dbo.Tbl_Course_Department AS CD ON CD.Department_Id = dbo.Tbl_Department.Department_Id 
            INNER JOIN dbo.Tbl_Course_Category AS CC ON CC.Course_Category_Id = CD.Course_Category_Id    
            WHERE (CBD.Batch_DelStatus = 0) 
              AND (dbo.Tbl_Department.Department_Status = 0) 
              AND O.Organization_Id = @ord_id     
              AND CC.Course_Category_Id = @Course_category_id 
              AND DATEADD(DAY, 1, CBD.Close_Date) >= GETDATE() 
            ORDER BY month ASC
        END
    END
    
    IF (@flag = 2) -- Get years
    BEGIN
        IF EXISTS (SELECT * FROM Tbl_Configuration_Settings 
                  WHERE Config_Type = ''AdmissionFeeMapping'' AND Config_Status = ''true'')
        BEGIN
            SELECT DISTINCT YEAR(CBD.Batch_From) AS year    
            FROM dbo.Tbl_Course_Batch_Duration AS CBD 
            INNER JOIN fee_group f ON f.programIntakeID = CBD.Batch_Id 
            INNER JOIN dbo.Tbl_Organzations AS O ON O.Organization_Id = CBD.Org_Id 
            INNER JOIN dbo.Tbl_Program_Duration AS PD ON CBD.Duration_Id = PD.Duration_Id 
            INNER JOIN dbo.Tbl_Department ON dbo.Tbl_Department.Department_Id = PD.Program_Category_Id 
            INNER JOIN dbo.Tbl_Course_Department AS CD ON CD.Department_Id = dbo.Tbl_Department.Department_Id 
            INNER JOIN dbo.Tbl_Course_Category AS CC ON CC.Course_Category_Id = CD.Course_Category_Id    
            WHERE (CBD.Batch_DelStatus = 0) 
              AND (dbo.Tbl_Department.Department_Status = 0)     
              AND O.Organization_Id = @ord_id     
              AND CC.Course_Category_Id = @Course_category_id 
              AND DATEADD(DAY, 1, CBD.Close_Date) >= GETDATE();
        END
        ELSE
        BEGIN
            SELECT DISTINCT YEAR(CBD.Batch_From) AS year    
            FROM dbo.Tbl_Course_Batch_Duration AS CBD 
            LEFT JOIN fee_group f ON f.programIntakeID = CBD.Batch_Id 
            INNER JOIN dbo.Tbl_Organzations AS O ON O.Organization_Id = CBD.Org_Id 
            INNER JOIN dbo.Tbl_Program_Duration AS PD ON CBD.Duration_Id = PD.Duration_Id 
            INNER JOIN dbo.Tbl_Department ON dbo.Tbl_Department.Department_Id = PD.Program_Category_Id 
            INNER JOIN dbo.Tbl_Course_Department AS CD ON CD.Department_Id = dbo.Tbl_Department.Department_Id 
            INNER JOIN dbo.Tbl_Course_Category AS CC ON CC.Course_Category_Id = CD.Course_Category_Id    
            WHERE (CBD.Batch_DelStatus = 0) 
              AND (dbo.Tbl_Department.Department_Status = 0)     
              AND O.Organization_Id = @ord_id     
              AND CC.Course_Category_Id = @Course_category_id 
              AND DATEADD(DAY, 1, CBD.Close_Date) >= GETDATE();
        END
    END
    
    IF (@flag = 3) -- Get months without date restriction
    BEGIN
        SELECT DISTINCT 
            MONTH(CBD.Batch_From) AS month,
            FORMAT(CBD.Batch_From, ''MMMM'') AS monthname    
        FROM dbo.Tbl_Course_Batch_Duration AS CBD 
        INNER JOIN fee_group f ON f.programIntakeID = CBD.Batch_Id 
        INNER JOIN dbo.Tbl_Organzations AS O ON O.Organization_Id = CBD.Org_Id 
        INNER JOIN dbo.Tbl_Program_Duration AS PD ON CBD.Duration_Id = PD.Duration_Id 
        INNER JOIN dbo.Tbl_Department ON dbo.Tbl_Department.Department_Id = PD.Program_Category_Id 
        INNER JOIN dbo.Tbl_Course_Department AS CD ON CD.Department_Id = dbo.Tbl_Department.Department_Id 
        INNER JOIN dbo.Tbl_Course_Category AS CC ON CC.Course_Category_Id = CD.Course_Category_Id    
        WHERE (CBD.Batch_DelStatus = 0) 
          AND (dbo.Tbl_Department.Department_Status = 0) 
          AND O.Organization_Id = @ord_id 
          AND CC.Course_Category_Id = @Course_category_id     
        ORDER BY month ASC
    END
    
    IF (@flag = 4) -- Get years without date restriction
    BEGIN
        SELECT DISTINCT YEAR(CBD.Batch_From) AS year    
        FROM dbo.Tbl_Course_Batch_Duration AS CBD 
        INNER JOIN fee_group f ON f.programIntakeID = CBD.Batch_Id 
        INNER JOIN dbo.Tbl_Organzations AS O ON O.Organization_Id = CBD.Org_Id 
        INNER JOIN dbo.Tbl_Program_Duration AS PD ON CBD.Duration_Id = PD.Duration_Id 
        INNER JOIN dbo.Tbl_Department ON dbo.Tbl_Department.Department_Id = PD.Program_Category_Id 
        INNER JOIN dbo.Tbl_Course_Department AS CD ON CD.Department_Id = dbo.Tbl_Department.Department_Id 
        INNER JOIN dbo.Tbl_Course_Category AS CC ON CC.Course_Category_Id = CD.Course_Category_Id    
        WHERE (CBD.Batch_DelStatus = 0) 
          AND (dbo.Tbl_Department.Department_Status = 0) 
          AND O.Organization_Id = @ord_id     
          AND CC.Course_Category_Id = @Course_category_id;
    END
END
');
END;