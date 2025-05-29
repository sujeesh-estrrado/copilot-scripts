IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetEventDetailsById]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_GetEventDetailsById]
@Event_Id bigint
as
begin 
--Select Event_Id,Event_Title,Description,CONVERT(VARCHAR, LastSubmissionDate, 103) AS LastSubmissionDate,NumberOfSubmission,
--BannerImage,BannerDocument from Tbl_EventList 

Select EL.Event_Id,Event_Title,Description,CONVERT(VARCHAR, LastSubmissionDate, 103) AS LastSubmissionDate,NumberOfSubmission,
BannerImage,BannerDocument 
,PM.PaymentDetails,PM.Amount,
        QM.QuestionType,
        QM.Options,
        QM.UploadType,
        QM.Question
        from Tbl_EventList EL
left join Tbl_EventPaymentMapping PM on PM.Event_Id=EL.Event_Id
left join Tbl_EventQuestionMapping QM on QM.Event_Id=EL.Event_Id
where EL.Event_Id=@Event_Id and DelStatus=0
end

    ')
END;
