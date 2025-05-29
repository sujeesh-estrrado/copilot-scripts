IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_VisaLog]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Insert_VisaLog]
@LogDet varchar(500),
@Candidate_Id bigint,
@Old varchar(50)='''',
@New varchar(50)='''',
@empid bigint
as
begin
insert into Tbl_Visa_Log Values(@LogDet,@Candidate_Id,GETDATE(),@Old,@New,@empid)

end
    ')
END;
