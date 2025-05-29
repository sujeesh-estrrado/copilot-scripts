IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Update_Candidate_VisaDetails_enqtab]')
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_Update_Candidate_VisaDetails_enqtab]
	-- Add the parameters for the stored procedure here
	@Candidate_Id bigint,
	
	@KnownBy varchar(50)='''',
	@KnownByAdName varchar(50)='''',
	@KnownByOthersName varchar(50)='''',
	
	@SourceAlam varchar(50)='''',
	@HowDidUKnow varchar(50)=''''

AS
BEGIN
	
	 UPDATE Tbl_Candidate_Personal_Det SET  KnownBy = @KnownBy, KnownByAdName = @KnownByAdName
	 ,KnownByOthersName = @KnownByOthersName 
	 ,KnownByAlam=@SourceAlam
	 ,How_did_you_findout_about_SevenSkiesInternationalSchool=@HowDidUKnow WHERE Candidate_Id = @Candidate_Id
END
')
END
GO
