IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Intakes]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_Intakes]  --0,3       
(     
@Intake_Id bigint=0,
@flag bigint =0   
)     
AS        

BEGIN 
if(@flag=1)
begin       
INSERT into Tbl_reportRecruited_IntakeList(Intake_Id) VALUES(@Intake_Id)

end
if(@flag=2)
begin
select * from Tbl_reportRecruited_IntakeList
end
if(@flag=3)
begin
truncate table Tbl_reportRecruited_IntakeList
end
end');
END;
