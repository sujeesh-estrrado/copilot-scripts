IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_LeadSearchTemplate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Insert_LeadSearchTemplate] 

@TabName nvarchar(Max),
--@UserId bigint,
--@CountryID bigint=0,
--@CounsellorId bigint=0,
--@SourceID int=0,
@FollowupDateFrom nvarchar(250),
@FollowupDateTo nvarchar(250),
@CreatedDateFrom nvarchar(250),
@CreatedDateTo nvarchar(250)
--@LeadStatusId bigint=0



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
insert into Tbl_LeadSearchTemplate(TabName,DelStatus,CreatedDateFrom,CreatedDateTo,FollowupDateFrom,FollowupDateTo)
values(@TabName,0,@CreatedDateFrom,@CreatedDateTo,@FollowupDateFrom,@FollowupDateTo)
 Select SCOPE_IDENTITY()
END

    ');
END;
