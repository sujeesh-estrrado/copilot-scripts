IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_InsertLeadstatusTemplateMapping]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_InsertLeadstatusTemplateMapping]
@templateid bigint,
@leadstatusid bigint
as
 begin 
 
 insert into LeadstatusTemplateMapping(LeadstatusId,TemplateId,DelStatus,Leadstatus) 
 values(@leadstatusid,@templateid,0,'''')
 end')
END
