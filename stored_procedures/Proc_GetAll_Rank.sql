-- Check if the stored procedure [dbo].[Proc_GetAll_Rank] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAll_Rank]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetAll_Rank]
        AS
        BEGIN
            SELECT 
                r.dept_rank_id, 
                r.dept_year,
                r.level_id,
                r.cat_id,
                rm.rank_details_id,
                rm.dept_id,
                rm.rank,
                cl.Course_Level_Name,
                cc.Course_Category_Name,
                d.Department_Name
            FROM dbo.Tbl_Rank_Master r 
            LEFT JOIN dbo.Tbl_Rank_Master_Details rm 
                ON r.dept_rank_id = rm.dept_rank_id
            LEFT JOIN dbo.Tbl_Course_Level cl 
                ON cl.Course_Level_Id = r.level_id
            LEFT JOIN dbo.Tbl_Course_Category cc 
                ON cc.Course_Category_Id = r.cat_id
            LEFT JOIN dbo.Tbl_Department d 
                ON d.Department_Id = rm.dept_id
            WHERE r.del_status = 0
        END
    ')
END
