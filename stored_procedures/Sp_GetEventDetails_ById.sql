IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetEventDetails_ById]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_GetEventDetails_ById]
@EventId bigint
as
begin


select Event_Title,EL.Event_Id,
CONVERT(VARCHAR, EL.CreatedDate, 103) AS CreatedDate,
CONVERT(VARCHAR, LastSubmissionDate, 103) AS LastSubmissionDate,
BannerImage,
NumberOfSubmission,Description,EP.PaymentDetails,Amount
 from Tbl_EventList EL
left join Tbl_EventPaymentMapping EP on EP.Event_Id=EL.Event_Id
where DelStatus=0  
and EL.Event_Id=@EventId



end 

   ')
END;
