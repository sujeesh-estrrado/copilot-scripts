IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetEventListStudentDashboard]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_GetEventListStudentDashboard]

as
begin


select Event_Title,Event_Id,
CONVERT(VARCHAR, CreatedDate, 103) AS CreatedDate,
CONVERT(VARCHAR, LastSubmissionDate, 103) AS LastSubmissionDate,
BannerImage,
NumberOfSubmission from Tbl_EventList where DelStatus=0  



end
   ')
END;
