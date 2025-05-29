IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetCustomFilterById]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_GetCustomFilterById]
@templateid bigint
as
 begin 
 
 select TabName,NationalityID,C.Country,LeadstatusID,SourceId,CounsellorId from Tbl_LeadSearchTemplate ST
 inner join Tbl_Country C on C.Country_Id=ST.NationalityID
 where TemplateId=@templateid
 
 end');
END;
