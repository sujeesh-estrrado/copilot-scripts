IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_SubjectgradeDetails_ByCandid_Subname]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_Get_SubjectgradeDetails_ByCandid_Subname]
    (
        @Candidate_Id BIGINT = 0,
        @Sub_Name VARCHAR(MAX) = '''',
        @Education_Type VARCHAR(MAX) = ''''
    )  
    AS  
    BEGIN  
        SELECT *  
        FROM Tbl_Candidate_Education_Grade  
        WHERE Cand_Id = @Candidate_Id 
        AND Sub_Name = @Sub_Name 
        AND Education_Type = @Education_Type
    END
    ')
END;