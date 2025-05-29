IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetPermanentForms]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_GetPermanentForms]
    @flag BIGINT = 1,
    @createddatefrom NVARCHAR(50) = NULL,
    @createddateto NVARCHAR(50) = NULL,
    @status int = NULL

AS
BEGIN
    IF (@flag = 1)
    BEGIN
        SELECT 
            Permanent_FormId,
            Form_Title,
            CONVERT(VARCHAR, Created_Date, 103) AS Created_Date,
            Delete_Status,
            Form_Type,
            Status ,
            CASE 
                WHEN Status = 1 THEN ''Published''
                WHEN Status = 2 THEN ''Unpublished''
            END AS Status
        FROM 
            Tbl_PermanentForm PF
        WHERE 
            Delete_Status = 0
            AND (
                @createddatefrom IS NULL OR @createddatefrom = '''' 
                OR CONVERT(DATE, PF.Created_Date) >= CONVERT(DATE, @createddatefrom)
            )
            AND (
                @createddateto IS NULL OR @createddateto = '''' 
                OR CONVERT(DATE, PF.Created_Date) <= CONVERT(DATE, @createddateto)
            )
           
                
                --AND (@status IS NULL OR PF.Status IN (1, 2))
                AND (PF.Status = @status OR @status = 0)
            
        
    END
END
    ')
END;
