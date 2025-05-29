IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Getall_templates]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Getall_templates] -- 10,1,''
        (
            @PageSize BIGINT,
            @CurrentPage BIGINT,
            @SearchKeyWord VARCHAR(MAX)
        )
        AS
        BEGIN
            DECLARE @UpperBand BIGINT
            DECLARE @LowerBand BIGINT

            SET @UpperBand = (@PageSize * @CurrentPage) + 1
            SET @LowerBand = (@PageSize * (@CurrentPage - 1))

            SELECT * 
            FROM (
                SELECT  
                    ROW_NUMBER() OVER (ORDER BY dbo.Tbl_Template_generation.Template_id DESC) AS RowNumber,
                    dbo.Tbl_Template_generation.Template_name,
                    CONVERT(VARCHAR, dbo.Tbl_Template_generation.created_date, 103) AS created_date,
                    CONVERT(VARCHAR, dbo.Tbl_Template_generation.updated_date, 103) AS updated_date,
                    ISNULL(dbo.Tbl_Employee.Employee_FName, '''') + '' '' + ISNULL(dbo.Tbl_Employee.Employee_LName, '''') AS empname,
                    dbo.Tbl_Template_generation.code,
                    Tbl_Template_generation.Template_id AS id
                FROM 
                    dbo.Tbl_User 
                    INNER JOIN dbo.Tbl_Template_generation ON dbo.Tbl_User.user_Id = dbo.Tbl_Template_generation.Created_by
                    LEFT JOIN dbo.Tbl_Employee_User 
                    INNER JOIN dbo.Tbl_Employee ON dbo.Tbl_Employee_User.Employee_Id = dbo.Tbl_Employee.Employee_Id 
                    ON dbo.Tbl_User.user_Id = dbo.Tbl_Employee_User.User_Id
                WHERE 
                    Tbl_Template_generation.delete_status = ''False'' 
                    AND (
                        Tbl_Template_generation.Template_id LIKE ''%'' + @SearchKeyWord + ''%'' OR
                        Tbl_Template_generation.Template_name LIKE ''%'' + @SearchKeyWord + ''%'' OR
                        CONVERT(VARCHAR, Tbl_Template_generation.created_date, 103) LIKE ''%'' + @SearchKeyWord + ''%'' OR
                        Tbl_Template_generation.Created_by LIKE ''%'' + @SearchKeyWord + ''%''
                    )
            ) AS tab
            WHERE RowNumber > @LowerBand AND RowNumber < @UpperBand
        END
    ')
END
