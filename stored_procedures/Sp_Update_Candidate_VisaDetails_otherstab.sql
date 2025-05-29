IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Update_Candidate_VisaDetails_otherstab]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Update_Candidate_VisaDetails_otherstab]
    -- Add the parameters for the stored procedure here
    @Candidate_Id bigint,
    @VisaAvailable varchar(50)='''',
    @VisaType varchar(50)='''',
    @SocialVisaType varchar(50)='''',
    @PassRefNo varchar(50)='''',
    @VisaExpDate varchar(50)='''',
    @IsCountryRefused varchar(50)='''',
    @IsConvicted varchar(50)='''',
    @IsProhibited varchar(50)='''',
    @IsEnterWithDiffPass varchar(50)='''',
    @KnownBy varchar(50)='''',
    @KnownByAdName varchar(50)='''',
    @KnownByOthersName varchar(50)='''',
    @PrevProgrammeName varchar(50)='''',
    @PrevInstitution varchar(50)='''',
    @PrevCourseDuration varchar(50)='''',
    @SourceAlam varchar(50)='''',
    @HowDidUKnow varchar(50)=''''

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    --SET NOCOUNT ON;

    -- Insert statements for procedure here
     UPDATE Tbl_Candidate_Personal_Det SET VisaAvailable = @VisaAvailable, VisaType = @VisaType, SocialVisaType = @SocialVisaType
     ,PassRefNo = @PassRefNo, VisaExpDate = @VisaExpDate, IsCountryRefused = @IsCountryRefused, IsConvicted = @IsConvicted
     ,IsProhibited = @IsProhibited, IsEnterWithDiffPass = @IsEnterWithDiffPass, KnownByAdName = @KnownByAdName
     ,KnownByOthersName = @KnownByOthersName, PrevProgrammeName = @PrevProgrammeName, PrevInstitution = @PrevInstitution
     ,PrevCourseDuration = @PrevCourseDuration
     --,KnownByAlam=@SourceAlam
     ,How_did_you_findout_about_SevenSkiesInternationalSchool=@HowDidUKnow WHERE Candidate_Id = @Candidate_Id
END
    ')
END
