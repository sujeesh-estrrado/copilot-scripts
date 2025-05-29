IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_candidate_Visa_details_by_CandidateId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[sp_Get_candidate_Visa_details_by_CandidateId]
    -- Add the parameters for the stored procedure here
    @Candidate_Id bigint
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT VisaAvailable, VisaType , SocialVisaType 
     ,PassRefNo ,CONVERT(VARCHAR(10),  VisaExpDate, 21)  AS  VisaExpDate , IsCountryRefused , IsConvicted 
     ,IsProhibited  , IsEnterWithDiffPass  , KnownBy , KnownByAdName,KnownByAlam
     ,KnownByOthersName , PrevProgrammeName , PrevInstitution ,SourceofInformation,How_did_you_findout_about_SevenSkiesInternationalSchool
     ,PrevCourseDuration  FROM Tbl_Candidate_Personal_Det where candidate_id=@Candidate_Id
END

    ')
END
