IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LoadClassEnrollment]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LoadClassEnrollment]
@Id int
as
begin

    SELECT 
        d.Department_Name Department_Descripition,
        
        CONCAT(d.Department_Id,''#'',c.Batch_Id) AS Batch_Id
    FROM 
        Tbl_Course_Batch_Duration c
        left join Tbl_Department d ON c.Duration_Id = d.Department_Id
    WHERE 
        c.IntakeMasterID = @Id and @Id>0
        --AND d.Department_Descripition IS NOT NULL 
        --AND d.Department_Descripition != '''';

END
    ')
END;
