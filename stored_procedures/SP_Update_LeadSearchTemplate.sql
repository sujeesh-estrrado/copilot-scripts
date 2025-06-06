IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_LeadSearchTemplate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
      CREATE PROCEDURE [dbo].[SP_Update_LeadSearchTemplate]
@TabName nvarchar(Max),
@templateId bigint,
--@CountryID bigint=0,
--@CounsellorId bigint=0,
--@SourceID int=0,
@FollowupDateFrom nvarchar(50),
@FollowupDateTo nvarchar(50),
@CreatedDateFrom nvarchar(50),
@CreatedDateTo nvarchar(50),
@UserId bigint



AS
BEGIN
DECLARE @ID BIGINT=0;      

--Insert into [Tbl_LeadSearchTemplate](TabName,NationalityID,LeadstatusID,SourceId,
--CounsellorId,FollowupDateFrom,FollowupDateTo,
--CreatedDateFrom,CreatedDateTo,DelStatus) 
--values(@TabName,@CountryID,@LeadstatusID,@SourceId,@CounsellorId,
--GETDATE(),GETDATE(),GETDATE(),GETDATE(),0)
-- SET @ID=@@IDENTITY 
-- SELECT @ID  
update Tbl_LeadSearchTemplate set TabName=@TabName ,
CreatedDateFrom=@CreatedDateFrom,
CreatedDateTo=@CreatedDateTo,
FollowupDateFrom=@FollowupDateFrom,
FollowupDateTo=@FollowupDateTo,
CreatedBy=@UserId


where TemplateId=@templateId
 Select SCOPE_IDENTITY()
END
    ')
END
