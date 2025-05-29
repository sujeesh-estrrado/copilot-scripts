IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Marketing_EnquiryMedium_GraphicalReport]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_Marketing_EnquiryMedium_GraphicalReport] 
    AS      
    BEGIN 
        DECLARE @agentenqcount BIGINT;
        DECLARE @viaonline BIGINT;
        DECLARE @viaExcel BIGINT;
        DECLARE @viassystem BIGINT;

        SET @agentenqcount = (
            SELECT COUNT(Agent_Id) 
            FROM Tbl_Candidate_Personal_Det 
            WHERE Agent_Id != 0 AND Agent_Id != '''' AND active = 1
        );

        SET @viaonline = (
            SELECT COUNT(Enquiry_From) 
            FROM Tbl_Candidate_Personal_Det 
            WHERE Enquiry_From = ''Online'' AND active = 1
        );

        SET @viaExcel = (
            SELECT COUNT(Enquiry_From) 
            FROM Tbl_Candidate_Personal_Det 
            WHERE Enquiry_From = ''Excel Upload'' AND active = 1
        );

        SET @viassystem = (
            SELECT COUNT(Candidate_Id)  
            FROM Tbl_Candidate_Personal_Det 
            WHERE active = 1 
                AND (Enquiry_From = ''Counsellor'' OR Enquiry_From IS NULL) 
                AND (Agent_ID = 0 OR Agent_ID IS NULL)
        );

        CREATE TABLE #tempchart (
            valuetype VARCHAR(MAX), 
            value BIGINT
        );

        INSERT INTO #tempchart (valuetype, value)
        VALUES
            (''Agent'', @agentenqcount),
            (''Online'', @viaonline),
            (''Excel Upload'', @viaExcel),
            (''System'', @viassystem);

        SELECT * FROM #tempchart WHERE value != 0;

        DROP TABLE #tempchart;
    END;')
END;
