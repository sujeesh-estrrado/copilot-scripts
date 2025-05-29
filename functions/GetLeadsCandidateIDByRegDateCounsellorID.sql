IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GetLeadsCandidateIDByRegDateCounsellorID]') 
      AND type IN (N'FN', N'IF', N'TF') -- FN = Scalar, IF = Inline table, TF = Multi-statement table
)
BEGIN
    EXEC('
CREATE FUNCTION [dbo].[GetLeadsCandidateIDByRegDateCounsellorID] (@dtFrom date,@dtTo date,@counsellorID bigint)
RETURNS TABLE 
AS
RETURN 
(
    Select Candidate_Id From Tbl_Lead_Personal_Det
    Where ((@dtFrom is null and @dtTo is null)
            or convert(date,RegDate) between isnull(@dtFrom,''1900/1/1'') and isnull(@dtTo,''2200/1/1''))
        and (isnull(@counsellorID,0)<1 or CounselorEmployee_id=@counsellorID)
)


    ')
END
